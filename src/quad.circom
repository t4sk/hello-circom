pragma circom 2.2.3;

template Mul() {
    signal input a;
    signal input b;
    signal input c;
    signal output d;

    // Non quadratic constraint
    // At most 1 multiplication per constraint
    // This will not compile
    // d <== a * b * c;

    signal ab;
    ab <== a * b;
    d <== ab * c;
}

component main = Mul();
