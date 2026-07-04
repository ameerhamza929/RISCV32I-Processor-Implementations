`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/16/2026 04:18:57 PM
// Design Name: 
// Module Name: Data_mem
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


module Data_mem(
    input clk,
    input rst,
    input mem_read,
    input mem_write,
    input [31:0]addr,
    input [31:0] write_data,
    output logic [31:0]read_data    
    );
    
    logic [7:0] memory [0:1023];

    integer i;
    
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            read_data <= 32'd0;
            for (i=0; i<1023; i=i+1)
                memory[i] <= 8'd0;
        end
        else begin
            if (mem_write) begin
                memory[addr]   <= write_data[7:0];
                memory[addr+1] <= write_data[15:8];
                memory[addr+2] <= write_data[23:16];
                memory[addr+3] <= write_data[31:24];
            end
//            else if (mem_read)
//                read_data <= {memory[addr+3], memory[addr+2],
//                             memory[addr+1], memory[addr]}; 
        end
     end
     
     assign read_data = (mem_read) ? {memory[addr+3], memory[addr+2],memory[addr+1],memory[addr]}:32'd0; 
    
    
endmodule