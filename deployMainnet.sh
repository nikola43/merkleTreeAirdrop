#!/bin/bash
rm -rf abi
rm -rf artifacts
rm -rf cache
npx hardhat run scripts/deployMerkleAirdrop --network mainnet

