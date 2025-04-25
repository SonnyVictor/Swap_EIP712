# Token-NFT Swap System

## Overview

This project implements a **token-NFT swap system** allowing two users to securely exchange ERC-20 tokens and ERC-721 NFTs through a series of smart contracts and off-chain EIP-712 signatures.

###  Swap Flow
1. **UserA** deposits ERC-20 tokens (e.g., `TokenYAYA`) into `ContractA`.
2. **UserB** deposits an ERC-721 NFT (e.g., `MyTokenNFT`) into `ContractB`.
3. **SwapContract** verifies off-chain EIP-712 signatures and performs the swap:
   - Transfers tokens from UserA → UserB
   - Transfers NFT from UserB → UserA

##  Key Features

- **EIP-712 Signatures**  
  Secure and gas-efficient off-chain approvals:
  - Custom EIP-712 for ERC20
  - Custom EIP-712 logic for NFTs.

- **Security First**  
  Contracts use:
  - `Ownable`, `Pausable`, `ReentrancyGuard`
  - Input validation to avoid incorrect usage

- **Gas Optimization**  
  - Immutable variables
  - Early `require()` condition checks

- **Developer Friendly**  
  - Emit detailed events for all key operations
  - Clear contract structure for maintainability

##  Smart Contracts

| Contract         | Description                                                |
|------------------|------------------------------------------------------------|
| `TokenYAYA.sol`  | ERC-20 token with `mint` restricted to the contract owner |
| `MyTokenNFT.sol` | ERC-721 NFT with `safeMint` and IPFS metadata              |
| `ContractA.sol`  | Handles ERC-20 deposits and transfers with EIP-712         |
| `ContractB.sol`  | Handles ERC-721 deposits and transfers with custom EIP-712 |
| `SwapContract.sol` | Core swap logic and signature validation                |

##  Project Structure

## Usage
npx hardhat compile
npx hardhat node
npx hardhat run scripts/deploy.js --network localhost

###
Deployer: 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266
UserA: 0x70997970C51812dc3A010C7d01b50e0d17dc79C8
UserB: 0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC
Replayer: 0x90F79bf6EB2c4f870365E785982E1f101E93b906
TokenYAYA deployed to: 0x84eA74d481Ee0A5332c457a4d796187F6Ba67fEB
MyTokenNFT deployed to: 0x9E545E3C0baAB3E08CdfD552C960A1050f373042
SwapContract deployed to: 0xa82fF9aFd8f496c3d6ac40E2a0F282E47488CFc9
ContractA deployed to: 0x1613beB3B2C4f22Ee086B2b38C1476A3cE7f78E8
ContractB deployed to: 0x851356ae760d987E095750cCeb3bC6014560891C
Minted 1500 YAYA tokens to userA
Minted NFT #1 to userB
UserA deposited 1500 tokens to ContractA
UserB deposited NFT #1 to ContractB
UserA signature created 0xba0170446756137c72ddaf7604f8dd244edf694991fd966ea48d6372c9b67f0d7987e082a5062f90da2f6688d424e53f2c09269f432a15299606057d9dc2ac5a1b
UserB signature created 0x085f7c5b1638734fa252b2b7e4c3a7f86fbe17ad78e32abd89f247a3b25806743d98ef7386d723c3b292432cb3788b72e0a1bb524589807d956fbdb89be2174a1b
Replayer will execute the swap
Swap executed successfully with swapId: 1
Swap executed successfully
UserA token balance: 0.0
UserB token balance: 1500.0
UserA owns NFT #1: true