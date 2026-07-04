`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/16/2026 04:57:20 PM
// Design Name: 
// Module Name: singlecycleprocessor
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module singlecycleprocessor(
    input clk,
    input rst
    );
    
    wire [31:0] PC;
    wire reg_write;
    wire [4:0]rs1;
    wire [4:0]rs2;
    wire [4:0]rd;
    wire [31:0]wr;
    wire [31:0]rdata1;
    wire [31:0]rdata2;
    wire [6:0] opcode;
    wire [6:0] func7;
    wire [2:0] func3;
   wire ALUSrc;  
   wire MemRead;
   wire MemWrite;
   wire MemtoReg; 
   wire [31:0]inst; 
   wire [11:0] imm; 
   wire [12:0] branch_imm; 
    wire branch;
    wire [2:0] ALU_op;
    wire jump;
    wire PCsrc;
    wire zero;
    wire [31:0]PCnext;
    wire [31:0] bPC;
    wire [20:0] jump_imm;
    wire jump;
    
    assign PCsrc =  jump|(branch & zero);
    
    
    wire [31:0] read_data_mem;
    wire [31:0] count;
    
    
   
   PCreg PCed(
       .clk(clk),
       .rst(rst),
       .PCin(PCnext),
       .PCout(PC)
    );
    
    
    
     PC add(
        .PCin(PC),
        .count(count)
        );
        
        
        
   PCtargeradder Adder(
       .A(PC),
       .B(signextended),
       .result(bPC)
    );
    
    
    Mux2x1 #(
        .WIDTH (32)
    ) mux3(
        .A(count),
        .B(bPC),
        .sel(PCsrc),
        .out (PCnext)
        );
        
    
    Inst_mem instmem(
       .PC(PC),
       .inst(inst)    
    );
    
    
    
    Decoder decode(
      .inst(inst),
      .opcode(opcode),
      .rd(rd),
      .rs1(rs1),
      .rs2(rs2),
      .func7(func7),
      .func3(func3),
      .imm(imm),
      .branch_imm(branch_imm),
      .jump_imm(jump_imm)
        );
    
    Control controller(
        .opcode(opcode),
        .Regwrite(reg_write),
        .ALUSrc(ALUSrc),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .MemtoReg(MemtoReg),
        .ALU_op(ALU_op),
        .ResultSrc(ResultSrc),
        .branch(branch),
        .jump(jump)
     );
    
    Register_File Regfile (
        .clk(clk),
        .rst(rst),
        .reg_write(reg_write),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .wr(wr),
        .rdata1(rdata1),
        .rdata2(rdata2)
    );
    
   wire [31:0] srcA;
   wire [31:0] signextended;
   
   assign srcA = rdata1;
   
   wire [31:0] srcB;
   wire [2:0] ALU_Ctrl;
   wire [31:0] ALU_result;
   
  Signextend extend(
     .imm(imm),
     .branch_imm(branch_imm),
     .jump_imm(jump_imm),
     .branch(branch),
     .jump(jump),
     .signextended(signextended)
    );
   
   
   
 Mux2x1 #(
  .WIDTH (32)
    ) mux1(
        .A(rdata2),
        .B(signextended),
        .sel(ALUSrc),
        .out (srcB)
        );
       
   
  
  
  ALU alu(
     .srcA(srcA),
     .srcB(srcB),
     .ALU_Ctrl(ALU_Ctrl),
     .ALU_result(ALU_result),
     .zero(zero)
    );
    
    
  ALU_Control Ctrl (
    .ALU_op(ALU_op),
    .op5(opcode[5]),
    .func3(func3),
    .func7(func7),
    .ALU_Ctrl(ALU_Ctrl)
    );
    
 Data_mem Datamemory(
    .clk(clk),
   .rst(rst),
   .mem_read(MemRead),
   .mem_write(MemWrite),
   .addr(ALU_result),
   .write_data(rdata2),
   .read_data (read_data_mem)  
    );
    
    
    Mux2x1 #(
        .WIDTH (32)
    ) mux2(
        .A(ALU_result),
        .B(read_data_mem),
        .sel(ResultSrc),
        .out (wr)
        );
    
    
endmodule
