# VSCPU Processor 
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

## References

- VSCPU ISA Specification
- [cpu.tc](http://cpu.tc) - Reference simulator for verification
