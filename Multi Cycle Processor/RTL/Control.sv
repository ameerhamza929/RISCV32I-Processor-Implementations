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
 input clk,
 input rst,
 input [6:0] opcode,
 input zero,
 output logic Regwrite,
// output logic ALUSrc,
// output logic MemRead,
 output logic MemWrite,
// output logic MemtoReg,
 output logic [1:0] ALU_op,
 output logic [1:0] ResultSrc,
 output logic branch,
 output logic jump,
 output logic PCWrite,
 output logic IRwrite,
 output logic AddSrc,
 output logic [1:0] ALUSrcA,
 output logic [1:0] ALUSrcB,
 output logic [1:0]ImmSrc,
 output logic PCsrc
    );
    
    parameter r_type = 7'b0110011;
    parameter s_type = 7'b0100011;
    parameter l_type = 7'b0000011;
    parameter b_type = 7'b1100011;
    parameter I_type = 7'b0010011;
    parameter J_type = 7'b1101111;
    
    parameter numberofstates = 10;
    
    localparam S0 = 0,
                S1 = 1,
                S2 = 2,
                S3 = 3,
                S4 = 4,
                S5 = 5,
                S6 = 6,
                S7 = 7,
                S8 = 8,
                S9 = 9,
                S10 = 10;
    
    logic [$clog2(numberofstates)-1:0] state , next_state;
    
    
    always_ff@(posedge clk or posedge rst)begin
        if(rst)begin
            state <= S0;
        end     
        else begin
            state <= next_state;
        end
    
    end
    
    
    always@(*)begin
      AddSrc = 1'b0;
      IRwrite = 1'b0;
      PCWrite = 1'b0;
      ALUSrcA = 2'b00;
      ALUSrcB = 2'b00;
      ALU_op = 2'b00;
      ResultSrc = 2'b01;
      branch = 1'b0;
      jump = 1'b0;
      MemWrite = 1'b0;
      Regwrite = 1'b0;
        
        case(state)
            S0: begin                // Fetch 
                AddSrc = 0;
                IRwrite = 1'b1;
                PCWrite = 1'b1;
                ALUSrcA = 2'b00;
                ALUSrcB = 2'b10;
                ALU_op = 2'b00;
                ResultSrc = 2'b10;
                branch = 1'b0;
                jump = 1'b0;
                MemWrite = 1'b0;
                Regwrite = 1'b0;
                PCsrc    = 1'b0;
                next_state = S1;
            end
            S1: begin           //Decode
                AddSrc = 0;
                IRwrite = 1'b0;
                PCWrite = 1'b0;
                ALUSrcA = 2'b01;
                ALUSrcB = 2'b01;
                ALU_op = 2'b00;
                ResultSrc = 2'b00;
                branch = (opcode == b_type) ? 1'b1:1'b0;
                jump = (opcode == J_type) ? 1'b1:1'b0;
                PCsrc    = 1'b0;
                next_state = (opcode == l_type ||opcode == s_type)? S2 :(opcode == r_type) ? S6: (opcode == I_type) ? S8 : (opcode == J_type) ? S9:(opcode == b_type) ? S10 :S0 ;    
            end
            S2: begin                   // lw or sw memadr
                AddSrc = 0;
                IRwrite = 1'b0;
                PCWrite = 1'b0;
                ALUSrcA = 2'b10;
                ALUSrcB = 2'b01;
                ALU_op = 2'b00;
                ResultSrc = 2'b00;
                branch = 1'b0;
                jump = 1'b0;
                PCsrc    = 1'b0;
                next_state = (opcode == l_type)? S3:S5; 
            end
            S6: begin                  //R type Execute R
                AddSrc = 0;
                IRwrite = 1'b0;
                PCWrite = 1'b0;
                ALUSrcA = 2'b10;
                ALUSrcB = 2'b00;
                ALU_op = 2'b10;
                ResultSrc = 2'b00;
                branch = 1'b0;
                jump = 1'b0;
                PCsrc    = 1'b0;
                next_state = S7; 
            end
            
            S8: begin            // I type Execute
                AddSrc = 0;
                IRwrite = 1'b0;
                PCWrite = 1'b0;
                ALUSrcA = 2'b10;
                ALUSrcB = 2'b01;
                ALU_op = 2'b10;
                ResultSrc = 2'b00;
                branch = 1'b0;
                jump = 1'b0;
                PCsrc    = 1'b0;
                next_state = S7; 
            end
            S9: begin                 // jal step 3 
                AddSrc = 0;
                IRwrite = 1'b0;
                PCWrite = 1'b1;
                ALUSrcA = 2'b01;
                ALUSrcB = 2'b10;
                ALU_op = 2'b00;
                ResultSrc = 2'b00;
                branch = 1'b0;
                jump = 1'b0;
//                PCsrc    = 1'b1;
                next_state = S7; 
            end
            S10: begin            //beq step 3
                AddSrc = 0;
                IRwrite = 1'b0;
//                PCWrite = 1'b0;
                ALUSrcA = 2'b10;
                ALUSrcB = 2'b00;
                ALU_op = 2'b01;
                ResultSrc = 2'b00;
                branch = 1'b0;
                jump = 1'b0;
                PCWrite = (zero) ? 1'b1:1'b0;
//                PCsrc    = (zero) ? 1'b1:1'b0;
                next_state = S0; 
            end
            
            S3: begin                 //Memread
                AddSrc = 1'b1;
                IRwrite = 1'b0;
                PCWrite = 1'b0;
                ALUSrcA = 2'b00;
                ALUSrcB = 2'b00;
                ALU_op = 2'b00;
                ResultSrc = 2'b00;
                branch = 1'b0;
                jump = 1'b0;
                MemWrite = 1'b0;
                PCsrc    = 1'b1;
                next_state = S4; 
            end
            
            S5: begin            //Memwrite
                AddSrc = 1'b1;
                IRwrite = 1'b0;
                PCWrite = 1'b0;
                ALUSrcA = 2'b00;
                ALUSrcB = 2'b00;
                ALU_op = 2'b00;
                ResultSrc = 2'b00;
                branch = 1'b0;
                jump = 1'b0;
                MemWrite = 1'b1;
                PCsrc    = 1'b1;
                next_state = S0; 
            end
            
            S7: begin                 //ALU result write back
                AddSrc = 1'b0;
                IRwrite = 1'b0;
                PCWrite = 1'b0;
                ALUSrcA = 2'b00;
                ALUSrcB = 2'b00;
                ALU_op = 2'b00;
                ResultSrc = 2'b00;
                branch = 1'b0;
                jump = 1'b0;
                MemWrite = 1'b0;
                Regwrite = 1'b1;
                PCsrc    = 1'b0;
                next_state = S0; 
            end
            
            S4: begin               //LW mem write back
                AddSrc = 1'b0;
                IRwrite = 1'b0;
                PCWrite = 1'b0;
                ALUSrcA = 2'b00;
                ALUSrcB = 2'b00;
                ALU_op = 2'b00;
                ResultSrc = 2'b01;
                branch = 1'b0;
                jump = 1'b0;
                MemWrite = 1'b0;
                Regwrite = 1'b1;
                PCsrc    = 1'b0;
                next_state = S0; 
            end
            
        
        endcase
    
    end
    
    
    
    
    
endmodule
