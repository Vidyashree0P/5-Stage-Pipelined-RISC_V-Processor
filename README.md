# 32-bit 5-Stage Pipelined RISC-V Processor

## Overview

This project presents the RTL design and implementation of a 32-bit RISC-V processor based on the RV32I instruction set architecture (ISA), using Verilog HDL.

The processor implements a classic five-stage pipelined architecture to improve instruction throughput by allowing multiple instructions to execute simultaneously at different stages of the pipeline.

The design includes instruction fetching, instruction decoding, arithmetic and logical execution, memory access, and register write-back. It also incorporates data forwarding and branch/jump control logic to support instruction dependencies and control-flow operations.

## Architecture

The processor consists of five pipeline stages:

| Stage | Name | Function |
|---|---|---|
| 1 | Instruction Fetch (IF) | Fetches instructions from instruction memory and updates the program counter. |
| 2 | Instruction Decode (ID) | Decodes instructions, reads source registers and generates immediate values and control signals. |
| 3 | Execute (EX) | Performs ALU operations, calculates memory addresses, evaluates branches and computes jump targets. |
| 4 | Memory Access (MEM) | Reads data from memory for load instructions and writes data for store instructions. |
| 5 | Write Back (WB) | Writes ALU results, memory data or PC+4 into the destination register. |

### Pipeline Flow

```text
       ┌────────────┐
       │ Instruction│
       │   Fetch    │
       │    (IF)    │
       └─────┬──────┘
             │
          IF/ID
             │
       ┌─────▼──────┐
       │ Instruction│
       │   Decode   │
       │    (ID)    │
       └─────┬──────┘
             │
          ID/EX
             │
       ┌─────▼──────┐
       │  Execute   │
       │    (EX)    │
       └─────┬──────┘
             │
          EX/MEM
             │
       ┌─────▼──────┐
       │   Memory   │
       │   Access   │
       │    (MEM)   │
       └─────┬──────┘
             │
          MEM/WB
             │
       ┌─────▼──────┐
       │ Write Back │
       │    (WB)    │
       └────────────┘
```

## Supported Instructions

The processor supports the following instruction categories:

| Instruction Type | Supported Instructions |
|---|---|
| R-Type | ADD, SUB, XOR, OR, AND, SLL, SRL, SRA, SLT, SLTU |
| I-Type | ADDI, XORI, ORI, ANDI, SLLI, SRLI, SRAI, SLTI, SLTIU |
| Load | LW |
| Store | SW |
| Branch | BEQ, BNE, BLT, BGE, BLTU, BGEU |
| Jump | JAL, JALR |

## Key Features

- 32-bit RISC-V processor architecture.
- Five-stage instruction pipeline.
- Modular RTL design using Verilog HDL.
- Separate instruction and data memories.
- 32 × 32-bit general-purpose register file.
- Arithmetic and Logical Unit (ALU).
- Instruction decoder and control unit.
- Immediate generation and sign-extension units.
- Data forwarding unit for handling register dependencies.
- Branch and jump decision logic.
- Pipeline registers between consecutive stages.
- Testbench-based functional simulation.

## Project Modules

| Module | Description |
|---|---|
| `top_mod` | Top-level processor integrating all five stages. |
| `if_stage` | Instruction fetching and program counter management. |
| `id_stage` | Instruction decoding, register access and control signal generation. |
| `ex_stage` | ALU operations, operand selection and branch/jump execution. |
| `ALU` | Arithmetic and logical operations. |
| `control` | Generates instruction-specific control signals. |
| `decoder` | Extracts register addresses and immediate fields. |
| `gpr` | 32-register general-purpose register file. |
| `inst_mem` | Stores and provides processor instructions. |
| `data_memory` | Handles load and store operations. |
| `forwarding_unit` | Generates forwarding control signals. |
| `load_mux` | Selects the appropriate write-back data. |
| `program_counter` | Maintains the current instruction address. |
| `pc_plus4` | Calculates the next sequential instruction address. |
| `pc_mux` | Selects the next program counter source. |
| `alu_operand_mux` | Selects register or immediate ALU operands. |
| `sign_ext_alu` | Sign extension for I-type and S-type immediates. |
| `sign_ext_branch` | Sign extension for branch immediates. |
| `sign_ext_jal` | Sign extension for JAL immediates. |

## Pipeline Registers

The processor uses four pipeline register boundaries:

- **IF/ID:** Stores the fetched instruction and its PC.
- **ID/EX:** Stores decoded operands, immediate values and control signals.
- **EX/MEM:** Stores ALU results, destination register information and memory control signals.
- **MEM/WB:** Stores write-back data, destination register and register-write control.

## Hazard Handling

The design incorporates a forwarding unit to resolve common read-after-write (RAW) data dependencies.

Forwarding paths:
- EX/MEM to EX stage.
- MEM/WB to EX stage.

Branch and jump control logic updates the PC and flushes younger pipeline instructions when a control transfer is taken.

**Note:** Load-use hazard stall logic is not currently implemented as a complete mechanism in this version.

## Simulation and Verification

The project includes a Verilog testbench to verify processor operation.

The instruction memory contains test instructions covering arithmetic, logical, load/store, branch and jump operations.

The testbench generates the clock, applies reset and runs the processor for multiple clock cycles.

Waveform generation is configured using shm commands for viewing signals in Cadence SimVision.

## Technologies Used

- Verilog HDL
- RISC-V RV32I ISA
- RTL Design
- Digital System Design
- Computer Architecture
- Cadence Xcelium / SimVision (simulation environment)

## Applications

- RISC-V processor architecture research.
- Computer architecture and pipeline design.
- RTL design and functional verification.
- Learning instruction execution and pipeline control.
- Foundation for developing advanced RISC-V processors.

## Future Improvements

- Implement load-use hazard detection and pipeline stalls.
- Improve branch prediction and control hazard handling.
- Extend support for additional RISC-V instructions.
- Integrate a more comprehensive verification environment.
- Perform synthesis, timing analysis and FPGA implementation.

## Author

**Vidyashree P**

B.E. Electronics and Communication Engineering

Vidyavardhaka College of Engineering, Mysuru

---

*This project demonstrates the design and implementation of a pipelined RISC-V processor with modular RTL architecture and instruction-level execution support.*
