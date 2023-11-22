# include .env file and export its env vars
# (-include to ignore error if it does not exist)
-include .env

# deps
update:; forge update

# Build & test
build  :; forge build --sizes --via-ir
test   :; forge test -vvv

deploy-ledger :; forge script ${contract} --rpc-url ${chain} $(if ${dry},--sender 0x25F2226B597E8F9514B3F68F00f494cF4f286491 -vvvv,--broadcast --ledger --mnemonics foo --mnemonic-indexes ${MNEMONIC_INDEX} --sender ${LEDGER_SENDER} --verify -vvvv)

deploy-ethereum :; forge script scripts/AaveParaswapFeeClaimer.s.sol:DeployEthereum --rpc-url ethereum --broadcast --ledger --mnemonic-indexes ${MNEMONIC_INDEX} --sender ${LEDGER_SENDER} --verify -vvvv
deploy-polygon :; forge script scripts/AaveParaswapFeeClaimer.s.sol:DeployPolygon --rpc-url polygon --broadcast --legacy --ledger --mnemonic-indexes ${MNEMONIC_INDEX} --sender ${LEDGER_SENDER} --verify -vvvv
deploy-avalanche :; forge script scripts/AaveParaswapFeeClaimer.s.sol:DeployAvalanche --rpc-url avalanche --broadcast --legacy --ledger --mnemonic-indexes ${MNEMONIC_INDEX} --sender ${LEDGER_SENDER} --verify -vvvv
deploy-optimism :; forge script scripts/AaveParaswapFeeClaimer.s.sol:DeployOptimism --rpc-url optimism --broadcast --legacy --ledger --mnemonic-indexes ${MNEMONIC_INDEX} --sender ${LEDGER_SENDER} --verify -vvvv
deploy-arbitrum :; forge script scripts/AaveParaswapFeeClaimer.s.sol:DeployArbitrum --rpc-url arbitrum --broadcast --legacy --ledger --mnemonic-indexes ${MNEMONIC_INDEX} --sender ${LEDGER_SENDER} --verify -vvvv
deploy-fantom :; forge script scripts/AaveParaswapFeeClaimer.s.sol:DeployFantom --rpc-url fantom --broadcast --legacy --ledger --mnemonic-indexes ${MNEMONIC_INDEX} --sender ${LEDGER_SENDER} --verify -vvvv
deploy-base :; make deploy-ledger contract=scripts/AaveParaswapFeeClaimer.s.sol:DeployBase chain=base
deploy-bnb :;  make deploy-ledger contract=scripts/AaveParaswapFeeClaimer.s.sol:DeployBNB chain=bnb
