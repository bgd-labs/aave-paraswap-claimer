// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import {IFeeClaimer} from '../interfaces/IFeeClaimer.sol';
import {IERC20} from '../interfaces/IERC20.sol';

/**
 * Helper contract that allows claiming paraswap partner fee to the collector on the respective network.
 */
contract AaveParaswapCollector {
  address public immutable collector;
  IFeeClaimer public immutable paraswapFeeClaimer;

  constructor(address _collector, address _paraswapFeeClaimer) {
    collector = _collector;
    paraswapFeeClaimer = IFeeClaimer(_paraswapFeeClaimer);
  }

  /**
   * @dev returns claimable balance for a specified asset
   * @param asset The asset to fetch claimable balance of
   */
  function getClaimable(address asset) public view returns (uint256) {
    return paraswapFeeClaimer.getBalance(IERC20(asset), address(this));
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
    return paraswapFeeClaimer.batchGetBalance(assets, address(this));
  }

  /**
   * @dev withdraws a single asset to the collector
   * @notice will revert when there's nothing to claim
   * @param asset The asset to claim rewards of
   */
  function claimToCollector(IERC20 asset) external {
    paraswapFeeClaimer.withdrawAllERC20(asset, collector);
  }

  /**
   * @dev withdraws all asset to the collector
   * @notice will revert when there's nothing to claim on a single supplied asset
   * @param assets The assets to claim rewards of
   */
  function batchClaimToCollector(address[] memory assets) external {
    paraswapFeeClaimer.batchWithdrawAllERC20(assets, collector);
  }
}
