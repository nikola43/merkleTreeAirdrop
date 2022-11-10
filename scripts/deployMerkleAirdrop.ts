const colors = require('colors');
import { ethers } from 'hardhat'
const test_util = require('./util');
import * as dotenv from 'dotenv'
dotenv.config()

async function main() {
    const [signer] = await ethers.getSigners()
    if (signer === undefined) throw new Error('Deployer is undefined.')
    console.log(colors.cyan('Deployer Address: ') + colors.yellow(signer.address));
    console.log();

    const root = process.env.MERKLE_ROOT
    const tokenAddress = process.env.TOKEN_ADDRESS
    const claimAmount = process.env.CLAIM_AMOUNT_IN_WEI

    /// ---------------------------------------------
    let contractName = "MerkleAirdrop"
    console.log(colors.yellow('Deploying ' + contractName + '...'));
    const contractFactory = await ethers.getContractFactory(contractName)
    const token = await contractFactory.deploy(root, tokenAddress, claimAmount)
    await token.deployed()
    console.log(colors.cyan(contractName + ' Address: ') + colors.yellow(token.address));
    await test_util.sleep(60);
    console.log(colors.yellow('verifying...'));
    await test_util.updateABI(contractName)
    await test_util.verify(token.address, contractName, [root, tokenAddress, claimAmount])
}

main()
    .then(async () => {
        console.log("Done")
    })
    .catch(error => {
        console.error(error);
        return undefined;
    })
