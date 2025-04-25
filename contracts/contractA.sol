// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/utils/cryptography/EIP712.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

contract ContractA is EIP712 {
    IERC20 public token;
    mapping(address => uint256) public balances;
    mapping(address => uint256) public nonces;
    address public swapContract;

    bytes32 private constant TRANSFER_TOKENS_TYPEHASH =
        keccak256(
            "TransferTokens(address from,address to,uint256 amount,uint256 nonce,uint256 deadline)"
        );

    constructor(
        address _token,
        address _swapContract
    ) EIP712("ContractA", "1") {
        token = IERC20(_token);
        swapContract = _swapContract;
    }

    function deposit(uint256 amount) external {
        token.transferFrom(msg.sender, address(this), amount);
        balances[msg.sender] += amount;
        emit Deposited(msg.sender, amount);
    }

    function permitTransfer(
        address from,
        address to,
        uint256 amount,
        uint256 deadline,
        bytes memory signature
    ) external {
        require(msg.sender == swapContract, "Only swap contract can call");
        require(block.timestamp <= deadline, "Signature expired");

        bytes32 structHash = keccak256(
            abi.encode(
                TRANSFER_TOKENS_TYPEHASH,
                from,
                to,
                amount,
                nonces[from],
                deadline
            )
        );
        bytes32 digest = _hashTypedDataV4(structHash);
        address signer = ECDSA.recover(digest, signature);
        require(signer == from, "Invalid signature");

        nonces[from]++;
        require(balances[from] >= amount, "Insufficient balance");
        token.transfer(to, amount);
        balances[from] -= amount;
        emit Transferred(from, to, amount);
    }

    event Deposited(address indexed user, uint256 amount);
    event Transferred(address indexed from, address indexed to, uint256 amount);
}
