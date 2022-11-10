# Install Node
Install Node Version Manager 
Linux | MacOS -> https://github.com/nvm-sh/nvm
Windows -> https://github.com/coreybutler/nvm-windows

```
nvm install 16
```
```
nvm use 16
```

# Install dependences
```
npm install -g yarn
```

```
yarn install
```

# Deploy on Eth Goerli testnet
## 1 Add private key on .env file
DEPLOYER_PKY_KEY=ab24af....

## 2 Paste merkle root on .env file
MERKLE_ROOT=0xeF13....
TOKEN_ADDRESS=0x7b7....
CLAIM_AMOUNT_IN_WEI=10000000000000000000

## 4 Run deploy script
### Testnet
```
npx hardhat run scripts/deployMerkleAirdrop.ts --network goerli
```
### Mainnet
```
npx hardhat run scripts/deployMerkleAirdrop.ts --network mainnet
```



