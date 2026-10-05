pragma circom 2.2.3;

/*
// Signal structure must be known at compilation
// Signal struction cannot change at execution
// This will not compile
template IfElse() {
    signal input s;
    signal input in[2];
    signal output out[2];

    if (s == 1) {
        out[0] = in[0];
        out[1] = in[1];
    } else {
        out[0] = in[1];
        out[1] = in[0];
    }
}

component main = IfElse();
*/

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

component main = Swap();
