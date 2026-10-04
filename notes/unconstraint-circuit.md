# Under-constrained circuit

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

The intended behavior of the code above is to

1. Multiply `a` and `b`
2. Assign the product to `out`
3. Check that `out` equals `c`

## What is `x <-- y`?

### Compilation

- Adds assignment (value of `y` to `x`) to the witness generator

### Execution (witness generation)

- Assigns the value of `y` to `x`

### Proof generation

- Nothing

## What is `x === y`?

### Compilation

- Adds assertion (checks `x` equals `y`) to the witness generator
- Adds R1CS constraint (`x` must equal `y`)

### Execution (witness generation)

- Checks `x` equals `y`

### Proof generation

- Checks that the provided values of `x` and `y` are equal.

## What is `x <== y`?

`x <== y` is shorthand for `x <-- y; x === y;`

### Compilation

- Adds assignment (`x <-- y`) to the witness generator
- Adds assertion (`x === y`) to the witness generator
- Adds constraint (`x === y`) to the R1CS

### Execution (witness generation)

- Assigns `y` to `x` and checks that `x` equals `y`

### Proof generation

- Given a witness (a list of numbers, not necessarily from witness generation), proves that the witness satisfies the R1CS constraints, including `x === y`.

## Summary

|           | Adds to R1CS | Adds to witness generator |
| --------- | ------------ | ------------------------- |
| `x <-- y` | nothing      | assignment                |
| `x === y` | constraint   | assertion                 |
| `x <== y` | constraint   | assignment + assertion    |

## Bug

```circom
out <-- a * b;
out === c;
```

Missing constraint on `out`.

`out <-- a * b;` does not add any R1CS constraint, so the proof generator never checks that `out === a * b`.

The R1CS is equivalent to that of a circuit with only `out === c`:

```circom
template Mul() {
    signal input a;
    signal input b;
    signal input c;
    signal output out;

    out === c;
}
```

`a` and `b` are completely unconstrained.

A prover can provide `a = 0`, `b = 0`, `c = 1`, `out = 1` as the witness to generate a valid proof.

Honest witness generation would compute `out = 0` for these inputs and fail the assertion `out === c` (0 ≠ 1), so this witness cannot come from executing the circuit.

The prover skips witness generation and supplies their own numbers. Since the R1CS only checks `out === c`, the proof is valid.

As a result, anyone can produce a valid proof that `a * b = c` for arbitrary `a`, `b`, `c`.

## Fix

```diff
- out <-- a * b;
+ out <== a * b;
  out === c;
```

`<==` adds the constraint `out === a * b` to the R1CS.

Together with `out === c`, the circuit now enforces `a * b === c`, and the witness `a = 0, b = 0, c = 1, out = 1` is rejected.
