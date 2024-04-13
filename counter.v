`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.03.2024 16:45:32
// Design Name: 
// Module Name: counter
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


module counter#(parameter N=32)(input clk, input rst,
                                output [N-1:0] count);
  reg [N-1:0] present_count;
  reg [N-1:0] next_count;
  
  always@*begin
    next_count = present_count+1'b1;
  end
  
  always@(posedge clk or negedge rst)begin
    if(~rst)begin
      present_count <= 'b1;
    end
    else begin
      present_count <= next_count;
    end
  end
  
  assign count = present_count;
endmodule
