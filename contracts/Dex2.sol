// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import {IERC20} from "@aave/core-v3/contracts/dependencies/openzeppelin/contracts/IERC20.sol";
import {CakeToken} from "./CakeToken.sol";

/// @title Dex2: 1 CAKE = 2 DAI
/// @notice Sell CAKE token for DAI at a higher rate
contract Dex2 {

    address private constant DAI_ADDRESS = 0xDF1742fE5b0bFc12331D8EAec6b478DfDbD31464;

    CakeToken private cake;
    IERC20 private dai;
    uint256 private rate = (50 / 100) * 100; // Exchange rate. 1 CAKE = 2 DAI

    constructor(address _cakeAddress) {
        cake = CakeToken(_cakeAddress);
        dai = IERC20(DAI_ADDRESS);
    }

    /// @notice Caller pays `_amount` DAI and get it's CAKE equivalent
    /// @param _amount Quantity of CAKE token caller is buying
    function sell(uint256 _amount) public {
        require(cake.balanceOf(msg.sender) >= _amount * 10**18, "Dex2.sell: Not enough CAKE");
        bool sentCake = cake.transferFrom(msg.sender, address(this), _amount * 10**18);
        require(sentCake, "Failed to transfer CAKE from Dex2");
        require(dai.balanceOf(address(this)) >= _amount * (rate / 100) * 10**18, "Dex2.sell: Not enough DAI");
        bool success = dai.transfer(msg.sender, _amount * (rate / 100) * 10**18);
        require(success, "Failed to transfer DAI on Dex2");
    }
}