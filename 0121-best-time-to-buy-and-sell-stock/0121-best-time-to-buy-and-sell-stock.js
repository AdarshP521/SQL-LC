/**
 * @param {number[]} prices
 * @return {number}
 */
var maxProfit = function(prices) {
    let minPrice = prices[0],
    profit = 0;
    prices.forEach((e) => {
        if (e < minPrice) {
            minPrice = e;
        } else if (e - minPrice > profit) {
            profit = e - minPrice;
        }
    });
    return profit;
};