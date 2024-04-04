RWA Subnets

## Deploy a subnet following [THIS](https://docs.ipc.space/quickstarts/deploy-a-subnet) guide

## Interact with the subnet following [THIS](https://docs.ipc.space/quickstarts/deploy-a-subnet) guide


<details>
<summary><b> Example deployment steps</b></summary>

Validator addresses:
- `0x2beb6146d19a4e8322b2d9e50ea9dadb738bf9fc`

Set default wallet (for multiple validators):
- `ipc-cli wallet set-default --address 0x2beb6146d19a4e8322b2d9e50ea9dadb738bf9fc --wallet-type evm`

Create subnet (1 validator):
- `ipc-cli subnet create --parent /r314159 --min-validator-stake 1 --min-validators 1 --bottomup-check-period 300 --from 0x2beb6146d19a4e8322b2d9e50ea9dadb738bf9fc --permission-mode collateral --supply-source-kind native`
- Subnet ID: /r314159/t410f2y7npogzwfgcpuovy6xayitzwq524zu4tjyvgei

Generate pubic key for an address:
- `ipc-cli wallet pub-key --wallet-type evm --address 0x2beb6146d19a4e8322b2d9e50ea9dadb738bf9fc`
- 04f44a1d54f6aa50cd38541b404dbb5b39589d7f9c2c47c4c80e36564d3690c1e7fc6c768609a9c0de66ba4a88dcbea053b71a0074216f952f8f590a8fcf6d9277

Join a subnet:
- `ipc-cli subnet join --from=0x2beb6146d19a4e8322b2d9e50ea9dadb738bf9fc --subnet=/r314159/t410f2y7npogzwfgcpuovy6xayitzwq524zu4tjyvgei --collateral=10 --public-key=04f44a1d54f6aa50cd38541b404dbb5b39589d7f9c2c47c4c80e36564d3690c1e7fc6c768609a9c0de66ba4a88dcbea053b71a0074216f952f8f590a8fcf6d9277 --initial-balance 1`

Export private key to a `.sk` file:
- `ipc-cli wallet export --wallet-type evm --address 0x2beb6146d19a4e8322b2d9e50ea9dadb738bf9fc --hex > ~/.ipc/validator_1.sk`

Deploy the infrastructure:
```sh
cargo make --makefile infra/fendermint/Makefile.toml \
-e NODE_NAME=validator-1 \
-e PRIVATE_KEY_PATH=/Users/samigabor/.ipc/validator_1.sk \
-e SUBNET_ID=/r314159/t410f2y7npogzwfgcpuovy6xayitzwq524zu4tjyvgei \
-e CMT_P2P_HOST_PORT=26656 \
-e CMT_RPC_HOST_PORT=26657 \
-e ETHAPI_HOST_PORT=8545 \
-e RESOLVER_HOST_PORT=26655 \
-e PARENT_GATEWAY=`curl -s https://raw.githubusercontent.com/consensus-shipyard/ipc/cd/contracts/deployments/r314159.json | jq -r '.gateway_addr'` \
-e PARENT_REGISTRY=`curl -s https://raw.githubusercontent.com/consensus-shipyard/ipc/cd/contracts/deployments/r314159.json | jq -r '.registry_addr'` \
-e FM_PULL_SKIP=1 \
child-validator
```

#
# Subnet node ready! 🚀

Subnet ID: /r314159/t410f2y7npogzwfgcpuovy6xayitzwq524zu4tjyvgei
Eth API: http://0.0.0.0:8545
Chain ID: 3928282793392938
Fendermint API: http://localhost:26658
CometBFT API: http://0.0.0.0:26657
CometBFT node ID: 257e57041d6cc5ee796b0a6ea076e83e48df12e8
CometBFT P2P: http://0.0.0.0:26656
IPLD Resolver Multiaddress: /ip4/0.0.0.0/tcp/26655/p2p/16Uiu2HAmSWqbWWh5peU29LvVnL68E41Xorqagj6wxvXZ7yzZnbkV

Fetch wallets balances:
`ipc-cli wallet balances --wallet-type evm --subnet=/r314159/t410f2y7npogzwfgcpuovy6xayitzwq524zu4tjyvgei`


Run a relayer => WHAT IS THE RELAYER ADDRESS ? TODO: Check GMP (general messaging passing) docs !!!
`ipc-cli checkpoint relayer --subnet /r314159/t410f2y7npogzwfgcpuovy6xayitzwq524zu4tjyvgei --submitter <RELAYER_ADDR>`

</details>


<details>
<summary><b> Example subnet metamask connection </b></summary>
- prerequisite: deploy local subnet with at least one validator
- Network name: IPC Local Subnet
- New RPC URL: http://0.0.0.0:8845
- Chain ID: 3928282793392938
</details>

