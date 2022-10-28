// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script} from 'forge-std/Script.sol';
import {AaveV2Ethereum, AaveV3Polygon, AaveV3Avalanche, AaveV3Optimism, AaveV3Arbitrum, AaveV3Fantom} from 'aave-address-book/AaveAddressBook.sol';
import {AaveParaswapFeeClaimer} from '../src/contracts/AaveParaswapFeeClaimer.sol';
import {ParaswapClaimer} from '../src/lib/ParaswapClaimer.sol';

library Create2Salt {
  bytes32 constant salt =
    bytes32(0x6bcddbff4728acf0fce52a07a92f80d4dae551bd2ed6fe8b725c3eeca87e51be);
}

contract DeployEthereum is Script {
  function run() external {
    vm.startBroadcast();
    new AaveParaswapFeeClaimer{salt: Create2Salt.salt}(
      AaveV2Ethereum.COLLECTOR,
      ParaswapClaimer.ETHEREUM
    );
    vm.stopBroadcast();
  }
}

contract DeployPolygon is Script {
  function run() external {
    vm.startBroadcast();
    new AaveParaswapFeeClaimer{salt: Create2Salt.salt}(
      AaveV3Polygon.COLLECTOR,
      ParaswapClaimer.POLYGON
    );
    vm.stopBroadcast();
  }
}

contract DeployAvalanche is Script {
  function run() external {
    vm.startBroadcast();
    new AaveParaswapFeeClaimer{salt: Create2Salt.salt}(
      AaveV3Avalanche.COLLECTOR,
      ParaswapClaimer.AVALANCHE
    );
    vm.stopBroadcast();
  }
}

contract DeployOptimism is Script {
  function run() external {
    vm.startBroadcast();
    new AaveParaswapFeeClaimer{salt: Create2Salt.salt}(
      AaveV3Optimism.COLLECTOR,
      ParaswapClaimer.OPTIMISM
    );
    vm.stopBroadcast();
  }
}

contract DeployArbitrum is Script {
  function run() external {
    vm.startBroadcast();
    new AaveParaswapFeeClaimer{salt: Create2Salt.salt}(
      AaveV3Arbitrum.COLLECTOR,
      ParaswapClaimer.ARBITRUM
    );
    vm.stopBroadcast();
  }
}

contract DeployFantom is Script {
  function run() external {
    vm.startBroadcast();
    new AaveParaswapFeeClaimer{salt: Create2Salt.salt}(
      AaveV3Fantom.COLLECTOR,
      ParaswapClaimer.FANTOM
    );
    vm.stopBroadcast();
  }
}
