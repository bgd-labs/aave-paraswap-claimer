// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script} from 'forge-std/Script.sol';
import {AaveV2Ethereum, AaveV3Polygon, AaveV3Avalanche, AaveV3Optimism, AaveV3Arbitrum, AaveV3Fantom} from 'aave-address-book/AaveAddressBook.sol';
import {AaveParaswapCollector} from '../src/contracts/AaveParaswapCollector.sol';
import {ParaswapClaimer} from '../src/lib/ParaswapClaimer.sol';

contract DeployEthereum is Script {
  function run() external {
    vm.startBroadcast();
    new AaveParaswapCollector(
      AaveV2Ethereum.COLLECTOR,
      ParaswapClaimer.ETHEREUM
    );
    vm.stopBroadcast();
  }
}

contract DeployPolygon is Script {
  function run() external {
    vm.startBroadcast();
    new AaveParaswapCollector(AaveV3Polygon.COLLECTOR, ParaswapClaimer.POLYGON);
    vm.stopBroadcast();
  }
}

contract DeployAvalanche is Script {
  function run() external {
    vm.startBroadcast();
    new AaveParaswapCollector(
      AaveV3Avalanche.COLLECTOR,
      ParaswapClaimer.AVALANCHE
    );
    vm.stopBroadcast();
  }
}

contract DeployOptimism is Script {
  function run() external {
    vm.startBroadcast();
    new AaveParaswapCollector(
      AaveV3Optimism.COLLECTOR,
      ParaswapClaimer.OPTIMISM
    );
    vm.stopBroadcast();
  }
}

contract DeployArbitrum is Script {
  function run() external {
    vm.startBroadcast();
    new AaveParaswapCollector(
      AaveV3Arbitrum.COLLECTOR,
      ParaswapClaimer.ARBITRUM
    );
    vm.stopBroadcast();
  }
}

contract DeployFantom is Script {
  function run() external {
    vm.startBroadcast();
    new AaveParaswapCollector(AaveV3Fantom.COLLECTOR, ParaswapClaimer.FANTOM);
    vm.stopBroadcast();
  }
}
