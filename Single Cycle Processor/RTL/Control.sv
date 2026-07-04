`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/16/2026 04:33:36 PM
// Design Name: 
// Module Name: Control
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


module Control(
 input [6:0] opcode,
 output logic Regwrite,
 output logic ALUSrc,
 output logic MemRead,
 output logic MemWrite,
 output logic MemtoReg,
 output logic [1:0] ALU_op,
 output logic ResultSrc,
 output logic branch,
 output logic jump
    );
    
    parameter r_type = 7'b0110011;
    parameter s_type = 7'b0100011;
    parameter l_type = 7'b0000011;
    parameter b_type = 7'b1100011;
    parameter I_type = 7'b0010011;
    parameter J_type = 7'b1101111;
    
    always_comb begin
        case(opcode)
            r_type:begin
                Regwrite = 1'b1;
                ALUSrc   = 1'b0;
                MemRead  = 1'b0;
                MemWrite = 1'b0;
                MemtoReg = 1'b0;
                ALU_op   = 2'b10;
                ResultSrc = 1'b0;
                branch = 1'b0;
                jump = 1'b0;
            end
            l_type: begin
                Regwrite = 1'b1;
                ALUSrc   = 1'b1;
                MemRead  = 1'b1;
                MemWrite = 1'b0;
                MemtoReg = 1'b1;
                ALU_op   = 2'b00;
                ResultSrc = 1'b1; 
                branch = 1'b0;
                jump = 1'b0;
            end
            
            s_type:begin
                Regwrite = 1'b0;
                ALUSrc   = 1'b1;
                MemRead  = 1'b0;
                MemWrite = 1'b1;
                MemtoReg = 1'b0;
                ALU_op   = 2'b00;
                ResultSrc = 1'b0;
                branch = 1'b0;
                jump = 1'b0;
            end
            b_type:begin
                Regwrite = 1'b0;
                ALUSrc   = 1'b0;
                MemRead  = 1'b0;
                MemWrite = 1'b0;
                MemtoReg = 1'b0;
                ALU_op   = 2'b01;
                ResultSrc = 1'b0;
                branch = 1'b1;
                jump = 1'b0;
            end
            I_type:begin
                Regwrite = 1'b1;
                ALUSrc   = 1'b1;
                MemRead  = 1'b0;
                MemWrite = 1'b0;
                MemtoReg = 1'b1;
                ALU_op   = 2'b10;
                ResultSrc = 1'b0;
                branch = 1'b0;
                jump = 1'b0;
            end
            J_type: begin
                Regwrite = 1'b1;
                ALUSrc   = 1'b0;
                MemRead  = 1'b0;
                MemWrite = 1'b0;
                MemtoReg = 1'b0;
                ALU_op   = 2'b01;
                ResultSrc = 1'b0;
                branch = 1'b0;
                jump = 1'b1;
            end
            
        endcase 
   
    end
    
    
endmodule
