pragma circom 2.2.3;

// Template parameter
template Mul(n) {
    // Dynamic input size, size must be known at compile time
    signal input in[n];
    signal output out;

    signal prod[n];
    prod[0] <== in[0];

    for (var i = 1; i < n; i++) {
        prod[i] <== prod[i - 1] * in[i];
    }

    out <== prod[n - 1];
}

// Multiplication of 3 inputs
component main = Mul(3);
