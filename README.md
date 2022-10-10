# AAVE paraswap collector

Paraswap rewards part of positive slippage to the referrer which in case of swaps performed trough the decentralized ipfs aave interface is the aave protocol itself.
Currently these rewards can be claimed trough aave governance & respective network guardians.
This is suboptimal as claiming has to go trough full governance process although it'#s irrational that there's any objection.

The contract presented here aims to simplify this process by allow anyone to claim to the respective aave collector.

## How it works

Whenever a action involving paraswap is performed on the ui, the referrer is set to `aave` which results in positive slippage being accrued on the [paraswap claimer](https://doc.paraswap.network/psp-token/protocol-fees#fee-claimer).
The `AaveParaswapCollector` is the beneficiary of these accrued rewards & exposes a public function `claimToCollector(address asset)` which will claim the rewards directly from `ParaswapClaimer` to `Collector`.

### Methods

`getClaimable(address asset)`: returns the claimable amount of a certain asset

`batchGetClaimable(address[] memory assets)`: returns the claimable amounts of selected assets

`claimToCollector(address asset)`: claim all rewards of a certain asset to the collector

`batchClaimToCollector(address[] assets)`: claim multiple rewards for multiple assets at once. All assets have non zero amounts to claim as otherwise the transactions will revert.
