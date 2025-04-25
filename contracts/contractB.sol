// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/utils/cryptography/EIP712.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

contract ContractB is EIP712 {
    IERC721 public nft;
    mapping(uint256 => address) public nftOwnership;
    mapping(address => uint256) public nonces;
    address public swapContract;

    bytes32 private constant TRANSFER_NFT_TYPEHASH =
        keccak256(
            "TransferNFT(address from,address to,uint256 tokenId,uint256 nonce,uint256 deadline)"
        );

    constructor(address _nft, address _swapContract) EIP712("ContractB", "1") {
        nft = IERC721(_nft);
        swapContract = _swapContract;
    }

    function depositNFT(uint256 tokenId) external {
        nft.transferFrom(msg.sender, address(this), tokenId);
        nftOwnership[tokenId] = msg.sender;
        emit DepositedNFT(msg.sender, tokenId);
    }

    function permitTransferNFT(
        address from,
        address to,
        uint256 tokenId,
        uint256 deadline,
        bytes memory signature
    ) external {
        require(msg.sender == swapContract, "Only swap contract can call");
        require(block.timestamp <= deadline, "Signature expired");

        bytes32 structHash = keccak256(
            abi.encode(
                TRANSFER_NFT_TYPEHASH,
                from,
                to,
                tokenId,
                nonces[from],
                deadline
            )
        );
        bytes32 digest = _hashTypedDataV4(structHash);
        address signer = ECDSA.recover(digest, signature);
        require(signer == from, "Invalid signature");
        require(nftOwnership[tokenId] == from, "Not NFT owner");
        require(nft.ownerOf(tokenId) == address(this), "NFT not in contract");

        nonces[from]++;
        nftOwnership[tokenId] = to;
        nft.transferFrom(address(this), to, tokenId);
        emit TransferredNFT(from, to, tokenId);
    }

    event DepositedNFT(address indexed user, uint256 tokenId);
    event TransferredNFT(
        address indexed from,
        address indexed to,
        uint256 tokenId
    );
}
