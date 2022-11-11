// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import 'forge-std/Test.sol';
import {GovHelpers} from 'aave-helpers/GovHelpers.sol';
import {BridgeExecutorHelpers} from 'aave-helpers/BridgeExecutorHelpers.sol';
import {AaveGovernanceV2, IExecutorWithTimelock} from 'aave-address-book/AaveGovernanceV2.sol';
import {AaveV2Ethereum} from 'aave-address-book/AaveV2Ethereum.sol';
import {AaveV3Polygon} from 'aave-address-book/AaveV3Polygon.sol';
import {IStateReceiver} from 'governance-crosschain-bridges/contracts/dependencies/polygon/fxportal/FxChild.sol';
import {PolygonClaimPayload} from '../src/contracts/PolygonClaimPayload.sol';
import {EthereumClaimPayload} from '../src/contracts/EthereumClaimPayload.sol';
import {OptimismClaimPayload} from '../src/contracts/OptimismClaimPayload.sol';
import {ParaswapClaimer} from '../src/lib/ParaswapClaimer.sol';
import {IFeeClaimer} from '../src/interfaces/IFeeClaimer.sol';
import {IERC20} from '../src/interfaces/IERC20.sol';
import {DeployL1Proposal} from '../scripts/DeployL1Proposal.s.sol';

/**
 * This tests test the basic fee claiming flow.
 */
contract ProposalExecutionTest is Test {
  // the identifiers of the forks
  uint256 mainnetFork;
  uint256 polygonFork;
  uint256 optimismFork;

  // the two proposals (rest can be done by guardian)
  EthereumClaimPayload public mainnetProposal;
  PolygonClaimPayload public polygonProposal;
  OptimismClaimPayload public optimismProposal;

  // addresses required to mock l2 execution
  address public constant BRIDGE_ADMIN =
    0x0000000000000000000000000000000000001001;
  address public constant FX_CHILD_ADDRESS =
    0x8397259c983751DAf40400790063935a11afa28a;
  address public constant POLYGON_BRIDGE_EXECUTOR =
    0xdc9A35B16DB4e126cFeDC41322b3a36454B1F772;

  address internal constant CROSSCHAIN_FORWARDER_POLYGON =
    address(0x158a6bC04F0828318821baE797f50B0A1299d45b);

  address internal constant CROSSCHAIN_FORWARDER_OPTIMISM =
    address(0x5f5C02875a8e9B5A26fbd09040ABCfDeb2AA6711);

  // erc20 to check
  IERC20 constant WETH_ETHEREUM =
    IERC20(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
  IERC20 constant WETH_POLYGON =
    IERC20(0x7ceB23fD6bC0adD59E62ac25578270cFf1b9f619);

  // deploy proposals
  function setUp() public {
    mainnetFork = vm.createSelectFork(vm.rpcUrl('ethereum'), 15732799);
    mainnetProposal = new EthereumClaimPayload();
    polygonFork = vm.createSelectFork(vm.rpcUrl('polygon'), 34255398);
    polygonProposal = new PolygonClaimPayload();
    optimismFork = vm.createSelectFork(vm.rpcUrl('optimism'), 37108390);
    optimismProposal = new OptimismClaimPayload();
  }

  /**
   * @dev executes proposal on polygon and mainnet
   */
  function test_proposalE2E() public {
    // 1. store balances before
    vm.selectFork(mainnetFork);
    uint256 wethEthBefore = WETH_ETHEREUM.balanceOf(AaveV2Ethereum.COLLECTOR);
    vm.selectFork(polygonFork);
    uint256 wethPolyBefore = WETH_POLYGON.balanceOf(AaveV3Polygon.COLLECTOR);

    // 2. create l1 proposal
    vm.selectFork(mainnetFork);
    vm.startPrank(GovHelpers.AAVE_WHALE);
    DeployL1Proposal.Execution[]
      memory execution = new DeployL1Proposal.Execution[](3);

    DeployL1Proposal.Execution[]
      memory executions = new DeployL1Proposal.Execution[](3);
    executions[0] = DeployL1Proposal.Execution({
      target: address(mainnetProposal),
      signature: 'execute()',
      callData: ''
    });
    executions[1] = DeployL1Proposal.Execution({
      target: CROSSCHAIN_FORWARDER_POLYGON,
      signature: 'execute(address)',
      callData: abi.encode(polygonProposal)
    });
    executions[2] = DeployL1Proposal.Execution({
      target: CROSSCHAIN_FORWARDER_OPTIMISM,
      signature: 'execute(address)',
      callData: abi.encode(optimismProposal)
    });

    uint256 proposalId = DeployL1Proposal._deployL1Proposal(
      executions,
      0xf6e50d5a3f824f5ab4ffa15fb79f4fa1871b8bf7af9e9b32c1aaaa9ea633006d
    );
    vm.stopPrank();

    // 3. execute proposal and record logs so we can extract the emitted StateSynced event
    vm.recordLogs();
    GovHelpers.passVoteAndExecute(vm, proposalId);

    Vm.Log[] memory entries = vm.getRecordedLogs();
    uint256 index = 0;
    for (uint256 i = 0; i < entries.length; i++) {
      if (
        keccak256('StateSynced(uint256,address,bytes)') == entries[i].topics[0]
      ) {
        index = i;
      }
    }
    require(index != 0, 'EVENT_NOT_FOUND');
    assertEq(
      keccak256('StateSynced(uint256,address,bytes)'),
      entries[index].topics[0]
    );
    assertEq(
      address(uint160(uint256(entries[index].topics[2]))),
      FX_CHILD_ADDRESS
    );

    // 4. mock the receive on l2 with the data emitted on StateSynced
    vm.selectFork(polygonFork);
    vm.startPrank(BRIDGE_ADMIN);
    IStateReceiver(FX_CHILD_ADDRESS).onStateReceive(
      uint256(entries[index].topics[1]),
      this._cutBytes(entries[index].data)
    );
    vm.stopPrank();

    // 5. execute proposal on l2
    BridgeExecutorHelpers.waitAndExecuteLatest(vm, POLYGON_BRIDGE_EXECUTOR);

    // 6. make some assumptions about treasury
    vm.selectFork(mainnetFork);
    assertGt(WETH_ETHEREUM.balanceOf(AaveV2Ethereum.COLLECTOR), wethEthBefore);
    vm.selectFork(polygonFork);
    assertGt(WETH_POLYGON.balanceOf(AaveV3Polygon.COLLECTOR), wethPolyBefore);
  }

  // utility to transform memory to calldata so array range access is available
  function _cutBytes(bytes calldata input)
    public
    pure
    returns (bytes calldata)
  {
    return input[64:];
  }
}
