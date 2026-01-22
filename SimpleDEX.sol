// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract SimpleDEX is ReentrancyGuard {
    IERC20 public tokenA;
    IERC20 public tokenB;

    event LiquidityAdded(uint256 amountA, uint256 amountB);
    event LiquidityRemoved(uint256 amountA, uint256 amountB);
    event Swap(address indexed user, uint256 amountIn, uint256 amountOut, string tokenIn);

    constructor(address _tokenA, address _tokenB) {
        tokenA = IERC20(_tokenA);
        tokenB = IERC20(_tokenB);
    }

    function addLiquidity(uint256 amountA, uint256 amountB) external nonReentrant {
        require(amountA > 0 && amountB > 0, "Invalid amounts");
        tokenA.transferFrom(msg.sender, address(this), amountA);
        tokenB.transferFrom(msg.sender, address(this), amountB);
        emit LiquidityAdded(amountA, amountB);
    }

    function removeLiquidity(uint256 amountA, uint256 amountB) external nonReentrant {
        // Simplified: In production, use LP tokens to track ownership shares
        require(amountA <= tokenA.balanceOf(address(this)), "Insufficient A");
        require(amountB <= tokenB.balanceOf(address(this)), "Insufficient B");
        
        tokenA.transfer(msg.sender, amountA);
        tokenB.transfer(msg.sender, amountB);
        emit LiquidityRemoved(amountA, amountB);
    }

    // Swap Token A -> Token B
    function swapAforB(uint256 amountAIn) external nonReentrant {
        require(amountAIn > 0, "Amount must be > 0");

        uint256 reserveA = tokenA.balanceOf(address(this));
        uint256 reserveB = tokenB.balanceOf(address(this));

        // Calculate amount out using x * y = k
        // (reserveA + amountIn) * (reserveB - amountOut) = reserveA * reserveB
        uint256 amountBOut = getAmountOut(amountAIn, reserveA, reserveB);

        tokenA.transferFrom(msg.sender, address(this), amountAIn);
        tokenB.transfer(msg.sender, amountBOut);

        emit Swap(msg.sender, amountAIn, amountBOut, "TokenA");
    }

    // Swap Token B -> Token A
    function swapBforA(uint256 amountBIn) external nonReentrant {
        require(amountBIn > 0, "Amount must be > 0");

        uint256 reserveA = tokenA.balanceOf(address(this));
        uint256 reserveB = tokenB.balanceOf(address(this));

        uint256 amountAOut = getAmountOut(amountBIn, reserveB, reserveA);

        tokenB.transferFrom(msg.sender, address(this), amountBIn);
        tokenA.transfer(msg.sender, amountAOut);

        emit Swap(msg.sender, amountBIn, amountAOut, "TokenB");
    }

    function getAmountOut(uint256 amountIn, uint256 reserveIn, uint256 reserveOut) public pure returns (uint256) {
        require(reserveIn > 0 && reserveOut > 0, "Invalid reserves");
        // 0.3% Fee removed for simplicity in this basic example, pure XY=K
        uint256 numerator = amountIn * reserveOut;
        uint256 denominator = reserveIn + amountIn;
        return numerator / denominator;
    }
}
