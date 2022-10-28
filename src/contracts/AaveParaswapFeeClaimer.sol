// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import {IFeeClaimer} from '../interfaces/IFeeClaimer.sol';
import {IERC20} from '../interfaces/IERC20.sol';

/**
 * @title AaveParaswapFeeClaimer
 * @author BGD Labs
 * @dev Helper contract that allows claiming paraswap partner fee to the collector on the respective network.
 */
contract AaveParaswapFeeClaimer {
  address public immutable COLLECTOR;
  IFeeClaimer public immutable PARASWAP_FEE_CLAIMER;

  constructor(address _collector, IFeeClaimer _paraswapFeeClaimer) {
    COLLECTOR = _collector;
    PARASWAP_FEE_CLAIMER = _paraswapFeeClaimer;
  }

  /**
   * @dev returns claimable balance for a specified asset
   * @param asset The asset to fetch claimable balance of
   */
  function getClaimable(address asset) public view returns (uint256) {
    return PARASWAP_FEE_CLAIMER.getBalance(IERC20(asset), address(this));
  }

  /**
   * @dev returns claimable balances for specified assets
   * @param assets The assets to fetch claimable balances of
   */
  function batchGetClaimable(address[] memory assets)
    public
    view
    returns (uint256[] memory)
  {
    return PARASWAP_FEE_CLAIMER.batchGetBalance(assets, address(this));
  }

  /**
   * @dev withdraws a single asset to the collector
   * @notice will revert when there's nothing to claim
   * @param asset The asset to claim rewards of
   */
  function claimToCollector(IERC20 asset) external {
    PARASWAP_FEE_CLAIMER.withdrawAllERC20(asset, COLLECTOR);
  }

  /**
   * @dev withdraws all asset to the collector
   * @notice will revert when there's nothing to claim on a single supplied asset
   * @param assets The assets to claim rewards of
   */
  function batchClaimToCollector(address[] memory assets) external {
    PARASWAP_FEE_CLAIMER.batchWithdrawAllERC20(assets, COLLECTOR);
  }
}
