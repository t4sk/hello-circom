pragma circom 2.2.3;

include "../node_modules/circomlib/circuits/poseidon.circom";

// Optionally, replace Swap with circomlib import
// include "../../node_modules/circomlib/circuits/switcher.circom";

// if s = 0 return [in[0], in[1]]
// if s = 1 return [in[1], in[0]]
template Swap() {
    signal input s;
    signal input in[2];
    signal output out[2];

    // Check s = 0 or 1
    s * (s - 1) === 0;

    out[0] <== (in[1] - in[0]) * s + in[0];
    out[1] <== (in[0] - in[1]) * s + in[1];
}

// Optionally, replace Num2Bits with circomlib import
// include "../../node_modules/circomlib/circuits/bitify.circom";
template Num2Bits(N) {
    // N must be < 254, Circom works over prime field < 2^254
    // Checked during compilation
    assert(N < 254);

    // Number to represent as N bits
    signal input in;
    // N bits
    signal output out[N];

    // Used to check `in` is less than or equal to N bits
    var sum = 0;
    for (var i = 0; i < N; i++) {
        out[i] <-- (in >> i) & 1;
        // Check out[i] is either 0 or 1
        out[i] * (out[i] - 1) === 0;
        sum += out[i] * (2**i);
    }

    // sum = out[0]*1 + out[1]*2 + out[2]*4 + ...
    sum === in;
}

// Merkle proof verifier
// N = depth of Merkle tree
//     depth = 0 -> only root node
//     depth = 1 -> root node + leaf nodes
template Merkle(N) {
    // Leaf index
    signal input idx;
    signal input leaf;
    signal input root;
    signal input proof[N];

    component bits = Num2Bits(N);
    bits.in <== idx;

    // If / else conditions
    component swaps[N];
    // Store hash functions
    component hashers[N];

    var h = leaf;
    for (var i = 0; i < N; i++) {
        swaps[i] = Swap();
        swaps[i].in[0] <== h;
        swaps[i].in[1] <== proof[i];
        // bits[i] = 0 -> (left = h, right = proof[i])
        //         = 1 -> (left = proof[i], right = h)
        swaps[i].s <== bits.out[i];

        hashers[i] = Poseidon(2);
        hashers[i].inputs[0] <== swaps[i].out[0];
        hashers[i].inputs[1] <== swaps[i].out[1];

        h = hashers[i].out;
    }

    root === h;
}

component main {public [root]} = Merkle(5);
