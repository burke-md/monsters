/**
 * @type import('hardhat/config').HardhatUserConfig
 */

 import "@nomiclabs/hardhat-waffle";
 import "@typechain/hardhat";

 const { alchemyApiKey, mnemonic } = require("./.secrets.json");


 module.exports = {
  solidity: "0.8.4",

    networks: {
        rinkeby: {
            url: `https://eth-rinkeby.alchemyapi.io/v2/${alchemyApiKey}`,
            accounts: { mnemonic: mnemonic },
        },
    },
};
