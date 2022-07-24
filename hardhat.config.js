require("@nomicfoundation/hardhat-toolbox");

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.9",
  networks: {
    mumbai: {
      url: process.env.STAGING_ALCHEMY_KEY,
      accounts: [process.env.PRIVATE_KEY_MUMBAI],
    },
    mainnet: {
      url: process.env.MAINNET_ALCHEMY_KEY,
      accounts: [process.env.PRIVATE_KEY_MAINNET],      
    }
  }
};
