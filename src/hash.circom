pragma circom 2.2.3;

include "../node_modules/circomlib/circuits/poseidon.circom";

// Poseidon hash of inputs x and y
// Proves hash(x, y) = z
template Hash() {
    signal input x;
    signal input y;
    signal output z;

    // Create Poseidon hash circuit
    component hash = Poseidon(2);
    // Hash inputs x and y
    hash.inputs[0] <== x;
    hash.inputs[1] <== y;

    // Assign z to hash(x, y) and assert z = hash(x, y)
    z <== hash.out;
}

component main = Hash();
