// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {AaveV3Polygon} from 'aave-address-book/AaveV3Polygon.sol';
import {IProposalGenericExecutor} from '../interfaces/IProposalGenericExecutor.sol';
import {IFeeClaimer} from '../interfaces/IFeeClaimer.sol';
import {ParaswapClaimer} from '../lib/ParaswapClaimer.sol';
import {ParaswapClaim} from './ParaswapClaim.sol';

/**
 * @title PolygonClaimPayload
 * @author BGD Labs
 * @notice Aave governance payload to claim rewards accrued as positive slippage on paraswap to the polygon collector.
 */
contract PolygonClaimPayload is IProposalGenericExecutor, ParaswapClaim {
  address public constant POLYGON_BRIDGE_EXECUTOR =
    0xdc9A35B16DB4e126cFeDC41322b3a36454B1F772;

  function execute() external override {
    address[] memory tokens = AaveV3Polygon.POOL.getReservesList();
    claim(
      ParaswapClaimer.POLYGON,
      POLYGON_BRIDGE_EXECUTOR,
      address(AaveV3Polygon.COLLECTOR),
      tokens
    );
  }
}
