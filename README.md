# 19_bit_CPU_architecture_using_verilog


This project implements a 19-bit CPU architecture with a custom instruction set tailored for specialized applications such as signal processing and cryptography. The CPU is designed and implemented in Verilog.

## Features

- 19-bit instruction size
- 16 general-purpose registers (each 19-bit wide)
- Specialized instructions for FFT, encryption, and decryption
- Basic arithmetic, logical, control flow, and memory access instructions
- Simple pipeline with stages for fetch, decode, execute, memory access, and write-back
- Stack-based subroutine call/return mechanism

## Instruction Set

### Arithmetic Instructions

| Mnemonic | Description | Operation |
|----------|-------------|-----------|
| ADD r1, r2, r3 | Add the values in registers r2 and r3, and store the result in r1. | r1 = r2 + r3 |
| SUB r1, r2, r3 | Subtract the value in register r3 from the value in register r2, and store the result in r1. | r1 = r2 - r3 |
| MUL r1, r2, r3 | Multiply the values in registers r2 and r3, and store the result in r1. | r1 = r2 * r3 |
| DIV r1, r2, r3 | Divide the value in register r2 by the value in register r3, and store the result in r1. | r1 = r2 / r3 |
| INC r1 | Increment the value in register r1 by 1. | r1 = r1 + 1 |
| DEC r1 | Decrement the value in register r1 by 1. | r1 = r1 - 1 |

### Logical Instructions

| Mnemonic | Description | Operation |
|----------|-------------|-----------|
| AND r1, r2, r3 | Perform a bitwise AND on the values in registers r2 and r3, and store the result in r1. | r1 = r2 & r3 |
| OR r1, r2, r3 | Perform a bitwise OR on the values in registers r2 and r3, and store the result in r1. | r1 = r2 \| r3 |
| XOR r1, r2, r3 | Perform a bitwise XOR on the values in registers r2 and r3, and store the result in r1. | r1 = r2 ^ r3 |
| NOT r1, r2 | Perform a bitwise NOT on the value in register r2, and store the result in r1. | r1 = ~r2 |

### Control Flow Instructions

| Mnemonic | Description | Operation |
|----------|-------------|-----------|
| JMP addr | Jump to the specified address. | PC = addr |
| BEQ r1, r2, addr | Branch to the specified address if the values in registers r1 and r2 are equal. | if (r1 == r2) PC = addr |
| BNE r1, r2, addr | Branch to the specified address if the values in registers r1 and r2 are not equal. | if (r1 != r2) PC = addr |
| CALL addr | Call a subroutine at the specified address. | stack[SP] = PC + 1; SP = SP - 1; PC = addr |
| RET | Return from a subroutine. | SP = SP + 1; PC = stack[SP] |

### Memory Access Instructions

| Mnemonic | Description | Operation |
|----------|-------------|-----------|
| LD r1, addr | Load the value from the specified memory address into register r1. | r1 = memory[addr] |
| ST addr, r1 | Store the value in register r1 to the specified memory address. | memory[addr] = r1 |

### Custom Instructions (for specialized applications)

| Mnemonic | Description | Operation |
|----------|-------------|-----------|
| FFT r1, r2 | Perform a Fast Fourier Transform on the data starting at address r2, and store the result in the location pointed to by r1. | FFT(memory[r2], result); memory[r1] = result |
| ENC r1, r2 | Encrypt the data starting at address r2 using a predefined encryption algorithm, and store the result in the location pointed to by r1. | encrypted_data = Encrypt(memory[r2]); memory[r1] = encrypted_data |
| DEC r1, r2 | Decrypt the data starting at address r2 using a predefined decryption algorithm, and store the result in the location pointed to by r1. | decrypted_data = Decrypt(memory[r2]); memory[r1] = decrypted_data |

## Pipeline Stages

1. **Fetch**: Fetch the instruction from memory using the program counter (PC).
2. **Decode**: Decode the instruction to determine the opcode and operands.
3. **Execute**: Perform the operation specified by the opcode.
4. **Memory Access**: Access memory if the instruction involves a load or store operation.
5. **Write-back**: Write the result back to the destination register.

## Register File

- 16 general-purpose registers (`gen_pur_register[0:15]`), each 19-bit wide.

## ALU (Arithmetic Logic Unit)

- Supports arithmetic operations (ADD, SUB, MUL, DIV, INC, DEC).
- Supports logical operations (AND, OR, XOR, NOT).

## Memory Interface

- Memory size: 2^19 (524,288) addresses, each storing 19-bit data.
- Separate instruction and data memory (Harvard architecture).

## Specialized Operations

- **FFT**: Fast Fourier Transform for signal processing.
- **ENC**: Encryption using a predefined algorithm.
- **DEC**: Decryption using a predefined algorithm.

## Usage

1. Clone the repository.
2. Open the Verilog files in your preferred simulation environment.
3. Compile and run the simulation to verify the CPU's functionality.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgements

- Special thanks to the contributors and the community for their support and guidance.

## Contact

For any queries or contributions, please open an issue or submit a pull request.

---


