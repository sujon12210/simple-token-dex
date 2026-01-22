# Simple Token DEX

A professional, flat-structure implementation of an Automated Market Maker (AMM) exchange. This repository demonstrates how decentralized trading works by implementing the core logic found in protocols like Uniswap V1/V2.

## How It Works
- **Constant Product Formula:** Uses `x * y = k` to determine exchange rates automatically.
- **Liquidity Pools:** Users can provide liquidity to earn fees (logic extensible).
- **Swapping:** Instant trade execution between Token A and Token B.

## Features
- **Add/Remove Liquidity:** Dynamic pool sizing.
- **Token Swaps:** `swapAforB` and `swapBforA` functions.
- **Price Querying:** View functions to check current exchange rates.
- **100% On-Chain:** No off-chain order books required.

## Quick Start

1. **Install Dependencies:**
   ```bash
   npm install
