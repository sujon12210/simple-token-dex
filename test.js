const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("SimpleDEX", function () {
  it("Should swap Token A for Token B", async function () {
    const [owner] = await ethers.getSigners();

    // Setup
    const Token = await ethers.getContractFactory("MockToken");
    const tokenA = await Token.deploy("Gold", "GLD");
    const tokenB = await Token.deploy("Silver", "SLV");
    const DEX = await ethers.getContractFactory("SimpleDEX");
    const dex = await DEX.deploy(tokenA.target, tokenB.target);

    // Add Liquidity (1000 A, 1000 B)
    await tokenA.approve(dex.target, 1000);
    await tokenB.approve(dex.target, 1000);
    await dex.addLiquidity(1000, 1000);

    // Swap
    await tokenA.approve(dex.target, 100);
    const amountIn = 100;
    
    // Expect output based on formula: (100 * 1000) / (1000 + 100) = 90
    await dex.swapAforB(amountIn);

    expect(await tokenB.balanceOf(owner.address)).to.equal(1000000000000000000000000n - 1000n + 90n);
  });
});
