// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {AaveV3Optimism} from 'aave-address-book/AaveV3Optimism.sol';
import {IProposalGenericExecutor} from '../interfaces/IProposalGenericExecutor.sol';
import {IFeeClaimer} from '../interfaces/IFeeClaimer.sol';
import {ParaswapClaimer} from '../lib/ParaswapClaimer.sol';
import {ParaswapClaim} from './ParaswapClaim.sol';

/**
 * @title OptimismClaimPayload
 * @author BGD Labs
 * @notice Aave governance payload to claim rewards accrued as positive slippage on paraswap to the optimism collector.
 */
contract OptimismClaimPayload is IProposalGenericExecutor, ParaswapClaim {
  address public constant OPTIMISM_BRIDGE_EXECUTOR =
    0xdc9A35B16DB4e126cFeDC41322b3a36454B1F772;

  function execute() external override {
    address[] memory tokens = AaveV3Optimism.POOL.getReservesList();
    claim(
      ParaswapClaimer.OPTIMISM,
      OPTIMISM_BRIDGE_EXECUTOR,
      AaveV3Optimism.COLLECTOR,
      tokens
    );
  }
}
