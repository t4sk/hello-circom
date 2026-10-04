# Hello

## 0. Check the circuit compiles

```shell
circom src/hello.circom
```

## 1. Generate R1CS file

```shell
mkdir build
circom src/hello.circom --r1cs --sym --wasm --inspect -o build
```

`--r1cs`: Generates a R1CS representation of the circuit
`--sym`: Generates a symbols file that maps internal wire positions to human readable signal names
`--wasm`: Generates a WebAssembly artifacts, used during witness generation
`--inspect`: Additional checks over the constraints produced
`-o`: Specify path to output compilation artifacts

### Print r1cs file

```shell
npx snarkjs r1cs print build/hello.r1cs
```

## 2. Generate witness

### Create an input file to execute the circuit

```shell
cd build/hello_js
```

Store this as `input.json`

```
{
    "a": "2",
    "b": "3",
}
```

### Generate witness

Execute `generate_witness.js` inside `build/hello_js` to generate a witness

```shell
node generate_witness.js hello.wasm input.json witness.wtns
```

### Convert witness (witness.wtns) into JSON

```shell
npx snarkjs wtns export json witness.wtns
```

### See content of witness.json

```shell
cat witness.json
```

## 3. Trusted setup

Instructions from [snarkjs](https://github.com/iden3/snarkjs)

Execute the following commands inside `build/`

```
# 1. Start a new powers of tau ceremony
npx snarkjs powersoftau new bn128 14 pot14_0000.ptau -v

# 2. Contribute to the ceremony
npx snarkjs powersoftau contribute pot14_0000.ptau pot14_0001.ptau --name="First contribution" -v

# 3. Provide a second contribution
npx snarkjs powersoftau contribute pot14_0001.ptau pot14_0002.ptau --name="Second contribution" -v -e="some random text"

# 4. Provide a third contribution using third-party software
npx snarkjs powersoftau export challenge pot14_0002.ptau challenge_0003
npx snarkjs powersoftau challenge contribute bn128 challenge_0003 response_0003 -e="some random text"
npx snarkjs powersoftau import response pot14_0002.ptau response_0003 pot14_0003.ptau -n="Third contribution name"

# 5. Verify the protocol so far
npx snarkjs powersoftau verify pot14_0003.ptau

# 6. Apply a random beacon
npx snarkjs powersoftau beacon pot14_0003.ptau pot14_beacon.ptau 0102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f 10 -n="Final Beacon"

# 7. Prepare phase 2
npx snarkjs powersoftau prepare phase2 pot14_beacon.ptau pot14_final.ptau -v

# 8. Verify the final ptau
npx snarkjs powersoftau verify pot14_final.ptau

# 15. Setup
npx snarkjs groth16 setup ../src/hello.r1cs pot14_final.ptau circuit_0000.zkey

# 16. Contribute to the phase 2 ceremony
npx snarkjs zkey contribute circuit_0000.zkey circuit_0001.zkey --name="1st Contributor Name" -v

# 17. Provide a second contribution
npx snarkjs zkey contribute circuit_0001.zkey circuit_0002.zkey --name="Second contribution Name" -v -e="Another random entropy"

# 18. Provide a third contribution using third-party software
npx snarkjs zkey export bellman circuit_0002.zkey challenge_phase2_0003
npx snarkjs zkey bellman contribute bn128 challenge_phase2_0003 response_phase2_0003 -e="some random text"
npx snarkjs zkey import bellman circuit_0002.zkey response_phase2_0003 circuit_0003.zkey -n="Third contribution name"

# 19. Verify the latest zkey
npx snarkjs zkey verify ../src/hello.r1cs pot14_final.ptau circuit_0003.zkey

# 20. Apply a random beacon
npx snarkjs zkey beacon circuit_0003.zkey circuit_final.zkey 0102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f 10 -n="Final Beacon phase2"

# 21. Verify the final zkey
npx snarkjs zkey verify ../src/hello.r1cs pot14_final.ptau circuit_final.zkey

# 22. Export the verification key
npx snarkjs zkey export verificationkey circuit_final.zkey verification_key.json
```

## 4. Generate the proof

```shell
# 23. Create the proof
npx snarkjs groth16 prove circuit_final.zkey ./hello_js/witness.wtns proof.json public.json

# 24. Verify the proof
npx snarkjs groth16 verify verification_key.json public.json proof.json
```

### Generate Solidity verifier (optional)

```shell
# 25. Turn the verifier into a smart contract
npx snarkjs zkey export solidityverifier circuit_final.zkey verifier.sol

# 26. Simulate a verification call
npx snarkjs zkey export soliditycalldata public.json proof.json
```
