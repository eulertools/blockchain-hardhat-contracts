import { ethers } from "hardhat";
import { writeFileAsync, networkConfig, jsonPath } from "../index"

const globalStorage = ethers.getContractFactory("GlobalStorage")
const managerTax = ethers.getContractFactory("ManagerTax")
const euler = ethers.getContractFactory("EulerTools");
const proxyUpgradeable = ethers.getContractFactory("ERC1967ProxyUpgradeable")

async function main() {

  try {

    if (!networkConfig.products.globalStorage) {
      const GlobalStorage = await (await globalStorage).deploy();
      await GlobalStorage.deployed();
      networkConfig.products.globalStorage = GlobalStorage.address.toLowerCase();
      await writeFileAsync(jsonPath, JSON.stringify(networkConfig, null, 4)); 
    }

    const globalStorageInstance = networkConfig.products.globalStorage;
    const ZERO_ADDRESS = '0x0000000000000000000000000000000000000000';
    if(networkConfig.tokens.WETH &&
      ZERO_ADDRESS === networkConfig.tokens.WETH) {
      networkConfig.tokens.WETH = ethers.utils.keccak256(networkConfig.tokens.WETH);
    } else if(!networkConfig.tokens.WETH) {
      throw new Error('WETH not defined');
    }
    

    if(networkConfig.products.treasury &&
      ZERO_ADDRESS === ethers.utils.keccak256(networkConfig.products.treasury)) {
      networkConfig.products.treasury = ethers.utils.keccak256(networkConfig.products.treasury);
    } else if(!networkConfig.products.treasury) {
      throw new Error('Treasury not defined');
    }
        
    networkConfig.products.manager_tax = networkConfig.products.manager_tax || {};
    if(!networkConfig.products.manager_tax.dapp) {
      const ManagerTax = await (await managerTax).deploy();
      await ManagerTax.deployed();
      networkConfig.products.manager_tax.dapp = ManagerTax.address.toLowerCase();
      await writeFileAsync(jsonPath, JSON.stringify(networkConfig, null, 4));
    }

     if(!networkConfig.products.manager_tax.proxy) {
      const ProxyUpgradeable = await (await proxyUpgradeable).deploy();
      await ProxyUpgradeable.deployed();
      networkConfig.products.manager_tax.proxy = ProxyUpgradeable.address.toLowerCase();
      const instanceProxy = networkConfig.products.manager_tax.proxy;
      console.log(await instanceProxy.__ERC1967ProxyUpgradeable_init(networkConfig.products.manager_tax.dapp));
      const instanceManagerTax = networkConfig.products.manager_tax.proxy;
      //console.log(await instanceManagerTax.init(networkConfig.products.globalStorage, accounts[0]));
      networkConfig.products.manager_tax.proxy = ethers.utils.keccak256(networkConfig.products.manager_tax.proxy);
      await writeFileAsync(jsonPath, JSON.stringify(networkConfig, null, 4));
    }

    // const instanceManagerProxy =networkConfig.products.manager_tax.proxy;
    // if((await instanceManagerProxy.getImplementation()).toLowerCase() !== networkConfig.products.manager_tax.dapp.toLowerCase()) {
    //   console.log(await instanceManagerProxy.setImplementation(networkConfig.products.manager_tax.dapp));
    // }

    if(networkConfig.migrations.tokens) {

      if(!networkConfig.tokens.OEULER) {
        throw new Error('Old Euler not defined');
      }

      networkConfig.products.euler = networkConfig.products.euler || {};

      if(!networkConfig.products.euler.token) {
        const EulerTools = await (await euler).deploy();
        await EulerTools.deployed();
        networkConfig.products.euler.token = EulerTools.address.toLowerCase();
        await writeFileAsync(jsonPath, JSON.stringify(networkConfig, null, 4));
      }

      if(!networkConfig.products.euler.proxy) {
        const ProxyUpgradeable = await (await proxyUpgradeable).deploy();
        await ProxyUpgradeable.deployed();
        networkConfig.products.euler.proxy = ProxyUpgradeable.address.toLowerCase();
        const instanceProxy = networkConfig.products.euler.proxy;
        console.log(await instanceProxy.__ERC1967ProxyUpgradeable_init(networkConfig.products.euler.token));
        const instanceEuler = networkConfig.products.euler.proxy;
        //console.log(await instanceEuler.init(networkConfig.products.globalStorage, accounts[0], 100000000, networkConfig.tokens.OEULER));
        networkConfig.tokens.EULER = networkConfig.products.euler.proxy;
        await writeFileAsync(jsonPath, JSON.stringify(networkConfig, null, 4));
      }

      const instanceEuler =networkConfig.products.euler.token;
      //console.log(await instanceEuler.init(networkConfig.products.globalStorage, accounts[0], 0, '0x0000000000000000000000000000000000000000'));

      const instanceProxy =networkConfig.products.euler.proxy;

      if((await instanceProxy.getImplementation()).toLowerCase() !== networkConfig.products.euler.token.toLowerCase()) {
        console.log(await instanceProxy.setImplementation(networkConfig.products.euler.token));
      }
    }
  }
  catch (e) {
    console.log((e as Error).message);
    throw e;
  }
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
