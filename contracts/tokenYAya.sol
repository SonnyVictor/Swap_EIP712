// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract TokenYAYA is ERC20 {
    constructor() ERC20("YAYA", "YAYA") {
        // _mint(msg.sender, 5000 ether);
    }

    function mint() external {
        _mint(msg.sender, 1500 ether);
    }
}
