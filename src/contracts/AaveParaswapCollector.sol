// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import {IFeeClaimer} from '../interfaces/IFeeClaimer.sol';
import {IERC20} from '../interfaces/IERC20.sol';

/**
 * Helper contract that allows claiming paraswap partner fee to the AAVE_TREASURY on the current network.
 */
contract AaveParaswapCollector {
  address public immutable AAVE_TREASURY;
  IFeeClaimer public immutable PARASWAP_FEE_CLAIMER;

  constructor(address treasury, address paraswapFeeClaimer) {
    AAVE_TREASURY = treasury;
    PARASWAP_FEE_CLAIMER = IFeeClaimer(paraswapFeeClaimer);
  }

  /**
   * @dev returns claimable balances for specified assets
   */
  function getClaimable(address[] memory assets)
    public
    view
    returns (uint256[] memory)
  {
    return PARASWAP_FEE_CLAIMER.batchGetBalance(assets, address(this));
  }

  /**
   * @dev withdraws a single asset to the aave treasury
   * @notice will revert when there's nothing to claim
   */
  function claimToTreasury(IERC20 asset) external {
    PARASWAP_FEE_CLAIMER.withdrawAllERC20(asset, AAVE_TREASURY);
  }

  /**
   * @dev withdraws all asset to the aave treasury
   * @notice will revert when there's nothing to claim on a single supplied asset
   */
  function batchClaimToTreasury(address[] memory assets) external {
    PARASWAP_FEE_CLAIMER.batchWithdrawAllERC20(assets, AAVE_TREASURY);
  }
}
