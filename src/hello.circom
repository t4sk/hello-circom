pragma circom 2.2.3;

// Multiply 2 numbers - proves a*b = c without revealing a and b
// template - defines a reusable circuit
template Mul() {
    // Private signal - known only to the prover
    // Public signal - given to the verifier alongside proof

    // signal input [private] - value supplied from outside the circuit
    signal input a;
    signal input b;
    // signal output [public] - value the circuit computes
    signal output c;

    // 3 operators (<--, ===, <==)
    // c <-- a * b (assign a * b to c)
    // c === a * b (add constraint a * b must = c)
    // c <== a * b (assign (<--) and add constraint (===))
    c <== a * b;
}

// Entry point of Circom program
component main = Mul();
