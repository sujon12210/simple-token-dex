/**
 * Calculates the price of Token A in terms of Token B
 * @param {number} reserveA - Liquidity of Token A
 * @param {number} reserveB - Liquidity of Token B
 * @returns {number} - Price of 1 Token A
 */
function getPriceA(reserveA, reserveB) {
    if (reserveA === 0) return 0;
    return reserveB / reserveA;
}

/**
 * Calculates slippage for a trade
 * @param {number} amountIn - Amount being swapped
 * @param {number} reserveIn - Reserve of input token
 * @returns {string} - Slippage percentage
 */
function calculateSlippage(amountIn, reserveIn) {
    const slippage = amountIn / (reserveIn + amountIn);
    return (slippage * 100).toFixed(2) + "%";
}

module.exports = { getPriceA, calculateSlippage };
