# Hello Circom

## Setup

```shell
# Build and install circom
git clone https://github.com/iden3/circom.git
cargo build --release
cargo install --path circom

# Check circom installation
circom --version

# Install NPM packages
npm i

# Create folder to store circom artifacts
mkdir build
```

## Concepts

### Workflow

```
              |        Compile               |    Witness generation               |      Proof generation
Write circuit -> Generate R1CS + other files -> Execute ciruit -> Generate witness -> Trusted setup -> Generate proof
```

### `Arithmetic circuit`

Computation represented as a graph

```
out = (a * b) + c

a ──┐
    * ──> x ──┐
b ──┘         + ──> out
c ────────────┘
```

### `Witness`

All values used in a single execution of a circuit (private inputs, public inputs and outputs, and all intermediate values).

Example: prove `a * b = c` without revealing `a` and `b`

```
witness = [1, outputs, public inputs, private inputs, intermediates]
        = [1, c, a, b]
```

### Generate a witness

Execute a circuit with specific inputs and generate a `witness` (all values used in the execution).

## Examples

- Hello
  - [code](./src/hello.circom)
  - [notes](./notes/hello.md)
- Unconstraint circuit
  - [code](./src/unconstraint.circom)
  - [notes](./notes/unconstraint-circuit.md)
- Non quadratic constraint
  - [code](./src/quad.circom)
- Arrays
  - [code](./src/arr.circom)
- Template parameters
  - [code](./src/temp.circom)
- Public signals
  - [code](./src/pub.circom)
- Poseidon hash function
  - [code](./src/hash.circom)
- merkle tree
- bugs

## TODO

- trusted setup
  - https://github.com/iden3/snarkjs

## Links

- [circom](https://github.com/iden3/circom)
- [circomlib](https://github.com/iden3/circomlib)
- [snarkjs](https://github.com/iden3/snarkjs)
- [RareSkills](https://rareskills.io/post/circom-tutorial)
- [RareSkills - Hacking Underconstrained Circom Circuits With Fake Proofs](https://rareskills.io/post/underconstrained-circom)
- [Introduction to ZK Circuits with Circom](https://hackmd.io/@Sahil4555/zk/%2FSC-lzeDEQA609ObFojGS5A)
- [zk repl](https://zkrepl.dev/)
- [Railgun circuit-v2](https://github.com/Railgun-Privacy/circuits-v2)
