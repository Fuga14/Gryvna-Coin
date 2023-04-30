const { network, ethers } = require('hardhat');
const { networkConfig, developmentChains } = require('../helper-hardhat-config');
const tokenJSON = require('../build/artifacts/contracts/GryvnaToken.sol/GryvnaToken.json');
module.exports = async function ({ getNamedAccounts, deployments }) {
    const { deploy, log } = deployments;
    const { deployer } = await getNamedAccounts();
    const chainId = network.config.chainId;

    const args = [];
    const GShop = await deploy('GShop', {
        log: true,
        args: args,
        from: deployer,
        waitConfiramtions: network.config.blockConfirmations || 1,
    });
    const gshopContract = await ethers.getContract('GShop', deployer);
    const tokenAddress = await gshopContract.getTokenAddress();

    // const erc20 = new ethers.Contract(await GShop.token(), tokenJSON.abi, deployer);
    // const tokeAddress = await ethers.getContract('GryvnaToken');
    log('---------------------------');
    console.log('Address of the shop:');
    console.log(GShop.address);
    console.log('Address of the token:');
    console.log(tokenAddress);
};

module.exports.tags = ['all', 'main'];
