// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {AaveV3Polygon} from 'aave-address-book/AaveV3Polygon.sol';
import {IProposalGenericExecutor} from '../interfaces/IProposalGenericExecutor.sol';
import {IFeeClaimer} from '../interfaces/IFeeClaimer.sol';
import {ParaswapClaimer} from '../lib/ParaswapClaimer.sol';

contract ClaimParaswapPolygon is IProposalGenericExecutor {
  address public constant POLYGON_BRIDGE_EXECUTOR =
    0xdc9A35B16DB4e126cFeDC41322b3a36454B1F772;

  function execute() external override {
    address[] memory tokens = AaveV3Polygon.POOL.getReservesList();
    uint256[] memory balances = IFeeClaimer(ParaswapClaimer.POLYGON)
      .batchGetBalance(tokens, POLYGON_BRIDGE_EXECUTOR);
    uint256 count = 0;
    for (uint256 i; i < balances.length; i++) {
      if (balances[i] != 0) count += 1;
    }
    address[] memory claimableTokens = new address[](count);
    uint256 currentIndex = 0;
    for (uint256 i; i < balances.length; i++) {
      if (balances[i] != 0) {
        claimableTokens[currentIndex] = tokens[i];
        currentIndex += 1;
      }
    }
    require(currentIndex == count, 'NON_MATCHING_LENGTH');
    IFeeClaimer(ParaswapClaimer.POLYGON).batchWithdrawAllERC20(
      claimableTokens,
      AaveV3Polygon.COLLECTOR
    );
  }
}
