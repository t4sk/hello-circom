pragma circom 2.2.3;

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

component main = Num2Bits(4);

