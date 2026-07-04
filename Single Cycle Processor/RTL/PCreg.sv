`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////



module PCreg(
    input clk,
    input rst,
    input [31:0]PCin,
    output logic [31:0]PCout
    );
    
    always@(posedge clk or posedge rst)begin
        if(rst)
            PCout<= 0;
        else 
            PCout <= PCin;
    
    end
    
endmodule
