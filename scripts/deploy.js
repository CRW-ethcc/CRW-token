const hre = require("hardhat");

async function main() {
  const CRW = await hre.ethers.getContractFactory("CRW");
  const crw = await CRW.deploy("10000000000000000000000000000000");

  await crw.deployed();

  console.log("CRW deployed to:", crw.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
