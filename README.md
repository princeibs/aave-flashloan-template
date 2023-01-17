# AAVE Flash Loan Template

This branch of this repo contains an example of implementing arbitrage with flash loan between two DEXes with price difference on a token (CAKE token).

### How to test (on [Remix IDE](https://remix.ethereum.org))
Follow the steps below to perform an arbitrage

1. Switch your Remix IDE network to **Injected Provider - Metamask** and make sure it's on **Goerli network**
![image](https://user-images.githubusercontent.com/64266194/212853178-e7a5142a-72fc-4588-80cd-573d1faa7670.png)

2. Copy all the contract codes located in `/contracts` folder into their respective files on Remix.
![image](https://user-images.githubusercontent.com/64266194/212853709-6cc5f061-c8d2-45e3-83ad-6262e917778d.png)

3. Compile all the contracts. If you are having problem with compiler, switch your Remix compiler to `0.8.10....`.
![image](https://user-images.githubusercontent.com/64266194/212854192-63c6135f-423c-4504-9a4b-786637b91d36.png)

4. Deploy the `CakeToken` contract.

  * Click on the **Deploy** button.

  ![image](https://user-images.githubusercontent.com/64266194/212854559-372222b8-7683-49e4-817d-26e25c2a965d.png)

  * After deployment.

  ![image](https://user-images.githubusercontent.com/64266194/212854775-5addb411-c63a-431c-88cf-3047adb96a61.png)

5. Deploy `Dex1` and `Dex2` contract with `CakeToken` contract address.

6. Deploy `Arbitrage` contract with `PoolAddressProvider` contract address (`_addressProvider`), and the addresses of `CakeToken`, `Dex1`, and `Dex2` contract. The current address for `_addressProvider` is `0xc4dCB5126a3AfEd129BC3668Ea19285A9f56D15D`. Please note that it is subject to change in the future. Search for "**PoolAddressProvider - AAVE**" [here](https://docs.aave.com/developers/deployed-contracts/v3-testnet-addresses) to see the possibly updated address.

7. Send 1 DAI (AAVE's DAI) to `Arbitrage` contract from Metamask wallet. Add the AAVE's DAI address to your metamask if you don't already have - `0xDF1742fE5b0bFc12331D8EAec6b478DfDbD31464`. Make request [here](https://app.aave.com/faucet/) if you are short of AAVE's DAI (Ensure you toggle **testnet mode** from the settings icon on the top right corner of the screen before proceeding).

8. Send 2000 DAI to `Dex2` to create liquidity which will enable exchange of tokens.
> **Note**
 > * Dex1 sells 1 CAKE for 1 DAI
 > * Dex2 sells 1 CAKE for 2 DAI
 > * We want to borrow 1000 DAI from AAVE and use it to buy 1000 CAKE from Dex1.
 > * And then proceed to sell the 1000 CAKE to Dex2 for 2000 DAI. Since CAKE costs 2 DAI on Dex2 and 1 DAI on Dex1.
 
9. Execute the `requestFlashloan` function by clicking on the respective button on Remix interface. Take note of the 18 zeros we added. This is because DAI has a decimal of 18.

![image](https://user-images.githubusercontent.com/64266194/212864124-6cb8b6a2-20be-4fdf-9116-08d1683359e7.png)

10. When the transaction is complete, check the transaction receipt on etherscan and you should see something like this:
![image](https://user-images.githubusercontent.com/64266194/212864446-888149e7-643e-47f6-b672-adbacdfd2585.png)

Let's examine what happened here line by line
* AAVE's contract sent 1000 DAI to my contract
* My contract sent the 1000 DAI (buy) loaned amount into Dex1 contract.
* Dex1 minted 1000 CAKE tokens in return and send to my contract.
* My contract sent 1000 CAKE tokens to Dex2 (sell)
* Dex2 sent back 2000 DAI in return and send to my contract.
* AAVE's contract withdraw it's 1000 DAI from my contract (plus interest i.e **_.5_** DAI attached to 1000 DAI my contract is sending back)

11. Proceed to check the balance of `Arbitrage` contract to see DAI gained from the flash loan. 

![image](https://user-images.githubusercontent.com/64266194/212868271-ed734217-81c9-4942-b78c-2ca43e6c8950.png)

(`Arbitrage` contract gained 1000 DAI from the operation. **_.5_** DAI attached to the balance is the amount remaining after the interest has been removed from 1 DAI we sent earlier in step 7.

