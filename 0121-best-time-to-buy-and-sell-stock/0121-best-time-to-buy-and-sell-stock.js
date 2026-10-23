var maxProfit = function(prices) {
    let = max = 0,
    min = prices[0]
    prices.forEach((e) => {
        min = Math.min(min, e)
        max = Math.max(max, e - min)
    })
    return max
};