/**
 * @param {number[]} nums
 * @param {number} target
 * @return {number[]}
 */
var twoSum = function(nums, target) {
    const x = new Map();
    for (let i=0;i<nums.length;i++){
        const complement = target - nums[i];
        if (x.has(complement)){
            return [x.get(complement),i]
        }
        x.set(nums[i],i);
    }
    return null;  
};