// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import 'forge-std/Test.sol';
import {AaveV3Polygon} from 'aave-address-book/AaveV3Polygon.sol';
import {AaveParaswapFeeClaimer} from '../src/contracts/AaveParaswapFeeClaimer.sol';
import {ParaswapClaimer} from '../src/lib/ParaswapClaimer.sol';
import {IFeeClaimer} from '../src/interfaces/IFeeClaimer.sol';
import {IERC20} from '../src/interfaces/IERC20.sol';

/**
 * This tests test the basic fee claiming flow.
 */
contract AaveParaswapClaimerTest is Test {
  AaveParaswapFeeClaimer public aaveParaswapClaimer;

  address internal constant AUGUSTUS =
    0xDEF171Fe48CF0115B1d80b88dc8eAB59176FEe57;

  address internal constant DAI = 0xDA10009cBd5D07dd0CeCc66161FC93D7c9000da1;

  address internal constant USDC = 0x2791Bca1f2de4661ED88A30C99A7a9449Aa84174;

  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('polygon'), 31507646);
    aaveParaswapClaimer = new AaveParaswapFeeClaimer();
    aaveParaswapClaimer.initialize(
      AaveV3Polygon.COLLECTOR,
      ParaswapClaimer.POLYGON
    );

    /**
     * As there are no claimable fees for the newly deployed claimer, we're adding some USDC.
     */
    vm.startPrank(AUGUSTUS);
    deal(USDC, address(aaveParaswapClaimer.paraswapFeeClaimer()), 2 ether);
    IFeeClaimer(aaveParaswapClaimer.paraswapFeeClaimer()).registerFee(
      address(aaveParaswapClaimer),
      IERC20(USDC),
      1 ether
    );
    vm.stopPrank();
  }

  function test_getters() public {
    assertEq(
      address(aaveParaswapClaimer.paraswapFeeClaimer()),
      address(ParaswapClaimer.POLYGON)
    );
    assertEq(aaveParaswapClaimer.aaveCollector(), AaveV3Polygon.COLLECTOR);
  }

  function test_getClaimable() public {
    uint256 claimableUSDC = aaveParaswapClaimer.getClaimable(USDC);
    uint256 claimableDAI = aaveParaswapClaimer.getClaimable(DAI);
    assertEq(claimableUSDC, 1 ether);
    assertEq(claimableDAI, 0);
  }

  function test_batchGetClaimable() public {
    address[] memory assets = new address[](2);
    assets[0] = USDC;
    assets[1] = DAI;
    uint256[] memory amounts = aaveParaswapClaimer.batchGetClaimable(assets);
    assertEq(amounts[0], 1 ether);
    assertEq(amounts[1], 0);
  }

  function test_claimToCollector() public {
    uint256 balanceBefore = IERC20(USDC).balanceOf(AaveV3Polygon.COLLECTOR);
    uint256 claimableUSDC = aaveParaswapClaimer.getClaimable(USDC);
    assertGt(claimableUSDC, 0);
    aaveParaswapClaimer.claimToCollector(IERC20(USDC));
    assertEq(
      IERC20(USDC).balanceOf(AaveV3Polygon.COLLECTOR),
      balanceBefore + claimableUSDC
    );
  }

  function test_batchClaimToCollector() public {
    uint256 balanceBefore = IERC20(USDC).balanceOf(AaveV3Polygon.COLLECTOR);
    uint256 claimableUSDC = aaveParaswapClaimer.getClaimable(USDC);
    assertGt(claimableUSDC, 0);
    address[] memory assets = new address[](1);
    assets[0] = USDC;
    aaveParaswapClaimer.batchClaimToCollector(assets);
    assertEq(
      IERC20(USDC).balanceOf(AaveV3Polygon.COLLECTOR),
      balanceBefore + claimableUSDC
    );
  }
}
