pragma circom 2.2.3;

// Public signal - value is given to the verifier
// Private signal - value is hidden from the verifier

template Mul() {
    // Default is private
    signal input a;
    // Default is private
    signal input b;
    // Public
    signal output c;

    c <== a * b;
}

// Makes signals a and b public
component main {public [a, b]} = Mul();
