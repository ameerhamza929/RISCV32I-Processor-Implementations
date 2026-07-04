# Multi-Cycle Processor

This folder contains the RTL source and supporting data for the Multi-Cycle (RV32I) processor implementation (SystemVerilog).

Overview
--------
The design implements RV32I datapath building blocks and control logic for a multi-cycle processor. The RTL modules are provided in the `RTL/` directory. A small `Data/` directory contains example instruction data used by the instruction memory.

Repository layout
-----------------
- RTL/ — SystemVerilog modules and top-level files.
- Data/ — example instruction/data files (inst.txt) and small helper files.
- Readme.md — this file.

RTL contents
------------
The `RTL/` directory contains the following SystemVerilog files (brief description):

- ALU.sv
  - Arithmetic Logic Unit: performs add, sub, and, or, slt, shifts, etc. Used by the datapath for ALU operations.

- ALU_Control.sv
  - Generates ALU control signals (operation select) from ALUOp and funct fields.

- Control.sv
  - Main control unit: implements the multi-cycle control FSM (control signals per state).

- Decoder.sv
  - Instruction decoder: extracts opcode/fields and presents control inputs to other modules.

- Inst_mem.sv
  - Simple instruction memory module. Example instruction files in `Data/` can be loaded into this memory during simulation.

- Data_mem.sv
  - Data memory module (load/store support) used by the datapath.

- Register_File.sv
  - Register file implementation (32 x 32-bit registers) providing read/write ports.

- Register.sv
  - A generic register (used for pipeline/register stages or state elements).

- PC.sv, PCreg.sv, PCtargeradder.sv
  - Program Counter related modules: PC register, PC increment/adder logic and target address adder.

- Signextend.sv
  - Sign-/zero- extension unit for immediate fields.

- Mux2x1.sv, mux3x1.sv
  - Utility multiplexer modules used across the datapath.

- singlecycleprocessor.sv
  - A single-cycle processor implementation (included for reference/comparison). The multi-cycle control and datapath sources co-exist in the folder — inspect the top-level files to select the module you want to simulate.

- RTL/Readme.md
  - (Empty) per-subdirectory readme placeholder.

Data
----
- Data/inst.txt — example instruction memory content (text format) used by Inst_mem.sv during simulation.
- Data/delete.html — placeholder/helper file included in the folder.

How to simulate
---------------
These RTL files are SystemVerilog — recommended simulators:
- Questa/ModelSim (Mentor)
- VCS (Synopsys)
- Icarus Verilog + Verilator (partial SystemVerilog support; Verilator provides cycle-accurate simulation via C++)

Quick (generic) steps using a typical SystemVerilog simulator (replace <TOP_MODULE> with the top-level module name you want to simulate):

1. Inspect RTL/ to find the top-level module (for multi-cycle design the top module might be named `multi_cycle_processor` or similar).
2. Compile all SystemVerilog files:
   - Questa/ModelSim/QuestaSim: `vlog -sv RTL/*.sv`
   - VCS: `vcs -sverilog RTL/*.sv -o simv`
3. Run the simulator and load the top module:
   - Questa: `vsim work.<TOP_MODULE>` then `run -all`
   - VCS: `./simv`
4. If Inst_mem.sv expects an external file (e.g., `inst.txt`), ensure simulator runs from the repository root or provide the correct path to the file so the instruction memory can initialize.

Notes and tips
---------------
- Verify which top-level module to simulate by inspecting `RTL/*.sv` for `module <name>(...);` declarations.
- The folder contains a `singlecycleprocessor.sv` which is a single-cycle implementation kept for comparison — the control FSM in `Control.sv` targets a multi-cycle design.
- If you plan to synthesize parts of the design, review each module for synthesizability (e.g., avoid non-synthesizable $display/$finish constructs in the targeted modules).

Contributing
------------
Contributions, bug reports, and improvements are welcome. Please open an issue or submit a PR to the main repository.

License & Attribution
---------------------
This project is distributed under the same license as the repository root. See the repository-level LICENSE or README for licensing details.

Contact
-------
For questions, open an issue on the main repository or contact the repository owner.
