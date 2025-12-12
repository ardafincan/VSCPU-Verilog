# VSCPU Processor - Term Project

**Course:** CSE224: Introduction to Digital Systems
**Institution:** Yeditepe University
**Instructor:** Asst. Prof. Gizem Süngü Terci

## Overview

This project implements a fully functional **VSCPU (Very Simple CPU)** processor using Verilog HDL. The processor supports the complete VSCPU instruction set architecture (ISA) and includes two custom-designed instructions: SUB and SUBi.

## Features

- Complete implementation of the VSCPU ISA
- Support for arithmetic, logical, shift, comparison, copy, and branch operations
- Two extended custom instructions (SUB and SUBi)
- Synthesizable Verilog design
- Comprehensive testbench and verification suite

## Instruction Set Architecture

The VSCPU supports the following instruction categories:

#### Arithmetic Instructions
- `ADD`, `ADDi`, `MUL`, `MULi`

#### Logical Instructions
- `NAND`, `NANDi`

#### Shift Instructions
- `SRL`, `SRLi`

#### Comparison Instructions
- `LT`, `LTi`

#### Copy Instructions
- `CP`, `CPi`, `CPI`, `CPIi`

#### Branch Instructions
- `BZJ`, `BZJi`

## Test Program

The processor will be tested with the following assembly program to verify correct execution of all instructions:

```assembly
0: CPi 110 3
1: ADD 100 101
2: MUL 100 102
3: SRLi 102 1
4: CP 104 100
5: ADDi 104 5
6: NAND 104 108
7: NANDi 104 5
8: SRL 108 102
9: MULi 108 3
10: ADD 110 103
11: CP 112 110
12: LT 112 111
13: BZJ 111 112
14: BZJi 101 11
19: MULi 101 3
20: CP 105 102
21: LTi 105 2
22: BZJ 113 105
35: BZJi 111 53
54: CPIi 114 111
55: CPI 121 102
```

**Initial Memory Values:**
```
100: 5
101: 8
102: 16
103: 4294967295
108: 65543
111: 1
113: 35
114: 120
```

## Synthesis

The design will be synthesized using Vivado/Synopsys to obtain:
- LUT/ALM usage
- Flip-flop utilization
- Timing analysis
- Area utilization

## Documentation

The project will include comprehensive documentation covering:

1. **Datapath and Control Signals** - Detailed explanation of the processor architecture
2. **Simulation and Verification** - Waveform analysis for all instruction types
3. **Implementation Details** - Technical description of all instruction implementations
4. **Synthesis Results** - Performance metrics and analysis
5. **High-Level Equivalent** - C program corresponding to the test assembly code

## New Instructions: SUB and SUBi

### SUB Instruction
**Opcode:** `3'b000`, `im = 1'b0`, `IW[13] = 1'b1`

**Microoperations:**
```
R1 <- mem[IW[27:14]]
R2 <- mem[IW[13:0]]
R2 <- ~R2
mem[IW[27:14]] <- (R1 - R2)
PC <- PC + 1
```

### SUBi Instruction
**Opcode:** `3'b000`, `im = 1'b1`, `IW[13] = 1'b1`

**Microoperations:**
```
R1 <- mem[IW[27:14]]
R2 <- IW[13:0]
R2 <- ~R2
mem[IW[27:14]] <- (R1 - R2)
PC <- PC + 1
```

## Project Structure

This repository contains:

1. **Verilog Design Files** - Complete VSCPU processor implementation
2. **Testbench Code** - Comprehensive verification suite
3. **Documentation** - Project report and technical documentation
4. **Synthesis Results** - Performance analysis and metrics

## Technical Details

- All Verilog implementations will follow the microoperation descriptions as specified in the VSCPU ISA
- Instruction execution will be verified against cpu.tc reference simulator
- Waveform analysis will demonstrate correct memory operations for all instruction types

## References

- VSCPU ISA Specification
- [cpu.tc](http://cpu.tc) - Reference simulator for verification
