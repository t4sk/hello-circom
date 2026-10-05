pragma circom 2.2.3;

template Mul() {
    signal input a;
    signal input b;
    signal input c;
    signal output d;

    // Non quadratic constraint
    // At most 1 multiplication of 2 signals per constraint
    // This will not compile (3 signals multiplied)
    // d <== a * b * c;
    // This will compile (1 constant and 2 signals multiplied)
    // d <== 2 * b * c;

    signal ab;
    ab <== a * b;
    d <== ab * c;
}

component main = Mul();
