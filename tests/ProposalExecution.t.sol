// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import 'forge-std/Test.sol';
import {GovHelpers} from 'aave-helpers/GovHelpers.sol';
import {CommonTestBase} from 'aave-helpers/CommonTestBase.sol';
import {AaveGovernanceV2, IExecutorWithTimelock} from 'aave-address-book/AaveGovernanceV2.sol';
import {AaveV2Ethereum} from 'aave-address-book/AaveV2Ethereum.sol';
import {AaveV2Avalanche} from 'aave-address-book/AaveV2Avalanche.sol';
import {AaveV3Polygon} from 'aave-address-book/AaveV3Polygon.sol';
import {AaveV3Optimism} from 'aave-address-book/AaveV3Optimism.sol';
import {AaveV3Arbitrum} from 'aave-address-book/AaveV3Arbitrum.sol';
import {AaveV3Fantom} from 'aave-address-book/AaveV3Fantom.sol';
import {IStateReceiver} from 'governance-crosschain-bridges/contracts/dependencies/polygon/fxportal/FxChild.sol';
import {PolygonClaimPayload} from '../src/contracts/PolygonClaimPayload.sol';
import {EthereumClaimPayload} from '../src/contracts/EthereumClaimPayload.sol';
import {ParaswapClaimer} from '../src/lib/ParaswapClaimer.sol';
import {IFeeClaimer} from '../src/interfaces/IFeeClaimer.sol';
import {IERC20} from '../src/interfaces/IERC20.sol';
import {DeployL1Proposal} from '../scripts/DeployL1Proposal.s.sol';
import {IERC20Metadata} from 'solidity-utils/contracts/oz-common/interfaces/IERC20Metadata.sol';

abstract contract ProposalTest is CommonTestBase {
  function _testClaim(
    address[] memory reserves,
    IFeeClaimer claimer,
    address partner
  ) public {
    uint256[] memory fees = claimer.batchGetBalance(reserves, partner);
    string memory symbol;
    for (uint256 i = 0; i < reserves.length; i++) {
      if (reserves[i] == 0x9f8F72aA9304c8B593d555F12eF6589cC3A579A2)
        symbol = 'MKR';
      else symbol = IERC20Metadata(reserves[i]).symbol();

      emit log_named_decimal_uint(
        symbol,
        fees[i],
        IERC20Metadata(reserves[i]).decimals()
      );
    }
  }
}

contract MainnetTest is ProposalTest {
  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('ethereum'), 19112149);
  }

  function test_claimable() public {
    _testClaim(
      AaveV2Ethereum.POOL.getReservesList(),
      ParaswapClaimer.ETHEREUM,
      AaveGovernanceV2.SHORT_EXECUTOR
    );
  }

  function test_proposalExecution() public {
    EthereumClaimPayload payload = new EthereumClaimPayload();
    GovHelpers.executePayload(
      vm,
      address(payload),
      AaveGovernanceV2.SHORT_EXECUTOR
    );
  }
}

contract PolygonTest is ProposalTest {
  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('polygon'), 52885122);
  }

  function test_claimable() public {
    _testClaim(
      AaveV3Polygon.POOL.getReservesList(),
      ParaswapClaimer.POLYGON,
      AaveGovernanceV2.POLYGON_BRIDGE_EXECUTOR
    );
  }
}

contract OptimismTest is ProposalTest {
  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('optimism'), 115467554);
  }

  function test_claimable() public {
    _testClaim(
      AaveV3Optimism.POOL.getReservesList(),
      ParaswapClaimer.OPTIMISM,
      0xE50c8C619d05ff98b22Adf991F17602C774F785c
    );
  }
}

contract AvalancheTest is ProposalTest {
  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('avalanche'), 40986517);
  }

  function test_claimable() public {
    _testClaim(
      AaveV2Avalanche.POOL.getReservesList(),
      ParaswapClaimer.AVALANCHE,
      0xa35b76E4935449E33C56aB24b23fcd3246f13470
    );
  }
}

contract ArbitrumTest is ProposalTest {
  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('arbitrum'), 175393743);
  }

  function test_claimable() public {
    _testClaim(
      AaveV3Arbitrum.POOL.getReservesList(),
      ParaswapClaimer.ARBITRUM,
      0xbbd9f90699c1FA0D7A65870D241DD1f1217c96Eb
    );
  }
}

contract FantomTest is ProposalTest {
  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('fantom'), 74892952);
  }

  function test_claimable() public {
    _testClaim(
      AaveV3Fantom.POOL.getReservesList(),
      ParaswapClaimer.FANTOM,
      0x39CB97b105173b56b5a2b4b33AD25d6a50E6c949
    );
  }
}
