/**
 * @type import('hardhat/config').HardhatUserConfig
 */

require('@nomiclabs/hardhat-waffle')
require("@nomiclabs/hardhat-ethers");
require("@nomiclabs/hardhat-solhint");

task("accounts", "Prints the list of accounts", async () => {
  const accounts = await ethers.getSigners();
  for (const account of accounts) {
    console.log(account.address);
  }
});

module.exports = {
  solidity: {
    compilers: [
      {
        version: "0.4.24"
      },
      {
        version: "0.6.12",
      }
    ]
  },
  defaultNetwork: "hardhat",
  networks: {
    hardhat: {
      // loggingEnabled: true,
      forking: {
        url: "<Infura endpoint>"
      }
    }
  }
};
