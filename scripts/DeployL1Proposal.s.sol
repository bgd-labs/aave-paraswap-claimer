// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import 'forge-std/console.sol';
import {Script} from 'forge-std/Script.sol';
import {AaveGovernanceV2, IExecutorWithTimelock} from 'aave-address-book/AaveGovernanceV2.sol';

library DeployL1Proposal {
  address internal constant CROSSCHAIN_FORWARDER_POLYGON =
    address(0x158a6bC04F0828318821baE797f50B0A1299d45b);

  function _deployL1Proposal(
    address l1payload,
    address polygonPayload,
    bytes32 ipfsHash
  ) internal returns (uint256 proposalId) {
    require(l1payload != address(0), "ERROR: L1_PAYLOAD can't be address(0)");
    require(
      polygonPayload != address(0),
      "ERROR: L2_PAYLOAD can't be address(0)"
    );
    require(ipfsHash != bytes32(0), "ERROR: IPFS_HASH can't be bytes32(0)");
    address[] memory targets = new address[](2);
    targets[0] = l1payload;
    targets[1] = CROSSCHAIN_FORWARDER_POLYGON;

    uint256[] memory values = new uint256[](2);
    values[0] = 0;
    values[1] = 0;

    string[] memory signatures = new string[](2);
    signatures[0] = 'execute()';
    signatures[1] = 'execute(address)';

    bytes[] memory calldatas = new bytes[](2);
    calldatas[0] = '';
    calldatas[1] = abi.encode(polygonPayload);

    bool[] memory withDelegatecalls = new bool[](2);
    withDelegatecalls[0] = true;
    withDelegatecalls[1] = true;

    return
      AaveGovernanceV2.GOV.create(
        IExecutorWithTimelock(AaveGovernanceV2.SHORT_EXECUTOR),
        targets,
        values,
        signatures,
        calldatas,
        withDelegatecalls,
        ipfsHash
      );
  }
}

contract DeployMai is Script {
  function run() external {
    vm.startBroadcast();
    DeployL1Proposal._deployL1Proposal(address(0), address(0), bytes32(0));
    vm.stopBroadcast();
  }
}