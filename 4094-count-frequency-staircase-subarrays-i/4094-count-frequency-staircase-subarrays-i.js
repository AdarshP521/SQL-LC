/**
 * @param {number[]} nums
 * @return {number}
 */
var countStaircase = function(nums) {
    const n = nums.length;
    let totalCount = 0;

    for (let i = 0; i < n; i++) {
        const order = []; // Stores distinct values in order of first appearance
        const freqMap = new Map(); // Frequency count of elements in current subarray

        for (let j = i; j < n; j++) {
            const num = nums[j];

            if (!freqMap.has(num)) {
                order.push(num);
                freqMap.set(num, 1);
            } else {
                freqMap.set(num, freqMap.get(num) + 1);
            }

            const k = order.length;
            const currentFreq = freqMap.get(num);

            // Verify if the newly added element exceeds its expected staircase frequency (1-indexed based on position in order)
            const targetFreqForNum = order.indexOf(num) + 1;
            if (currentFreq > targetFreqForNum) {
                break; // Further extending this subarray will keep it invalid
            }

            // Check if all elements in current subarray strictly match their required frequency: 1, 2, ..., k
            let matchesStaircase = true;
            for (let idx = 0; idx < k; idx++) {
                const val = order[idx];
                const expectedFreq = idx + 1;
                if (freqMap.get(val) !== expectedFreq) {
                    matchesStaircase = false;
                    break;
                }
            }

            if (matchesStaircase) {
                totalCount++;
            }
        }
    }

    return totalCount;
};