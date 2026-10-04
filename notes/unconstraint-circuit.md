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

## What is `x <-- y`?

### Compilation

- Adds assignment (value of `y` to `x`) to the witness generator

### Execution (witness generation)

- Assign the value of `y` to `x`

### Proof generation

- Nothing

## What is `x === y`?

### Compilation

- Adds assertion (checks `x` equals `y`) to witness generator
- Adds R1CS constraint (`x` must equal `y`)

### Execution (witness generation)

- Checks `x` equals `y`

### Proof generation

- Checks R1CS constraint that values provided for `x` and `y` are equal.

## What is `x <== y`?

`x <== y` is shorthand for `x <-- y; x === y;`

### Compilation

- Adds assignment (`x <-- y`) to the witness generator
- Adds assertion (`x === y`) to the witness generator
- Adds constraint (`x === y`) to R1CS

### Execution (witness generation)

- Assigns `y` to `x` and checks that `x` equals `y`

### Proof generation

- Given a witness (a list of numbers, not necessarily from witness generation), proves that the witness satisfies the R1CS constraints

## Bug

```circom
out <-- a * b;
out === c;
```

Missing constraint on `out`.

`out <-- a * b;` does not add any R1CS constraint, so the proof generator never checks that `out === a * b`

The code that the proof generator sees roughly looks like

```circom
template Mul() {
    signal input a;
    signal input b;
    signal input c;
    signal output out;

    out === c;
}
```

A prover can provide `a = 0`, `b = 0`, `c = 1`, `out = 1` as witness to generate a valid proof.

## Fix

```circom
# Remove
out <-- a * b;
out === c;

# Add
out <== a * b;
```
