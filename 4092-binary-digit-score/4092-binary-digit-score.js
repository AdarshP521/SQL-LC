/**
 * @param {number} a
 * @param {number} b
 * @return {number}
 */
var calculateScore = function(a, b) {
    // Helper function to count set bits (1s) in binary representation
    const countSetBits = (n) => {
        let count = 0;
        while (n > 0) {
            count += n & 1;
            n >>= 1;
        }
        return count;
    };

    const s1 = countSetBits(a);
    const s2 = countSetBits(b);

    if (s1 >= s2) {
        return s1 * s2;
    } else {
        return Math.floor(s2 / s1);
    }
};