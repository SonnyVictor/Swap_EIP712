Overview
This project implements a token-NFT swap system where:

UserA deposits ERC-20 tokens (e.g., TokenYAYA) into ContractA.
UserB deposits an ERC-721 NFT (e.g., MyTokenNFT) into ContractB.
The SwapContract facilitates a swap using EIP-712 signatures, transferring tokens from UserA to UserB and the NFT from UserB to UserA.

Key features:

EIP-712 signatures: Secure off-chain approvals using permit (OpenZeppelin) for tokens and custom signatures for NFTs.
Security: Implements Ownable, Pausable, ReentrancyGuard, and input validation.
Gas efficiency: Uses immutable variables and early condition checks.
Maintainability: Detailed events and clear code structure.

Smart Contracts
The project includes the following smart contracts:

TokenYAYA: An ERC-20 token with mint functionality restricted to the owner.
MyTokenNFT: An ERC-721 NFT with safeMint restricted to the owner and IPFS metadata.
ContractA: Manages ERC-20 token deposits and transfers using EIP-712 signatures.
ContractB: Manages ERC-721 NFT deposits and transfers using custom EIP-712 signatures.
SwapContract: Facilitates token-NFT swaps, with pausable and reentrancy protection.

Project Structure
token-nft-swap/
├── contracts/
│   ├── TokenYAYA.sol        # ERC-20 token contract
│   ├── MyTokenNFT.sol       # ERC-721 NFT contract
│   ├── ContractA.sol        # Token deposit and transfer contract
│   ├── ContractB.sol        # NFT deposit and transfer contract
│   ├── SwapContract.sol     # Swap facilitator contract
├── scripts/
│   ├── deploy.js            # Deployment script
├── hardhat.config.js        # Hardhat configuration
├── README.md                # Project documentation
├── package.json             # Project dependencies and scripts

Usage
Compile Contracts
Compile all smart contracts:
npx hardhat compile

Run Local Node
Start a Hardhat local Ethereum node:
npx hardhat node

Deploy contracts to the local network:
npx hardhat run scripts/deploy.js --network localhost
Output
Deployer: 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266
UserA: 0x70997970C51812dc3A010C7d01b50e0d17dc79C8
UserB: 0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC
Replayer: 0x90F79bf6EB2c4f870365E785982E1f101E93b906
TokenYAYA deployed to: 0x09635F643e140090A9A8Dcd712eD6285858ceBef
MyTokenNFT deployed to: 0xc5a5C42992dECbae36851359345FE25997F5C42d
SwapContract deployed to: 0x67d269191c92Caf3cD7723F116c85e6E9bf55933
ContractA deployed to: 0xE6E340D132b5f46d1e472DebcD681B2aBc16e57E
ContractB deployed to: 0xc3e53F4d16Ae77Db1c982e75a937B9f60FE63690
Minted 1500 YAYA tokens to userA
Minted NFT #1 to userB
UserA deposited 1500 tokens to ContractA
UserB deposited NFT #1 to ContractB
UserA signature created 0xbe20ffffbf57cd9544289b79d9e954b5013ec3f327fe660dfbea437e03f95d5169abe67760bbeb6a6687cc3d5fd718d33d5ef4a8aee2c92b30155d1c2f1ca72c1b
UserB signature created 0x662e5fb592104a1d2fb3e55fec30f489f5e14e202e85e51f6397c20d263c26c269803a999eee3efc3ed99cd4076a4ed80509c1a4d1bb165f9664149adc4b293d1b
Replayer will execute the swap
Swap executed successfully with swapId: 1
Swap executed successfully
UserA token balance: 0.0
UserB token balance: 1500.0
UserA owns NFT #1: true