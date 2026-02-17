pragma circom 2.0.0;

include "node_modules/circomlib/circuits/comparators.circom";

/**
 * @title MASThreshold
 * @dev Generic multi-agent consensus threshold attestation circuit.
 * It proves that a consensus score derived from N agents meets a public threshold.
 */
template MASThreshold(nBits) {
    signal input score;        // Private: The aggregated consensus score
    signal input threshold;    // Public: The required threshold (e.g. 80)
    signal output isCompliant; // Public: 1 if score >= threshold, 0 otherwise

    component gte = GreaterEqThan(nBits);
    
    gte.in[0] <== score;
    gte.in[1] <== threshold;

    isCompliant <== gte.out;
}

// 8-bit version (0-255) suitable for percentage-based scoring (0-100)
component main {public [threshold]} = MASThreshold(8);
