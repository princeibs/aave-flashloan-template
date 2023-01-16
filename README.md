# AAVE Flash Loan Template

This is a template for creating a flash loan on the AAVE protocol.

All AAVE's core contracts and interfaces are already included in the template. Locate the `Flash` contract in the Flash.sol file to add your logic. 

**Check the `arbitrage` branch for an example of implementing arbitrage with flash loans.**

### How to test (Using [Remix IDE](https://remix.ethereum.org))
1. Request for some DAI from [AAVE faucet](https://app.aave.com/faucet/).
2. Add the DAI token address to your wallet. (Note that this is AAVE's version of DAI and might be different from the one you have already).
<img width="354" alt="image" src="https://user-images.githubusercontent.com/64266194/212767909-5c718e2e-8e03-41ba-8265-cdc5e89db561.png">

3. Deploy `Flash` contract inside `contracts/Flash.sol` file on the Remix IDE interface using the `Pool Address Provider - AAVE" address found [here](https://docs.aave.com/developers/deployed-contracts/v3-testnet-addresses).

4. Send 1 DAI to the deployed contract. This will be used to pay back interest when returning loaned amount to AAVE.
5. From the Remix IDE interface, click on the `requestFlashloan` button and pass in your DAI wallet address as the first parameter and the amount you want to borrow as the second parameter. Append 18 zeros to the amount to handle DAI's decimal.
<img width="354" alt="image" src="https://user-images.githubusercontent.com/64266194/212767548-b6156ed3-bf36-424a-b0cb-2552727c5137.png">
