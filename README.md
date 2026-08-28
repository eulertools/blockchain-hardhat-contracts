# blockchain-hardhat-contracts

Hardhat / OpenZeppelin harness for Euler Tools contracts (ERC-20 + tax + storage + upgradeable proxies). Archived snapshot, as-is.

This tree is a **new public commit** with no git history. The original private archive is `eulertools/blockchain-hardhat-contracts-archive`.

## What was built (EN)

Solidity 0.8.7 with Hardhat: `EulerTools` token (proxy + storage), `ManagerTax` with membership discounts, `GlobalStorage`, and ERC1967 upgradeable proxies. Network configs for BSC testnet and Polygon Mumbai. Deploy keys and Cognito auth come from the environment (`WALLET_PRIVATE_KEY`, `AWS_COGNITO_*`). Licensed under MIT.

The committed BSC testnet RPC was a private Chainstack/p2pify URL; the public snapshot uses the public BSC testnet seed instead.

## Qué se construyó (ES)

Harness Hardhat: token Euler, impuestos, storage global y proxies upgradeables. Configs de BSC testnet y Mumbai.

## Deployments

Addresses below are **BSC testnet (chain id 97)** as recorded in `config/network/bsctest.json`. Mumbai config has no product addresses. No mainnet artifact in this repo.

| Contract | Address (BSC testnet) |
|---|---|
| Euler token (proxy) | `0x5a077457e7a17f828c7c81fb387615ed785e66ba` |
| Euler token (implementation) | `0x0f32866670ac7be928be310e502ba3bc0bcddd3e` |
| Staking | `0x79ae145bcd504a13c8e76cf2ee7397088be1c4cc` |
| Treasury | `0x4a9e0fcdd826af2b235c69fc4e2ee03cdbb82632` |
| GlobalStorage | `0xe34abf9ac39ab81bef3c93438c2e60c11014bbec` |

Other product addresses in that JSON (marketplace, dex aggregator, guestbook, …) are also testnet deploys from this config file.

---

## Notice / Aviso

**Euler Tools ha cerrado. Euler Tools is closed.**

La empresa quebró. Este repositorio está archivado y no se mantiene. El software se ofrece tal cual (as is), sin garantía ni soporte. Parte del material puede ser reclamado por acreedores.

The company went bankrupt. This repository is archived and unmaintained. Software is provided as is, with no warranty and no support. Some material may be claimed by creditors.

Site: https://euler.tools  
Org: https://github.com/eulertools  
Enquiries: https://sinequix.com · https://github.com/tebayoso
