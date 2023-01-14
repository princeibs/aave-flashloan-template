// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract CakeToken is ERC20, ERC20Burnable, Ownable {
    constructor() ERC20("Cake Token", "CAKE") {}

    /// @notice Mint the requested amount of tokens to caller
    /// @param amount Amount of CAKE tokens to mint. Must not exceed 1000 
    ///        The reason for the amount cap is to control supply of the token.
    function request(address receiver, uint256 amount) public {
        require(amount <= 1000, "Cannot mint more than 1000 tokens at once");
        _mint(receiver, amount * 10 ** decimals());
    }
}