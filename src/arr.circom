pragma circom 2.2.3;

template Mul() {
    // Fixed sized array of 2 inputs
    signal input in[2];
    signal output out;

    out <== in[0] * in[1];
}

component main = Mul();
