// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import {IERC20} from "@aave/core-v3/contracts/dependencies/openzeppelin/contracts/IERC20.sol";
import {CakeToken} from "./CakeToken.sol";

/// @title Dex1: 1 CAKE = 1 DAI
/// @notice Buy CAKE token with DAI at a cheaper rate
contract Dex1 {
    address private constant DAI_ADDRESS = 0xDF1742fE5b0bFc12331D8EAec6b478DfDbD31464;

    CakeToken private cake;
    IERC20 private dai;
    // Exchange rate. 1 CAKE = 1 DAI
    uint256 private rate = 100 / 100; // This is apprently redundant here but it is useful in explaining the value in Dex2.sol contract

    mapping(address => uint256) public balances;

    constructor(address _cakeAddress) {
        cake = CakeToken(_cakeAddress);
        dai = IERC20(DAI_ADDRESS);
    }

    function deposit(uint256 _amount) public {
        uint256 allowance = dai.allowance(msg.sender, address(this));
        require(allowance >= _amount * 10**18, "Give Dex1 contract allowance to spend your DAI");
        require(dai.balanceOf(msg.sender) >= _amount * 10**18, "Dex1.deposit: Not enough dai to transfer");
        bool success = dai.transferFrom(msg.sender, address(this), _amount * 10**18);
        require(success, "Failed to transfer DAI from Dex1");
        balances[msg.sender] += _amount;
    }

    /// @notice Caller pays DAI and get it's CAKE equivalent
    function buy() public {
        uint256 bal = balances[msg.sender];
        require(bal > 0, "Balance too low to complete 'buy' operation");
        cake.request(msg.sender, bal * rate);
        balances[msg.sender] = 0; // clear balance
    }
}