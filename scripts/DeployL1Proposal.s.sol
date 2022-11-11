// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import 'forge-std/console.sol';
import {Script} from 'forge-std/Script.sol';
import {AaveGovernanceV2, IExecutorWithTimelock} from 'aave-address-book/AaveGovernanceV2.sol';

library DeployL1Proposal {
  struct Execution {
    address target;
    string signature;
    bytes callData;
  }

  function _deployL1Proposal(Execution[] memory executions, bytes32 ipfsHash)
    internal
    returns (uint256 proposalId)
  {
    require(ipfsHash != bytes32(0), "ERROR: IPFS_HASH can't be bytes32(0)");
    address[] memory targets = new address[](executions.length);
    uint256[] memory values = new uint256[](executions.length);
    string[] memory signatures = new string[](executions.length);
    bytes[] memory calldatas = new bytes[](executions.length);
    bool[] memory withDelegatecalls = new bool[](executions.length);

    for (uint256 i = 0; i < executions.length; i++) {
      targets[i] = executions[i].target;
      values[i] = 0;
      signatures[i] = executions[i].signature;
      calldatas[i] = executions[i].callData;
      withDelegatecalls[i] = true;
    }

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

contract DeployProposal is Script {
  address internal constant ETHEREUM_PAYLOAD = address(0);

  address internal constant CROSSCHAIN_FORWARDER_POLYGON =
    address(0x158a6bC04F0828318821baE797f50B0A1299d45b);

  address internal constant POLYGON_PAYLOAD = address(0);

  address internal constant CROSSCHAIN_FORWARDER_OPTIMISM =
    address(0x5f5C02875a8e9B5A26fbd09040ABCfDeb2AA6711);

  address internal constant OPTIMISM_PAYLOAD = address(0);

  bytes32 internal constant IPFS_HASH = bytes32(0);

  function run() external {
    DeployL1Proposal.Execution[]
      memory executions = new DeployL1Proposal.Execution[](3);
    executions[0] = DeployL1Proposal.Execution({
      target: ETHEREUM_PAYLOAD,
      signature: 'execute()',
      callData: ''
    });
    executions[1] = DeployL1Proposal.Execution({
      target: CROSSCHAIN_FORWARDER_POLYGON,
      signature: 'execute(address)',
      callData: abi.encode(POLYGON_PAYLOAD)
    });
    executions[2] = DeployL1Proposal.Execution({
      target: CROSSCHAIN_FORWARDER_OPTIMISM,
      signature: 'execute(address)',
      callData: abi.encode(OPTIMISM_PAYLOAD)
    });

    vm.startBroadcast();
    DeployL1Proposal._deployL1Proposal(executions, IPFS_HASH);
    vm.stopBroadcast();
  }
}
