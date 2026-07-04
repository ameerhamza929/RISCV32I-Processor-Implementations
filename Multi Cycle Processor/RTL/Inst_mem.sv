`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/16/2026 02:34:54 PM
// Design Name: 
// Module Name: Inst_mem
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


module Instdatamem(
    input clk,
    input rst,
    input WE,
    input [31:0] addr,
    input [31:0]data,
    output [31:0] inst    
    );
    
    logic [7:0]inst_reg[0:1023];       //Byte addressable
    
    initial begin
        $readmemh("/home/pc-48/Ameer Processor Design Day 1/Ameer Processor Design Day 1.srcs/inst.txt", inst_reg,50,78);  
    end
    
    integer i;
    
    always_ff@(posedge clk or posedge rst)begin
        if(rst)begin
            for(i=0; i<50; i++)begin
                inst_reg[i] <= 0;
            end
        end
        else begin
             if (WE) begin
                inst_reg[addr]   <= data[7:0];
                inst_reg[addr+1] <= data[15:8];
                inst_reg[addr+2] <= data[23:16];
                inst_reg[addr+3] <= data[31:24];
            end
        end
    
    end
    
    assign inst = {inst_reg[addr+3],inst_reg[addr+2],inst_reg[addr+1],inst_reg[addr]};
    
endmodule
