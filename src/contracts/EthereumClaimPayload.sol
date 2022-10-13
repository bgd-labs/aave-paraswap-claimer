// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {AaveV2Ethereum} from 'aave-address-book/AaveV2Ethereum.sol';
import {AaveGovernanceV2} from 'aave-address-book/AaveGovernanceV2.sol';
import {IProposalGenericExecutor} from '../interfaces/IProposalGenericExecutor.sol';
import {IFeeClaimer} from '../interfaces/IFeeClaimer.sol';
import {ParaswapClaimer} from '../lib/ParaswapClaimer.sol';
import {ParaswapClaim} from './ParaswapClaim.sol';

contract EthereumClaimPayload is IProposalGenericExecutor, ParaswapClaim {
  function execute() external override {
    address[] memory tokens = AaveV2Ethereum.POOL.getReservesList();
    claim(
      ParaswapClaimer.ETHEREUM,
      AaveGovernanceV2.SHORT_EXECUTOR,
      AaveV2Ethereum.COLLECTOR,
      tokens
    );
  }
}
