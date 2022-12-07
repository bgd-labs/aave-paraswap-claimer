// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script} from 'forge-std/Script.sol';
import {AaveV2Ethereum, AaveV3Polygon, AaveV3Avalanche, AaveV3Optimism, AaveV3Arbitrum, AaveV3Fantom} from 'aave-address-book/AaveAddressBook.sol';
import {AaveParaswapFeeClaimer} from '../src/contracts/AaveParaswapFeeClaimer.sol';
import {ParaswapClaimer} from '../src/lib/ParaswapClaimer.sol';

library Create2Salt {
  bytes32 constant salt = keccak256(bytes('aave.paraswapclaimer.v1'));
}

contract DeployEthereum is Script {
  function run() external {
    vm.startBroadcast();
    AaveParaswapFeeClaimer claimer = new AaveParaswapFeeClaimer{
      salt: Create2Salt.salt
    }();
    claimer.initialize(AaveV2Ethereum.COLLECTOR, ParaswapClaimer.ETHEREUM);
    vm.stopBroadcast();
  }
}

contract DeployPolygon is Script {
  function run() external {
    vm.startBroadcast();
    AaveParaswapFeeClaimer claimer = new AaveParaswapFeeClaimer{
      salt: Create2Salt.salt
    }();
    claimer.initialize(AaveV3Polygon.COLLECTOR, ParaswapClaimer.POLYGON);
    vm.stopBroadcast();
  }
}

contract DeployAvalanche is Script {
  function run() external {
    vm.startBroadcast();
    AaveParaswapFeeClaimer claimer = new AaveParaswapFeeClaimer{
      salt: Create2Salt.salt
    }();
    claimer.initialize(AaveV3Avalanche.COLLECTOR, ParaswapClaimer.AVALANCHE);
    vm.stopBroadcast();
  }
}

contract DeployOptimism is Script {
  function run() external {
    vm.startBroadcast();
    AaveParaswapFeeClaimer claimer = new AaveParaswapFeeClaimer{
      salt: Create2Salt.salt
    }();
    claimer.initialize(AaveV3Optimism.COLLECTOR, ParaswapClaimer.OPTIMISM);
    vm.stopBroadcast();
  }
}

contract DeployArbitrum is Script {
  function run() external {
    vm.startBroadcast();
    AaveParaswapFeeClaimer claimer = new AaveParaswapFeeClaimer{
      salt: Create2Salt.salt
    }();
    claimer.initialize(AaveV3Arbitrum.COLLECTOR, ParaswapClaimer.ARBITRUM);
    vm.stopBroadcast();
  }
}

contract DeployFantom is Script {
  function run() external {
    vm.startBroadcast();
    AaveParaswapFeeClaimer claimer = new AaveParaswapFeeClaimer{
      salt: Create2Salt.salt
    }();
    claimer.initialize(AaveV3Fantom.COLLECTOR, ParaswapClaimer.FANTOM);
    vm.stopBroadcast();
  }
}
