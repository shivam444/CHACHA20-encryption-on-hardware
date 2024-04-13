`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.04.2024 23:52:02
// Design Name: 
// Module Name: chacha20_quater
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


module chacha20_quarter#(parameter N = 32)(
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    input wire [N-1:0] c,
    input wire [N-1:0] d,
    output wire [N-1:0] a_out,
    output wire [N-1:0] b_out,
    output wire [N-1:0] c_out,
    output wire [N-1:0] d_out
);

// quarter round function definition, directly use this
function [N-1:0] rotate_left;
    input [N-1:0] value;
    input integer amount;
    begin
        rotate_left = (value << amount) | (value >> (32 - amount));
    end
endfunction

wire [N-1:0] a1, b1, c1, d1;
wire [N-1:0] a2, b2, c2, d2;

//basic functions noted below for chachaquarter:
// a += b; d ^= a; d <<<= 16;
// c += d; b ^= c; b <<<= 12;
// a += b; d ^= a; d <<<= 8;
// c += d; b ^= c; b <<<= 7;

assign a1 = a + b;
assign d1 = rotate_left(d ^ a1, 16);


assign c1 = c + d1;
assign b1 = rotate_left(b ^ c1, 12);


assign a2 = a1 + b1;
assign d2 = rotate_left(d1 ^ a2, 8);


assign c2 = c1 + d2;
assign b2 = rotate_left(b1 ^ c2, 7);

// outputs 
assign a_out = a2;
assign b_out = b2;
assign c_out = c2;
assign d_out = d2;

endmodule