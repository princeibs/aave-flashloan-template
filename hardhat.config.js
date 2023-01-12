require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();

module.exports = {
  solidity: "0.8.10",
  networks: {
    goerli: {
      url: process.env.ALCHEMY_GOERLI_ENDPOINT,
      accounts: [process.env.PRIVATE_KEY],
    },
  },
};