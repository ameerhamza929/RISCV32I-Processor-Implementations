# Pipeline Processor - RV32I RISC-V Implementation

## Overview

The Pipeline Processor is a 5-stage pipelined implementation of the RV32I RISC-V instruction set architecture. This implementation demonstrates advanced processor design concepts by executing multiple instructions in parallel through different pipeline stages, significantly improving throughput compared to single-cycle and multi-cycle designs.

## Pipeline Architecture

The processor implements a classic 5-stage pipeline with the following stages:

### 1. **IF (Instruction Fetch)**
   - Fetches instructions from the instruction memory
   - Manages the Program Counter (PC) with branch prediction support
   - Handles PC stalls for hazard mitigation

### 2. **ID (Instruction Decode)**
   - Decodes the instruction to extract opcode, function codes, and immediate values
   - Reads register operands from the register file
   - Generates control signals for subsequent stages
   - Implements sign extension for immediate values

### 3. **EX (Execute)**
   - Performs arithmetic and logical operations using the ALU
   - Computes branch target addresses
   - Implements data forwarding to resolve data hazards
   - Manages branch resolution

### 4. **MEM (Memory)**
   - Performs load and store operations to data memory
   - Handles memory read/write signals

### 5. **WB (Write-Back)**
   - Writes results back to the register file
   - Selects between ALU results, memory data, or PC+4 as write data

## Project Structure

```
Pipeline Processor/
├── RTL/                          # Register Transfer Level Implementation
│   ├── pipelineprocessor.sv      # Top-level pipeline processor module
│   ├── ALU.sv                    # Arithmetic Logic Unit
│   ├── ALU_Control.sv            # ALU control signal generator
│   ├── Control.sv                # Main control unit
│   ├── Decoder.sv                # Instruction decoder
│   ├── Register_File.sv          # 32-register file
│   ├── Inst_mem.sv               # Instruction memory
│   ├── Data_mem.sv               # Data memory
│   ├── Signextend.sv             # Sign extension logic
│   ├── Hazard_Unit.sv            # Hazard detection and forwarding unit
│   ├── PC.sv                     # Program counter increment logic
│   ├── PCreg.sv                  # Program counter register
│   ├── PCtargeladder.sv          # Branch target address calculator
│   ├── Mux2x1.sv                 # 2-to-1 multiplexer
│   ├── mux3x1.sv                 # 3-to-1 multiplexer
│   ├── IF_ID.sv                  # IF/ID Pipeline register
│   ├── ID_EX.sv                  # ID/EX Pipeline register
│   ├── EX_MEM.sv                 # EX/MEM Pipeline register
│   └── MEM_WB.sv                 # MEM/WB Pipeline register
│
├── Data/                         # Test Data and Simulation Files
│   └── inst.txt                  # Test instruction set for simulation
│
└── Readme.md                     # This file
```

## Key Components Description

### Core Modules

#### **pipelineprocessor.sv**
The top-level module that instantiates and connects all pipeline components. It manages:
- Pipeline stage interconnections
- Hazard detection and control flow
- Data forwarding multiplexer logic
- Branch resolution and PC management

#### **Hazard_Unit.sv**
Detects and resolves pipeline hazards:
- **Data Hazards**: Implements forwarding to reduce stalls
- **Control Hazards**: Flushes pipeline on branch/jump
- **Structural Hazards**: Implements stalling when necessary

#### **ALU_Control.sv**
Generates 3-bit ALU control signals based on:
- ALU operation type (ALU_op)
- Function select (func3, func7)
- Opcode field

#### **Control.sv**
Main control unit that decodes opcodes and generates:
- RegWrite, MemRead, MemWrite, ALUSrc, MemtoReg
- Branch and Jump signals
- ALU operation codes

#### **Decoder.sv**
Instruction format decoder that extracts:
- Opcode, rd, rs1, rs2
- Immediate values (12-bit, 13-bit branch, 21-bit jump)
- Function codes (func3, func7)

### Pipeline Registers

Each pipeline stage is separated by pipeline registers that latch intermediate results:
- **IF_ID**: Holds instruction and PC information
- **ID_EX**: Holds control signals and operands
- **EX_MEM**: Holds ALU results and memory control signals
- **MEM_WB**: Holds memory data and final results

### Multiplexers

- **Mux2x1**: 2-input multiplexer (parameterizable width)
- **mux3x1**: 3-input multiplexer for data forwarding and result selection

## Supported Instructions

The Pipeline Processor supports the following RV32I instruction categories:

### Arithmetic Instructions
- ADD, ADDI
- SUB
- AND, ANDI
- OR, ORI

### Load/Store Instructions
- LW (Load Word)
- SW (Store Word)

