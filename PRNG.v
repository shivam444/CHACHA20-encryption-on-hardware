`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.03.2024 22:17:46
// Design Name: 
// Module Name: PRNG
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


module PRNG#(parameter N=32)(input clk, input rst, input start,input new_key,
                             input [N-1:0] count_load,
                             input random_seed1, input random_seed2,
                             output [N-1:0] key,output reg ready);
  reg [N-1:0] present_count;
  reg [N-1:0] next_count;
  wire [N-1:0] internal_lfsr_out;
  wire in;
  
  lfsr #(.N(N)) int_lfsr(.clk(clk),.rst(rst),.start(start),
                .random_seed(random_seed2),
                .out(internal_lfsr_out));

  assign in = internal_lfsr_out[1]^internal_lfsr_out[0];

  always@*begin
    next_count = present_count>>1;
    next_count[N-1] = (present_count[0]^in);
    next_count[1] = random_seed1;
  end
  always@(posedge clk or negedge rst)begin
    if(~rst) begin
      present_count <= 'b0;
      ready <= 1'b0;
    end
    else if(start)begin
      present_count <= count_load;
      ready <= 1'b1;
    end
    else if(new_key)begin
      present_count <= next_count;
    end
  end
  
  assign key = present_count;
endmodule
