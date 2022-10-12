// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {AaveV2Ethereum} from 'aave-address-book/AaveV2Ethereum.sol';
import {IProposalGenericExecutor} from '../interfaces/IProposalGenericExecutor.sol';
import {IFeeClaimer} from '../interfaces/IFeeClaimer.sol';
import {ParaswapClaimer} from '../lib/ParaswapClaimer.sol';

contract ClaimParaswapEthereum is IProposalGenericExecutor {
  function execute() external override {
    address[] memory tokens = AaveV2Ethereum.POOL.getReservesList();
    uint256[] memory balances = IFeeClaimer(ParaswapClaimer.ETHEREUM)
      .batchGetBalance(tokens, 0xEE56e2B3D491590B5b31738cC34d5232F378a8D5);
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
    IFeeClaimer(ParaswapClaimer.ETHEREUM).batchWithdrawAllERC20(
      claimableTokens,
      AaveV2Ethereum.COLLECTOR
    );
  }
}
