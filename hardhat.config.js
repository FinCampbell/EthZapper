require("@nomiclabs/hardhat-waffle");
require("@nomiclabs/hardhat-etherscan");

require("dotenv").config()

const PRIVATE_KEY = process.env.PRIVATE_KEY;

module.exports = {
  networks: {
    hardhat: {
      forking : {
        url: "https://eth-mainnet.alchemyapi.io/v2/ONPxonsXR24GXYh_AOokFnAWMJ_80cou",
      }
    },
    fantomTestnet : {
      url : "https://rpc.testnet.fantom.network/",
      accounts: [`0x${PRIVATE_KEY}`]
    },
    rinkeby : {
      url : "https://rinkeby.infura.io/v3/79cc38fe79a94a359b71e7521b3a661a",
      accounts: [`0x${PRIVATE_KEY}`]
    }
  },
  etherscan: {
    apiKey: "7236AM18NRJWW4GCMVZV4HAB5PG29C5BE7"
  },
  solidity: {
    compilers: [
      {
        version: "0.5.0"
      },
      {
        version: "0.6.12"
      },
      {
        version: "0.8.4"
      }
    ],
  }
};
