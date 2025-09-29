# Shifter Module

## Overview

The **Shifter** module provides configurable shift and rotate operations as defined by the SH1-ISA. It supports logical and arithmetic shifts, as well as left and right rotations. This module is essential for implementing various bit manipulation instructions in the CPU.

## Supported Instructions

| Mnemonic | Opcode                | Description                                      |
|----------|----------------------|--------------------------------------------------|
| ROTL     | 0100 nnnn 0000 0100  | MSB of Rn → T, Rn << 1 \| T → Rn                |
| ROTR     | 0100 nnnn 0000 0101  | LSB of Rn → T, Rn >> 1 \| T << 31 → Rn          |
| ROTCL    | 0100 nnnn 0010 0100  | T → MSB of Rn, Rn << 1 \| T → Rn                |
| ROTCR    | 0100 nnnn 0010 0101  | T → LSB of Rn, Rn >> 1 \| T << 31 → Rn          |
| SHAL     | 0100 nnnn 0010 0000  | MSB of Rn → T, Rn << 1 → Rn                     |
| SHAR     | 0100 nnnn 0010 0001  | MSB of Rn → T, Rn >> 1 (arithmetic) → Rn        |
| SHLL     | 0100 nnnn 0000 0000  | MSB of Rn → T, Rn << 1 → Rn (errata?)           |
| SHLR     | 0100 nnnn 0000 0001  | LSB of Rn → T, Rn >> 1 → Rn                     |
| SHLL2    | 0100 nnnn 0000 1000  | Rn << 2 → Rn                                    |
| SHLR2    | 0100 nnnn 0000 1001  | Rn >> 2 → Rn                                    |
| SHLL8    | 0100 nnnn 0001 1000  | Rn << 8 → Rn                                    |
| SHLR8    | 0100 nnnn 0001 1001  | Rn >> 8 → Rn                                    |
| SHLL16   | 0100 nnnn 0010 1000  | Rn << 16 → Rn                                   |
| SHLR16   | 0100 nnnn 0010 1001  | Rn >> 16 → Rn                                   |

## Instruction Format

```
0100 nnnn 00 ab ?r?d
```
- **Direction (D):** 0 = left, 1 = right  
- **Rotation (R):** 0 = shift, 1 = rotate  
- **ab (for SHL only):** 00 = 2, 01 = 8, 10 = 16, 11 = unused

Refer to the SH1-ISA documentation for further details on instructions.
