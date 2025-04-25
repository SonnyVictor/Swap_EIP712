
const { ethers } = require("hardhat");

async function main() {
  // get signer
  const [deployer, userA, userB, replayer] = await ethers.getSigners();
  console.log("Deployer:", deployer.address);
  console.log("UserA:", userA.address);
  console.log("UserB:", userB.address);
  console.log("Replayer:", replayer.address);

  // implement TokenYAYA (ERC-20)
  const TokenYAYA = await ethers.getContractFactory("TokenYAYA");
  const tokenYAYA = await TokenYAYA.deploy();
  await tokenYAYA.waitForDeployment();
  const tokenAddress = await tokenYAYA.getAddress();
  console.log("TokenYAYA deployed to:", tokenAddress);

  // implement MyTokenNFT (ERC-721)
  const MyTokenNFT = await ethers.getContractFactory("MyTokenNFT");
  const tokenNFT = await MyTokenNFT.deploy();
  await tokenNFT.waitForDeployment();
  const nftAddress = await tokenNFT.getAddress();
  console.log("MyTokenNFT deployed to:", nftAddress);

  // implement SwapContract
  const SwapContract = await ethers.getContractFactory("SwapContract");
  const swapContract = await SwapContract.deploy();
  await swapContract.waitForDeployment();
  const swapAddress = await swapContract.getAddress();
  console.log("SwapContract deployed to:", swapAddress);

  // implement ContractA
  const ContractA = await ethers.getContractFactory("ContractA");
  const contractA = await ContractA.deploy(tokenAddress, swapAddress);
  await contractA.waitForDeployment();
  const addressContractA = await contractA.getAddress();
  console.log("ContractA deployed to:", addressContractA);

  // implement ContractB
  const ContractB = await ethers.getContractFactory("ContractB");
  const contractB = await ContractB.deploy(nftAddress, swapAddress);
  await contractB.waitForDeployment();
  const addressContractB = await contractB.getAddress();
  console.log("ContractB deployed to:", addressContractB);

  // Mint token userA
  await tokenYAYA.connect(userA).mint();
  console.log("Minted 1500 YAYA tokens to userA");

  // Mint NFT  userB
  await tokenNFT.connect(userB).safeMint();
  console.log("Minted NFT #1 to userB");

  // UserA deposit token to ContractA
  await tokenYAYA
    .connect(userA)
    .approve(addressContractA, ethers.parseEther("1500", 18));
  await contractA.connect(userA).deposit(ethers.parseEther("1500", 18));
  console.log("UserA deposited 1500 tokens to ContractA");

  // UserB deposit NFT to ContractB
  await tokenNFT.connect(userB).approve(addressContractB, 1);
  await contractB.connect(userB).depositNFT(1);
  console.log("UserB deposited NFT #1 to ContractB");

  // create signature EIP-712  userA
  const domainA = {
    name: "ContractA",
    version: "1",
    chainId: 31337, // Hardhat localhost chain ID
    verifyingContract: addressContractA,
  };
  const typesA = {
    TransferTokens: [
      { name: "from", type: "address" },
      { name: "to", type: "address" },
      { name: "amount", type: "uint256" },
      { name: "nonce", type: "uint256" },
      { name: "deadline", type: "uint256" },
    ],
  };
  const messageA = {
    from: userA.address,
    to: userB.address,
    amount: ethers.parseEther("1500", 18),
    nonce: await contractA.nonces(userA.address),
    deadline: Math.floor(Date.now() / 1000) + 60 * 60, // 1 hour
  };
  const signatureA = await userA.signTypedData(domainA, typesA, messageA);
  console.log("UserA signature created", signatureA);

  // Tạo chữ ký EIP-712 cho userB
  const domainB = {
    name: "ContractB",
    version: "1",
    chainId: 31337,
    verifyingContract: addressContractB,
  };
  const typesB = {
    TransferNFT: [
      { name: "from", type: "address" },
      { name: "to", type: "address" },
      { name: "tokenId", type: "uint256" },
      { name: "nonce", type: "uint256" },
      { name: "deadline", type: "uint256" },
    ],
  };
  const messageB = {
    from: userB.address,
    to: userA.address,
    tokenId: 1,
    nonce: await contractB.nonces(userB.address),
    deadline: Math.floor(Date.now() / 1000) + 60 * 60, // 1 hour
  };
  const signatureB = await userB.signTypedData(domainB, typesB, messageB);
  console.log("UserB signature created", signatureB);


  console.log("Replayer will execute the swap");

  const swapId = 1
  await swapContract
    .connect(replayer)
    .performSwap(
      swapId,
      userA.address,
      userB.address,
      addressContractA,
      ethers.parseEther("1500", 18),
      addressContractB,
      1,
      messageA.deadline,
      signatureA,
      messageB.deadline,
      signatureB
    );
  console.log("Swap executed successfully with swapId:", swapId);
  console.log("Swap executed successfully");
  const userABalance = await tokenYAYA.balanceOf(userA.address);
  const userBBalance = await tokenYAYA.balanceOf(userB.address);
  const userANFT = await tokenNFT.ownerOf(1);
  console.log("UserA token balance:", ethers.formatUnits(userABalance, 18));
  console.log("UserB token balance:", ethers.formatUnits(userBBalance, 18));
  console.log("UserA owns NFT #1:", userANFT === userA.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
