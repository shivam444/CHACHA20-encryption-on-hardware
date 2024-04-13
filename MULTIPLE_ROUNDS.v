`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.03.2024 21:20:27
// Design Name: 
// Module Name: MULTIPLE_ROUNDS
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


module multiple_rounds#(parameter N = 32, parameter M= 20)(
  input clk, input rst,
  input wire [N-1:0] a,
  input wire [N-1:0] b,
  input wire [N-1:0] c,
  input wire [N-1:0] d,
  output wire [N-1:0] a_out,
  output wire [N-1:0] b_out,
  output wire [N-1:0] c_out,
  output wire [N-1:0] d_out,
  output reg ready);
  
  reg [N-1:0] a_hold_0;
  reg [N-1:0] b_hold_0;
  reg [N-1:0] c_hold_0;
  reg [N-1:0] d_hold_0;
  wire [N-1:0] a_next_0;
  wire [N-1:0] b_next_0;
  wire [N-1:0] c_next_0;
  wire [N-1:0] d_next_0;
  reg [N-1:0] a_hold_1;
  reg [N-1:0] b_hold_1;
  reg [N-1:0] c_hold_1;
  reg [N-1:0] d_hold_1;
  wire [N-1:0] a_next_1;
  wire [N-1:0] b_next_1;
  wire [N-1:0] c_next_1;
  wire [N-1:0] d_next_1;
  reg [N-1:0] a_hold_2;
  reg [N-1:0] b_hold_2;
  reg [N-1:0] c_hold_2;
  reg [N-1:0] d_hold_2;
  wire [N-1:0] a_next_2;
  wire [N-1:0] b_next_2;
  wire [N-1:0] c_next_2;
  wire [N-1:0] d_next_2;
  reg [N-1:0] a_hold_3;
  reg [N-1:0] b_hold_3;
  reg [N-1:0] c_hold_3;
  reg [N-1:0] d_hold_3;
  wire [N-1:0] a_next_3;
  wire [N-1:0] b_next_3;
  wire [N-1:0] c_next_3;
  wire [N-1:0] d_next_3;
  reg [N-1:0] a_hold_4;
  reg [N-1:0] b_hold_4;
  reg [N-1:0] c_hold_4;
  reg [N-1:0] d_hold_4;
  wire [N-1:0] a_next_4;
  wire [N-1:0] b_next_4;
  wire [N-1:0] c_next_4;
  wire [N-1:0] d_next_4;
  reg [N-1:0] a_hold_5;
  reg [N-1:0] b_hold_5;
  reg [N-1:0] c_hold_5;
  reg [N-1:0] d_hold_5;
  wire [N-1:0] a_next_5;
  wire [N-1:0] b_next_5;
  wire [N-1:0] c_next_5;
  wire [N-1:0] d_next_5;
  reg [N-1:0] a_hold_6;
  reg [N-1:0] b_hold_6;
  reg [N-1:0] c_hold_6;
  reg [N-1:0] d_hold_6;
  wire [N-1:0] a_next_6;
  wire [N-1:0] b_next_6;
  wire [N-1:0] c_next_6;
  wire [N-1:0] d_next_6;
  reg [N-1:0] a_hold_7;
  reg [N-1:0] b_hold_7;
  reg [N-1:0] c_hold_7;
  reg [N-1:0] d_hold_7;
  wire [N-1:0] a_next_7;
  wire [N-1:0] b_next_7;
  wire [N-1:0] c_next_7;
  wire [N-1:0] d_next_7;
  reg [N-1:0] a_hold_8;
  reg [N-1:0] b_hold_8;
  reg [N-1:0] c_hold_8;
  reg [N-1:0] d_hold_8;
  wire [N-1:0] a_next_8;
  wire [N-1:0] b_next_8;
  wire [N-1:0] c_next_8;
  wire [N-1:0] d_next_8;
  reg [N-1:0] a_hold_9;
  reg [N-1:0] b_hold_9;
  reg [N-1:0] c_hold_9;
  reg [N-1:0] d_hold_9;
  wire [N-1:0] a_next_9;
  wire [N-1:0] b_next_9;
  wire [N-1:0] c_next_9;
  wire [N-1:0] d_next_9;
  reg [N-1:0] a_hold_10;
  reg [N-1:0] b_hold_10;
  reg [N-1:0] c_hold_10;
  reg [N-1:0] d_hold_10;
  
  reg [4:0] count;
  reg [4:0] count_next;
  
  chacha20_quarter rounds_dut0(.a(a_hold_0),.b(b_hold_0),
                              .c(c_hold_0),.d(d_hold_0),
                              .a_out(a_next_0),.b_out(b_next_0),
                              .c_out(c_next_0),.d_out(d_next_0));
  chacha20_quarter rounds_dut1(.a(a_hold_1),.b(b_hold_1),
                              .c(c_hold_1),.d(d_hold_1),
                              .a_out(a_next_1),.b_out(b_next_1),
                              .c_out(c_next_1),.d_out(d_next_1));
  chacha20_quarter rounds_dut2(.a(a_hold_2),.b(b_hold_2),
                              .c(c_hold_2),.d(d_hold_2),
                              .a_out(a_next_2),.b_out(b_next_2),
                              .c_out(c_next_2),.d_out(d_next_2));
  chacha20_quarter rounds_dut3(.a(a_hold_3),.b(b_hold_3),
                              .c(c_hold_3),.d(d_hold_3),
                              .a_out(a_next_3),.b_out(b_next_3),
                              .c_out(c_next_3),.d_out(d_next_3));
  chacha20_quarter rounds_dut4(.a(a_hold_4),.b(b_hold_4),
                              .c(c_hold_4),.d(d_hold_4),
                              .a_out(a_next_4),.b_out(b_next_4),
                              .c_out(c_next_4),.d_out(d_next_4));
  chacha20_quarter rounds_dut5(.a(a_hold_5),.b(b_hold_5),
                              .c(c_hold_5),.d(d_hold_5),
                              .a_out(a_next_5),.b_out(b_next_5),
                              .c_out(c_next_5),.d_out(d_next_5)); 
  chacha20_quarter rounds_dut6(.a(a_hold_6),.b(b_hold_6),
                              .c(c_hold_6),.d(d_hold_6),
                              .a_out(a_next_6),.b_out(b_next_6),
                              .c_out(c_next_6),.d_out(d_next_6));   
  chacha20_quarter rounds_dut7(.a(a_hold_7),.b(b_hold_7),
                              .c(c_hold_7),.d(d_hold_7),
                              .a_out(a_next_7),.b_out(b_next_7),
                              .c_out(c_next_7),.d_out(d_next_7)); 
  chacha20_quarter rounds_dut8(.a(a_hold_8),.b(b_hold_8),
                              .c(c_hold_8),.d(d_hold_8),
                              .a_out(a_next_8),.b_out(b_next_8),
                              .c_out(c_next_8),.d_out(d_next_8));
  chacha20_quarter rounds_dut9(.a(a_hold_9),.b(b_hold_9),
                              .c(c_hold_9),.d(d_hold_9),
                              .a_out(a_next_9),.b_out(b_next_9),
                              .c_out(c_next_9),.d_out(d_next_9));                                                     
  always@(posedge clk or negedge rst)begin
    if(~rst)begin
      a_hold_0 <= 'b0;
      b_hold_0 <= 'b0;
      c_hold_0 <= 'b0;
      d_hold_0 <= 'b0;
    end
    else begin
      a_hold_0 <= a;
      b_hold_0 <= b;
      c_hold_0 <= c;
      d_hold_0 <= d;
    end
  end
  
  always@(posedge clk or negedge rst)begin
    if(~rst)begin
      a_hold_1 <= 'b0;
      b_hold_1 <= 'b0;
      c_hold_1 <= 'b0;
      d_hold_1 <= 'b0;
    end
    else begin
      a_hold_1 <= a_next_0;
      b_hold_1 <= b_next_0;
      c_hold_1 <= c_next_0;
      d_hold_1 <= d_next_0;
    end
  end
  always@(posedge clk or negedge rst)begin
    if(~rst)begin
      a_hold_2 <= 'b0;
      b_hold_2 <= 'b0;
      c_hold_2 <= 'b0;
      d_hold_2 <= 'b0;
    end
    else begin
      a_hold_2 <= a_next_1;
      b_hold_2 <= b_next_1;
      c_hold_2 <= c_next_1;
      d_hold_2 <= d_next_1;
    end
  end
  always@(posedge clk or negedge rst)begin
    if(~rst)begin
      a_hold_3 <= 'b0;
      b_hold_3 <= 'b0;
      c_hold_3 <= 'b0;
      d_hold_3 <= 'b0;
    end
    else begin
      a_hold_3 <= a_next_2;
      b_hold_3 <= b_next_2;
      c_hold_3 <= c_next_2;
      d_hold_3 <= d_next_2;
    end
  end
  always@(posedge clk or negedge rst)begin
    if(~rst)begin
      a_hold_4 <= 'b0;
      b_hold_4 <= 'b0;
      c_hold_4 <= 'b0;
      d_hold_4 <= 'b0;
    end
    else begin
      a_hold_4 <= a_next_3;
      b_hold_4 <= b_next_3;
      c_hold_4 <= c_next_3;
      d_hold_4 <= d_next_3;
    end
  end
  always@(posedge clk or negedge rst)begin
    if(~rst)begin
      a_hold_5 <= 'b0;
      b_hold_5 <= 'b0;
      c_hold_5 <= 'b0;
      d_hold_5 <= 'b0;
    end
    else begin
      a_hold_5 <= a_next_4;
      b_hold_5 <= b_next_4;
      c_hold_5 <= c_next_4;
      d_hold_5 <= d_next_4;
    end
  end 
  always@(posedge clk or negedge rst)begin
    if(~rst)begin
      a_hold_6 <= 'b0;
      b_hold_6 <= 'b0;
      c_hold_6 <= 'b0;
      d_hold_6 <= 'b0;
    end
    else begin
      a_hold_6 <= a_next_5;
      b_hold_6 <= b_next_5;
      c_hold_6 <= c_next_5;
      d_hold_6 <= d_next_5;
    end
  end 
  always@(posedge clk or negedge rst)begin
    if(~rst)begin
      a_hold_7 <= 'b0;
      b_hold_7 <= 'b0;
      c_hold_7 <= 'b0;
      d_hold_7 <= 'b0;
    end
    else begin
      a_hold_7 <= a_next_6;
      b_hold_7 <= b_next_6;
      c_hold_7 <= c_next_6;
      d_hold_7 <= d_next_6;
    end
  end 
  always@(posedge clk or negedge rst)begin
    if(~rst)begin
      a_hold_8 <= 'b0;
      b_hold_8 <= 'b0;
      c_hold_8 <= 'b0;
      d_hold_8 <= 'b0;
    end
    else begin
      a_hold_8 <= a_next_7;
      b_hold_8 <= b_next_7;
      c_hold_8 <= c_next_7;
      d_hold_8 <= d_next_7;
    end
  end
  always@(posedge clk or negedge rst)begin
    if(~rst)begin
      a_hold_9 <= 'b0;
      b_hold_9 <= 'b0;
      c_hold_9 <= 'b0;
      d_hold_9 <= 'b0;
    end
    else begin
      a_hold_9 <= a_next_8;
      b_hold_9 <= b_next_8;
      c_hold_9 <= c_next_8;
      d_hold_9 <= d_next_8;
    end
  end
  always@(posedge clk or negedge rst)begin
    if(~rst)begin
      a_hold_10 <= 'b0;
      b_hold_10 <= 'b0;
      c_hold_10 <= 'b0;
      d_hold_10 <= 'b0;
      ready <= 'b0;
    end
    else begin
      a_hold_10 <= a_next_9;
      b_hold_10 <= b_next_9;
      c_hold_10 <= c_next_9;
      d_hold_10 <= d_next_9;
      ready <= 1'b1;
    end
  end
  assign a_out = a_hold_10;
  assign b_out = b_hold_10;
  assign c_out = c_hold_10;
  assign d_out = d_hold_10;
  
endmodule
