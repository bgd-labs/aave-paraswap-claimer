# Aave <> ParaSwap. Fee claimer

ParaSwap rewards part of the positive slippage to the a referrer. In the case of Aave, where ParaSwap is used on the Aave IPFS interface to swap funds on features like collateral swap or repayment with collateral, the referrer is the Collector of the protocol itself.
Currently the Aave protocol can claim referrer fees via Aave Governance and/or respective network Guardians. But this is not really optimal as, once setup, the the claim procedure can be executed in a permissionless way.

The contract on this repository aims to simplify the claiming process, by allowing anyone to claim to the respective Aave collector on the network.

## How it works

Whenever a action involving ParaSwap is performed on the UI, the referrer is set to `aave` which results in positive slippage being accrued on the [paraswap claimer](https://doc.paraswap.network/psp-token/protocol-fees#fee-claimer).
The `AaveParaswapFeeClaimer` is the beneficiary of these accrued rewards & exposes a public function `claimToCollector(address asset)` which will claim the rewards directly from `ParaswapClaimer` to `Collector`.

### Methods

`getClaimable(address asset)`: returns the claimable amount of a certain asset

`batchGetClaimable(address[] memory assets)`: returns the claimable amounts of selected assets

`claimToCollector(address asset)`: claim all rewards of a certain asset to the collector

`batchClaimToCollector(address[] assets)`: claim multiple rewards for multiple assets at once. All assets have non zero amounts to claim as otherwise the transactions will revert.


- [Ethereum:0x9abf798f5314BFd793A9E57A654BEd35af4A1D60](https://etherscan.io/address/0x9abf798f5314bfd793a9e57a654bed35af4a1d60#code)
- [Polygon:0x9abf798f5314BFd793A9E57A654BEd35af4A1D60](https://polygonscan.com/address/0x9abf798f5314BFd793A9E57A654BEd35af4A1D60#code)
- [Arbitrum:0x9abf798f5314BFd793A9E57A654BEd35af4A1D60](https://arbiscan.io/address/0x9abf798f5314bfd793a9e57a654bed35af4a1d60#code)
- [Optimism:0x9abf798f5314BFd793A9E57A654BEd35af4A1D60](https://optimistic.etherscan.io/address/0x9abf798f5314bfd793a9e57a654bed35af4a1d60#code)
- [Avalanche:0x9abf798f5314BFd793A9E57A654BEd35af4A1D60](https://snowtrace.io/address/0x9abf798f5314bfd793a9e57a654bed35af4a1d60#code)
- [Fantom:0x9abf798f5314BFd793A9E57A654BEd35af4A1D60](https://ftmscan.com/address/0x9abf798f5314bfd793a9e57a654bed35af4a1d60#code)
- [Base:0xae940e61e9863178b71500c9b5fae2a04da361a1](https://basescan.org/address/0xae940e61e9863178b71500c9b5fae2a04da361a1#code)
- [Bnb:0xae940e61e9863178b71500c9b5fae2a04da361a1](https://bscscan.com/address/0xAe940e61E9863178b71500c9B5faE2a04Da361a1#code)

## Proposal payload

While the new feeds will accrue to the new permission-less `AaveParaswapFeeClaimer` there are already ~50k$ in fees accrued that must be claimed trough governance. The payload in this repository claims all the accrued fees to the Aave collectors on the respective networks.
