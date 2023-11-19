// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

// Requirements:
// Create an ERC20 token for Degen Gaming
// Minting new tokens
// Transferring tokens
// Redeeming tokens
// Checking token balance
// Burning tokens

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract DegenToken is ERC20, Ownable {
    event TokensMinted(address indexed to, uint256 amount);
    event TokensTransferred(address indexed from, address indexed to, uint256 amount);
    event TokensRedeemed(address indexed from, uint256 amount);
    event TokensBurned(address indexed from, uint256 amount);

    constructor() ERC20("Degen", "DGN") {}

    function mintTokens(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
        emit TokensMinted(to, amount);
    }

    function transferTokens(address to, uint256 amount) external {
        require(balanceOf(msg.sender) >= amount, "Insufficient tokens.");
        _transfer(msg.sender, to, amount);
        emit TokensTransferred(msg.sender, to, amount);
    }

    function redeemTokens(uint256 amount) external {
        require(balanceOf(msg.sender) >= amount, "Insufficient tokens to redeem.");
        _burn(msg.sender, amount);
        emit TokensRedeemed(msg.sender, amount);
    }

    function checkBalance() external view returns (uint256) {
        return balanceOf(msg.sender);
    }

    function burnTokens(uint256 amount) external {
        require(balanceOf(msg.sender) >= amount, "Insufficient tokens.");
        _burn(msg.sender, amount);
        emit TokensBurned(msg.sender, amount);
    }
}
