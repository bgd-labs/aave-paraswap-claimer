// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import 'forge-std/Test.sol';
import {AaveV3Polygon} from 'aave-address-book/AaveV3Polygon.sol';
import {AaveParaswapCollector} from '../src/contracts/AaveParaswapCollector.sol';
import {ParaswapClaimer} from '../src/lib/ParaswapClaimer.sol';

contract AaveParaswapCollectorTest is Test {
  AaveParaswapCollector public aaveParaswapCollector;

  address internal constant DAI = 0xDA10009cBd5D07dd0CeCc66161FC93D7c9000da1;

  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('polygon'), 31507646);
    aaveParaswapCollector = new AaveParaswapCollector(
      AaveV3Polygon.COLLECTOR,
      ParaswapClaimer.POLYGON
    );
  }

  function test_getClaimable() public {
    address[] memory assets = new address[](1);
    assets[0] = DAI;
    uint256[] memory amounts = aaveParaswapCollector.getClaimable(assets);
    assertEq(amounts[0], 0);
  }
}