### Branch Instructions
- BEQ (Branch if Equal)

### Other
- JAL, JALR (if implemented)

## Test Program

The included `inst.txt` file contains a test program demonstrating various instruction types:

```
// Load word: lw x23 40(x21)
// Arithmetic: add x24 x20 x21
// Arithmetic: sub x18 x24 x19
// Logic: or x25 x31 x24
// Logic: and x23 x24 x7
// Store word: sw x30 40(x21)
// Branch: beq x0 x0 -32
// Immediate: addi x1 x1 1
```

## Hazard Handling

### Data Hazards
The processor implements **data forwarding (bypass)** to minimize stalls:
- Forwarding from EX/MEM stage (ALU results)
- Forwarding from MEM/WB stage (memory or ALU results)
- Stalling only when necessary (load-use hazard)

### Control Hazards
- Branch prediction: Assumes branch not taken (predict PC+4)
- Pipeline flush on branch resolution
- Jump instructions flush the pipeline

### Structural Hazards
- Memory stalling mechanism for conflicting operations
- Pipeline stage enable signals controlled by hazard unit

## Design Features

✅ **5-stage pipeline architecture** for improved throughput
✅ **Data forwarding (bypassing)** to minimize stalls
✅ **Hazard detection and control unit** for correct execution
✅ **Pipeline flushing** for branch and jump resolution
✅ **Stalling mechanism** for load-use hazards
✅ **Sign extension unit** for immediate value handling
✅ **Parameterizable multiplexers** for scalability

## Performance Characteristics

| Metric | Value |
|--------|-------|
| Pipeline Stages | 5 |
| Clock Cycles per Instruction (CPI) | ~1 (with forwarding) |
| Maximum Clock Frequency | Design dependent |
| Hazard Stall Penalty | 1-2 cycles (data), 3 cycles (branch) |

## Usage

### Simulation
The RTL modules can be simulated using standard Verilog simulators (ModelSim, VCS, Vivado Simulator, etc.):

```bash
# Example using ModelSim
vlog Pipeline\ Processor/RTL/*.sv
vsim pipelineprocessor
```

### Synthesis
The design can be synthesized for FPGA or ASIC implementation:
- Target: Xilinx (Vivado), Altera (Quartus), or ASIC flow
- Input format: SystemVerilog
- Top module: `pipelineprocessor`

## Interface Specification

### Top-Level Ports
```systemverilog
module pipelineprocessor(
    input clk,      // Clock signal
    input rst       // Asynchronous reset
);
```

### Internal Memory Specifications
- **Instruction Memory**: 32-bit words, addressable by PC[31:2]
- **Data Memory**: 32-bit words, addressable by ALU result
- **Register File**: 32 registers × 32 bits each

## Future Enhancements

- [ ] Support for additional RV32I extensions (MULT, DIV, SHIFT)
- [ ] Advanced branch prediction mechanisms
- [ ] Cache system integration
- [ ] Exception and interrupt handling
- [ ] Performance counters and debugging support
- [ ] Superscalar execution

## Files Reference

| File | Purpose |
|------|---------|
| pipelineprocessor.sv | Top-level module and pipeline orchestration |
| Hazard_Unit.sv | Hazard detection, forwarding, and control |
| ALU.sv | 32-bit arithmetic and logical operations |
| ALU_Control.sv | ALU control signal generation |
| Control.sv | Instruction decoding to control signals |
| Decoder.sv | Immediate extraction and field parsing |
| Register_File.sv | 32 × 32-bit register storage and access |
| Inst_mem.sv | Instruction memory with hardcoded instructions |
| Data_mem.sv | Data memory for load/store operations |
| Signextend.sv | Sign extension for immediate values |
| PC.sv | PC increment by 4 |
| PCreg.sv | PC register with enable control |
| PCtargeladder.sv | Branch target address calculation |
| Mux2x1.sv | 2-input multiplexer |
| mux3x1.sv | 3-input multiplexer |
| IF_ID.sv, ID_EX.sv, EX_MEM.sv, MEM_WB.sv | Pipeline registers |

## Related Documentation

For more information about the processor architectures, see:
- **Single Cycle Processor**: Basic processor executing one instruction per cycle
- **Multi-Cycle Processor**: Processor executing instructions across multiple cycles
- **Repository Root**: General information about RV32I implementations

## Author Notes

This pipeline processor implementation demonstrates key concepts in computer architecture including instruction pipelining, hazard detection, data forwarding, and control flow management. It serves as an educational tool for understanding modern processor design principles.

---

**Language**: SystemVerilog  
**Design Type**: 5-Stage Pipeline Processor  
**ISA**: RV32I (RISC-V 32-bit Integer)  
**Last Updated**: 2026
