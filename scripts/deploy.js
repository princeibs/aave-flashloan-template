const hre = require("hardhat");

async function main() {
  const Flash = await hre.ethers.getContractFactory("Flash");
  const flash = await Flash.deploy(
    "0xc4dCB5126a3AfEd129BC3668Ea19285A9f56D15D"
  );

  await flash.deployed();

  console.log("Flash contract deployed: ", flash.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});