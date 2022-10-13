// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IPool} from 'aave-address-book/AaveV3.sol';
import {IFeeClaimer} from '../interfaces/IFeeClaimer.sol';
import {ParaswapClaimer} from '../lib/ParaswapClaimer.sol';

/**
 * Generic contract for claiming all available rewards from paraswap to a specified address.
 */
contract ParaswapClaim {
  /**
   * @dev Batch claims the fee accrued for `aaveClaimer` on `paraswapClaimer` for all supplied tokens.
   * @param feeClaimer The paraswap fee claimer of the network. ref: https://developers.paraswap.network/smart-contracts#fee-claimer
   * @param aaveClaimer The elegible claimer of the aave protocol.
   * @param receiver The beneficiary of the claim call.
   */
  function claim(
    IFeeClaimer feeClaimer,
    address aaveClaimer,
    address receiver,
    address[] memory tokens
  ) internal {
    // paraswap errors when one of the balances is 0 so we need to filter them beforehand
    uint256[] memory balances = feeClaimer.batchGetBalance(
      tokens,
      aaveClaimer
    );
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
    feeClaimer.batchWithdrawAllERC20(claimableTokens, receiver);
  }
}
