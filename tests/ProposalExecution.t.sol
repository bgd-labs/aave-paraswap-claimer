// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import 'forge-std/Test.sol';
import {GovHelpers} from 'aave-helpers/GovHelpers.sol';
import {BridgeExecutorHelpers} from 'aave-helpers/BridgeExecutorHelpers.sol';
import {AaveGovernanceV2, IExecutorWithTimelock} from 'aave-address-book/AaveGovernanceV2.sol';
import {AaveV3Polygon} from 'aave-address-book/AaveV3Polygon.sol';
import {IStateReceiver} from 'governance-crosschain-bridges/contracts/dependencies/polygon/fxportal/FxChild.sol';
import {ClaimParaswapPolygon} from '../src/contracts/ClaimParaswapPolygon.sol';
import {ClaimParaswapEthereum} from '../src/contracts/ClaimParaswapEthereum.sol';
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

  // the two proposals (rest can be done by guardian)
  ClaimParaswapEthereum public mainnetProposal;
  ClaimParaswapPolygon public polygonProposal;

  // addresses required to mock l2 execution
  address public constant BRIDGE_ADMIN =
    0x0000000000000000000000000000000000001001;
  address public constant FX_CHILD_ADDRESS =
    0x8397259c983751DAf40400790063935a11afa28a;
  address public constant POLYGON_BRIDGE_EXECUTOR =
    0xdc9A35B16DB4e126cFeDC41322b3a36454B1F772;

  // erc20 to check
  address constant WETH_ETHEREUM = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
  address constant WETH_POLYGON = 0x7ceB23fD6bC0adD59E62ac25578270cFf1b9f619;

  // deploy proposals
  function setUp() public {
    mainnetFork = vm.createSelectFork(vm.rpcUrl('ethereum'), 15732799);
    mainnetProposal = new ClaimParaswapEthereum();
    polygonFork = vm.createSelectFork(vm.rpcUrl('polygon'), 34255398);
    polygonProposal = new ClaimParaswapPolygon();
  }

  /**
   * @dev executes proposal on polygon and mainnet
   */
  function test_proposalE2E() public {
    // 2. create l1 proposal
    vm.selectFork(mainnetFork);
    vm.startPrank(GovHelpers.AAVE_WHALE);
    uint256 proposalId = DeployL1Proposal._deployL1Proposal(
      address(mainnetProposal),
      address(polygonProposal),
      0xf6e50d5a3f824f5ab4ffa15fb79f4fa1871b8bf7af9e9b32c1aaaa9ea633006d
    );
    vm.stopPrank();

    // 3. execute proposal and record logs so we can extract the emitted StateSynced event
    vm.recordLogs();
    GovHelpers.passVoteAndExecute(vm, proposalId);

    Vm.Log[] memory entries = vm.getRecordedLogs();
    assertEq(
      keccak256('StateSynced(uint256,address,bytes)'),
      entries[4].topics[0]
    );
    assertEq(address(uint160(uint256(entries[4].topics[2]))), FX_CHILD_ADDRESS);

    // 4. mock the receive on l2 with the data emitted on StateSynced
    vm.selectFork(polygonFork);
    vm.startPrank(BRIDGE_ADMIN);
    IStateReceiver(FX_CHILD_ADDRESS).onStateReceive(
      uint256(entries[4].topics[1]),
      this._cutBytes(entries[4].data)
    );
    vm.stopPrank();

    // 5. execute proposal on l2
    BridgeExecutorHelpers.waitAndExecuteLatest(vm, POLYGON_BRIDGE_EXECUTOR);

    // make some assumptions about treasury
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
