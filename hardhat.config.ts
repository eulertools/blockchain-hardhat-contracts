import { HardhatUserConfig, task } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import "@nomiclabs/hardhat-ethers";
import * as fs from 'fs';
import * as path from 'path';
require('dotenv').config();

const networks: any = {
};

if (process.env.NETWORK_TYPE) {
  const networkConfigPath = path.join(__dirname, 'config', 'network', `${process.env.NETWORK_TYPE}.json`);

  const networkConfig = JSON.parse(fs.readFileSync(networkConfigPath, 'utf-8'));

  const privateKey = process.env.WALLET_PRIVATE_KEY;

  networks[networkConfig.name] = {
    url: networkConfig.rpc,
    accounts: [
      privateKey,
    ]
  }
}

task("balance", "Prints an account's balance")
  .setAction(async () => {

    console.log(networks);
  })

const config: HardhatUserConfig = {
  solidity: {
    version: "0.8.7",
    settings: {
      optimizer: {
        enabled: true,
        runs: 1000,
      },
    },
  },
  networks: 
    networks
  
};

export default config;
