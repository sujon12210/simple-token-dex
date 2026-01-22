const hre = require("hardhat");

async function main() {
  const [deployer] = await hre.ethers.getSigners();
  console.log("Deploying contracts with account:", deployer.address);

  // Deploy Mock Tokens
  const Token = await hre.ethers.getContractFactory("MockToken");
  const tokenA = await Token.deploy("Gold", "GLD");
  await tokenA.waitForDeployment();
  console.log("Token A deployed to:", tokenA.target);

  const tokenB = await Token.deploy("Silver", "SLV");
  await tokenB.waitForDeployment();
  console.log("Token B deployed to:", tokenB.target);

  // Deploy DEX
  const DEX = await hre.ethers.getContractFactory("SimpleDEX");
  const dex = await DEX.deploy(tokenA.target, tokenB.target);
  await dex.waitForDeployment();
  console.log("SimpleDEX deployed to:", dex.target);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
