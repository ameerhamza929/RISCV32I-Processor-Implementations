# Single-Cycle RV32I Processor (RTL)

This directory contains a SystemVerilog implementation of a single-cycle RV32I RISC-V processor. The design implements the classic single-cycle datapath where each instruction completes in one clock cycle. The code is organized into modular RTL components to make the datapath and control logic clear and easy to study.

## Highlights

- Implements the RV32I base instruction set (typical arithmetic/logic, immediate arithmetic, loads/stores, branches and jumps).
- Modular RTL: separate modules for ALU, ALU control, control unit, decoder, register file, instruction/data memories, PC and address adder, sign-extension, and multiplexers.
- Clear top-level single-cycle module (singlecycleprocessor.sv) that connects the datapath and control logic.

## Files (RTL)

- singlecycleprocessor.sv — Top-level single-cycle processor that instantiates the datapath and control modules.
- ALU.sv — Arithmetic and logic unit supporting the ALU operations required by RV32I.
- ALU_Control.sv — ALU control logic that derives ALU operations from opcode/funct fields and the main control signals.
- Control.sv — Main control unit that generates control signals for register write, ALU source selection, memory read/write, branching, jump, and register destination selection.
- Decoder.sv — Instruction decoder that extracts fields (opcode, rd, rs1, rs2, funct3, funct7) and routes signals.
- Register_File.sv — 32x32 register file with read/write ports and write-back support.
- Signextend.sv — Immediate extraction and sign-extension for I-type, S-type, B-type, U-type, and J-type immediates.
- Inst_mem.sv — Simple instruction memory (read-only) used to provide instructions to the processor.
- Data_mem.sv — Data memory module (read/write) used for loads and stores.
- PCreg.sv — Program counter register (holds the current PC and updates on clock).
- PCtargeradder.sv — Computes branch/jump target addresses (PC + immediate) or next PC logic.
- PC.sv — PC update and selection logic (selects between PC+4 and branch/jump target based on control signals).
- Mux2x1.sv — Generic 2:1 multiplexer used across the datapath.
- Signextend.sv — (listed above) handles sign-extension of immediates.

## Design notes

- Single-cycle architecture: every instruction completes in one clock cycle, so the cycle time must accommodate the slowest instruction (typically a memory access + ALU + register file operations).
- Control and ALU control are separated: the main control decodes opcode-level control signals while ALU_Control maps funct fields to concrete ALU operations.
- The Register_File and memories are synchronous with write-back gating implemented in the top-level module.

## How to simulate

1. Use a SystemVerilog-capable simulator (ModelSim/Questa, VCS, or similar).
2. Compile all RTL files in this directory, ensuring the top-level module is `singlecycleprocessor`.
3. Provide an instruction memory image (or edit `Inst_mem.sv`) with the program you want to run, then run the simulation to observe register file and memory behavior.

Example (generic, simulator-specific commands will vary):

- Compile the RTL files and run simulation using your chosen tool.

## Learning goals

- Study a minimal yet complete single-cycle RISC-V datapath and control implementation.
- Understand how instruction fields map to control signals and ALU operations.
- Use the design as a foundation for extending to multi-cycle or pipelined implementations.

If you'd like, I can also add a short testbench, example programs (instruction memory images), or a diagram/help comments to the RTL to make the design easier to run and understand."
