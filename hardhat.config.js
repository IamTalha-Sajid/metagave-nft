/** @type import('hardhat/config').HardhatUserConfig */
// require("@nomiclabs/hardhat-waffle");
require("@nomiclabs/hardhat-ethers");
// require("@nomiclabs/ethereum-waffle");
require("@nomiclabs/hardhat-ganache");
require('dotenv').config();
require("web3");

module.exports = {
  defaultNetwork: "hardhat",
  networks: {
    hardhat: {
    },
    polygon_mumbai: {
      url: "https://rpc-mumbai.maticvigil.com",
      accounts: [process.env.PRIVATE_KEY]
    }
  },
  etherscan: {
    apiKey: process.env.POLYGONSCAN_API_KEY
  },
  solidity: {
    version: "0.8.17",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200
      }
    }
  },
}
