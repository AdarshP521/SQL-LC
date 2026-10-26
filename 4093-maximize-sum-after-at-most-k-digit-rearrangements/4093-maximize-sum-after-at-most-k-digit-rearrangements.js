/**
 * @param {number[]} nums
 * @param {number} k
 * @return {number}
 */
var maximizeSum = function(nums, k) {
    const gainList = [];
    let initialSum = 0n;

    for (const num of nums) {
        // Extract digits and sort in descending order to maximize the individual number
        const digits = String(num).split('').sort((a, b) => b - a);
        const maxVal = BigInt(digits.join(''));
        const originalVal = BigInt(num);

        initialSum += originalVal;
        
        // Calculate the maximum gain achieved by rearranging this number
        const gain = maxVal - originalVal;
        if (gain > 0n) {
            gainList.push(gain);
        }
    }

    // Sort gains in descending order to pick the top k improvements
    gainList.sort((a, b) => (b > a ? 1 : b < a ? -1 : 0));

    // Add the top k gains to the total sum
    let maxGain = 0n;
    const limit = Math.min(k, gainList.length);
    for (let i = 0; i < limit; i++) {
        maxGain += gainList[i];
    }

    // Return result as a number (or BigInt string if constraints exceed MAX_SAFE_INTEGER)
    return Number(initialSum + maxGain);
};