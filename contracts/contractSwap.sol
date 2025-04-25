// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/Pausable.sol";

interface IContractA {
    function permitTransfer(
        address from,
        address to,
        uint256 amount,
        uint256 deadline,
        bytes memory signature
    ) external;
}

interface IContractB {
    function permitTransferNFT(
        address from,
        address to,
        uint256 tokenId,
        uint256 deadline,
        bytes memory signature
    ) external;
}

contract SwapContract is Ownable, ReentrancyGuard, Pausable {
    mapping(uint256 => bool) public usedSwapIds;

    event SwapPerformed(
        uint256 indexed swapId,
        address indexed userA,
        address indexed userB,
        address contractA,
        uint256 tokenAmount,
        address contractB,
        uint256 nftId
    );

    constructor() Ownable(msg.sender) {}

    function performSwap(
        uint256 swapId,
        address userA,
        address userB,
        address contractA,
        uint256 tokenAmount,
        address contractB,
        uint256 nftId,
        uint256 deadlineA,
        bytes memory signatureA,
        uint256 deadlineB,
        bytes memory signatureB
    ) external whenNotPaused nonReentrant {
        require(!usedSwapIds[swapId], "Swap ID already used");
        usedSwapIds[swapId] = true;

        require(userA != address(0) && userB != address(0), "Invalid user address");
        require(contractA != address(0) && contractB != address(0), "Invalid contract address");
        require(tokenAmount > 0, "Invalid token amount");
        require(nftId > 0, "Invalid NFT ID");

        require(block.timestamp <= deadlineA, "Token signature expired");
        require(block.timestamp <= deadlineB, "NFT signature expired");

        IContractA(contractA).permitTransfer(
            userA,
            userB,
            tokenAmount,
            deadlineA,
            signatureA
        );

        IContractB(contractB).permitTransferNFT(
            userB,
            userA,
            nftId,
            deadlineB,
            signatureB
        );

        emit SwapPerformed(swapId, userA, userB, contractA, tokenAmount, contractB, nftId);
    }

    function pause() external onlyOwner {
        _pause();
    }

    function unpause() external onlyOwner {
        _unpause();
    }

    function isSwapIdUsed(uint256 swapId) external view returns (bool) {
        return usedSwapIds[swapId];
    }
}