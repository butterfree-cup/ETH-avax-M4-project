// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract DegenToken is ERC20, Ownable {
    event TokensMinted(address indexed to, uint256 amount);
    event TokensTransferred(address indexed from, address indexed to, uint256 amount);
    event HeadCosmeticRedeemed(address indexed from, uint256 amount);
    event TopCosmeticRedeemed(address indexed from, uint256 amount);
    event BottomCosmeticRedeemed(address indexed from, uint256 amount);
    event TokensBurned(address indexed from, uint256 amount);

    struct PlayerCloset {
        string[] redeemedCosmetics;
    }

    // Mapping to store player closet
    mapping(address => PlayerCloset) private playerClosets;

    struct Cosmetic {
        string[] names;
        uint256[] prices;
    }

    struct CharacterCosmetics {
        Cosmetic head;
        Cosmetic top;
        Cosmetic bottom;
    }

    CharacterCosmetics public characterCosmetics;

    constructor() ERC20("Degen", "DGN") {
        // Initialize default cosmetics
        characterCosmetics.head.names = ["Cowboy Hat", "Crown"];
        characterCosmetics.head.prices = [10, 15];
        characterCosmetics.top.names = ["T-Shirt", "Leather Jacket"];
        characterCosmetics.top.prices = [5, 12];
        characterCosmetics.bottom.names = ["Jeans", "Cargo Pants"];
        characterCosmetics.bottom.prices = [8, 10];
    }

    function mintTokens(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
        emit TokensMinted(to, amount);
    }

    function transferTokens(address to, uint256 amount) external {
        require(balanceOf(msg.sender) >= amount, "Insufficient tokens.");
        _transfer(msg.sender, to, amount);
        emit TokensTransferred(msg.sender, to, amount);
    }

    function redeemHead(uint256 headIndex) external {
        require(headIndex > 0 && headIndex <= characterCosmetics.head.names.length, "Invalid head index");
        require(balanceOf(msg.sender) >= characterCosmetics.head.prices[headIndex - 1], "Insufficient tokens to redeem cosmetic.");

        _burn(msg.sender, characterCosmetics.head.prices[headIndex - 1]);

        emit HeadCosmeticRedeemed(msg.sender, characterCosmetics.head.prices[headIndex - 1]);

        // Save redeemed cosmetics
        playerClosets[msg.sender].redeemedCosmetics.push(characterCosmetics.head.names[headIndex - 1]);
    }

    function redeemTop(uint256 topIndex) external {
        require(topIndex > 0 && topIndex <= characterCosmetics.head.names.length, "Invalid top index");
        require(balanceOf(msg.sender) >= characterCosmetics.head.prices[topIndex - 1], "Insufficient tokens to redeem cosmetic.");

        _burn(msg.sender, characterCosmetics.top.prices[topIndex - 1]);

        emit TopCosmeticRedeemed(msg.sender, characterCosmetics.top.prices[topIndex - 1]);

        // Save redeemed cosmetics
        playerClosets[msg.sender].redeemedCosmetics.push(characterCosmetics.top.names[topIndex - 1]);
    }    

    function redeemBottom(uint256 bottomIndex) external {
        require(bottomIndex > 0 && bottomIndex <= characterCosmetics.head.names.length, "Invalid head index");
        require(balanceOf(msg.sender) >= characterCosmetics.head.prices[bottomIndex - 1], "Insufficient tokens to redeem cosmetic.");

        _burn(msg.sender, characterCosmetics.bottom.prices[bottomIndex - 1]);

        emit BottomCosmeticRedeemed(msg.sender, characterCosmetics.bottom.prices[bottomIndex - 1]);

        // Save redeemed cosmetics
        playerClosets[msg.sender].redeemedCosmetics.push(characterCosmetics.bottom.names[bottomIndex - 1]);
    }

    // displays player's redeemed cosmetics
    function getPlayerCloset() external view returns (string memory) {
        string memory closet;
        
        for (uint256 i = 0; i < playerClosets[msg.sender].redeemedCosmetics.length; i++) {
            if (i > 0) {
                closet = string(abi.encodePacked(closet, ", ",  playerClosets[msg.sender].redeemedCosmetics[i]));
            } else {
                closet = playerClosets[msg.sender].redeemedCosmetics[i];
            }
        }

        return closet;
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
