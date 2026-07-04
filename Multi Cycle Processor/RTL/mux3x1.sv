`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/18/2026 04:59:32 PM
// Design Name: 
// Module Name: mux3x1
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


module Mux3x1 #(
  parameter WIDTH = 32
)(
    input [WIDTH-1:0] A,
    input [WIDTH-1:0] B,
    input [WIDTH-1:0] C,
    input [1:0]sel,
    output logic [WIDTH-1:0] out
    );
    
    always_comb begin
        case(sel)
            2'b00: out = A;
            2'b01: out = B;
            2'b10: out = C;
            default out = 0;
        endcase
    end
    
endmodule
