pragma circom 2.2.3;

// Unconstraint circuit
template Mul() {
    signal input a;
    signal input b;
    signal input c;
    signal output out;

    // Assign a * b to out
    out <-- a * b;
    // Check out == c
    out === c;
}

component main = Mul();
