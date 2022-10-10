# Aave <> ParaSwap. Fee claimer

ParaSwap rewards part of the positive slippage to the a referrer. In the case of Aave, where ParaSwap is used on the Aave IPFS interface to swap funds on features like collateral swap or repayment with collateral, the referrer is the Collector of the protocol itself.
Currently the Aave protocol can claim referrer fees via Aave Governance and/or respective network Guardians. But this is not really optimal as, once setup, the the claim procedure can be executed in a permissionless way.

The contract on this repository aims to simplify the claiming process, by allowing anyone to claim to the respective Aave collector on the network.

## How it works

Whenever a action involving ParaSwap is performed on the UI, the referrer is set to `aave` which results in positive slippage being accrued on the [paraswap claimer](https://doc.paraswap.network/psp-token/protocol-fees#fee-claimer).
The `AaveParaswapCollector` is the beneficiary of these accrued rewards & exposes a public function `claimToCollector(address asset)` which will claim the rewards directly from `ParaswapClaimer` to `Collector`.

### Methods

`getClaimable(address asset)`: returns the claimable amount of a certain asset

`batchGetClaimable(address[] memory assets)`: returns the claimable amounts of selected assets

`claimToCollector(address asset)`: claim all rewards of a certain asset to the collector

`batchClaimToCollector(address[] assets)`: claim multiple rewards for multiple assets at once. All assets have non zero amounts to claim as otherwise the transactions will revert.
