`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/18/2026 04:47:44 PM
// Design Name: 
// Module Name: Register
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


module Register #(
    parameter WIDTH = 32
)(  
    input clk,
    input rst,
    input [WIDTH-1:0] in,
    input en,
    output logic [WIDTH-1:0] out
    );
    
    always_ff@(posedge clk or posedge rst)begin
        if(rst)
            out <= 50;
         else begin
            if(en)
                out <= in;
         end
    
    end
    
    
endmodule
