# Unconstraint circuit

```circom
template Mul() {
    signal input a;
    signal input b;
    signal input c;
    signal output out;

    out <-- a * b;
    out === c;
}
```

The code above

1. Multiplies `a` and `b`
2. Assigns the product to `out`.
3. Checks that `out` equals to `c`

## What is `<==`?

`a <== b` is shorthand for `a <-- b; a === b;`

It performs different tasks at compilation, execution and proof generation.

### Compilation:

- Adds constraint (`a === b`) to R1CS
- Adds assignment (`a <-- b`) and constraint check (`a === b`) to the witness generator.

### Execution (witness generation):

- Assigns `b` to `a` and checks that `a` equals `b`

### Proof generation:

- Given a witness, proves that the witness satisfies the R1CS constraints
