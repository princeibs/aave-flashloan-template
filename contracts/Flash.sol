
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {FlashLoanSimpleReceiverBase} from "@aave/core-v3/contracts/flashloan/base/FlashLoanSimpleReceiverBase.sol";
import {IPoolAddressesProvider} from "@aave/core-v3/contracts/interfaces/IPoolAddressesProvider.sol";
import {IERC20} from "@aave/core-v3/contracts/dependencies/openzeppelin/contracts/IERC20.sol";

/// @title Flash loan contract 
/// @notice Execute a flash loan using AAVE's pool contract
contract Flash is FlashLoanSimpleReceiverBase {
    
    /// owner of contract
    address payable owner;

    modifier onlyOwner() {
        require( msg.sender == owner, "Only the contract owner can call this function");
        _;
    }

    /// @notice Contract constructor.
    /// @param _addressProvider `PoolAddressesProvider` deployed contract address.
    ///     To get `_addressProvider`, check for "PoolAddressesProvider - Aave" here -> https://docs.aave.com/developers/deployed-contracts/v3-testnet-addresses 
    ///     The current value is -> 0xc4dCB5126a3AfEd129BC3668Ea19285A9f56D15D (Note: This is subject to change in the future).
    ///     It also sets the owner of the contract.
    /// @dev Initialises the `FlashLoanSimpleReceiverBase` contract using the deployed `PoolAddressesProvider` contract address.
    constructor(address _addressProvider)
        FlashLoanSimpleReceiverBase(IPoolAddressesProvider(_addressProvider))
    {
        owner = payable(msg.sender);
    }

    /// @notice Write all flash loan logic in this function
    /// @dev The `Pool` contract calls this function execute and return the loaned amount (+ interest) immediately after sending the funds into the contract
    ///      Ensure there is enough funds in this contract to pay for the loan + interest, else the transaction won't go through.
    function executeOperation(
        address asset,
        uint256 amount,
        uint256 premium,
        address initiator,
        bytes calldata params
    ) external override returns (bool) {

        /** 
         * YOUR LOGIC GOES HERE
         */

        // Approve the `Pool` contract to pull the loaned amount + premium(interest) from this contract
        uint256 amountOwed = amount + premium;
        IERC20(asset).approve(address(POOL), amountOwed);

        return true;
    }

    /// @notice Use this function to request flash loan from the `Pool` contract
    /// @param _token Contract address of the token to borrow.
    ///        Check https://docs.aave.com/developers/deployed-contracts/v3-testnet-addresses for list of all the token addresses
    /// @param _amount Amount to borrow from `Pool` contract (Take note of asset's decimal)
    function requestFlashLoan(address _token, uint256 _amount) public {
        address receiverAddress = address(this);
        address asset = _token;
        uint256 amount = _amount;
        bytes memory params = "";
        uint16 referralCode = 0;

        POOL.flashLoanSimple(
            receiverAddress,
            asset,
            amount,
            params,
            referralCode
        );
    }

    /// @notice Check balance of the contract to see difference after the loan
    /// @param _tokenAddress Address of asset borrowed
    function getBalance(address _tokenAddress) external view returns (uint256) {
        return IERC20(_tokenAddress).balanceOf(address(this));
    }

    /// @notice Withdraw asset from contract
    /// @param _tokenAddress Address to token borrowed
    function withdraw(address _tokenAddress) external onlyOwner {
        IERC20 token = IERC20(_tokenAddress);
        token.transfer(msg.sender, token.balanceOf(address(this)));
    }

    receive() external payable {}
}