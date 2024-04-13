`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.03.2024 23:16:52
// Design Name: 
// Module Name: CHACHA_20
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


module CHACHA_20#(parameter N=128)(input clk, input rst, input start,
                                  input [4*N-1:0] plaintext,
                                   output reg [4*N-1:0] ciphertext,
                                  output reg ready);
  parameter M = 32;
  wire [4*N-1:0] ciphertext_key;
  reg [4*N-1:0] ciphertext_next;
  wire [4*N-1:0] decrypt;
  wire clk_20_Hz;
  reg freeze;
  wire [N-1:0] freeze_count;
  wire [M-1:0] counter;
  wire [3*M-1:0] nonce;
  wire nonce_ready;
  wire [8*M-1:0] key;
  wire key_ready;
  reg [M-1:0] a;
  reg [M-1:0] b;
  reg [M-1:0] c;
  reg [M-1:0] d;
  reg [M-1:0] e;
  reg [M-1:0] f;
  reg [M-1:0] g;
  reg [M-1:0] h;
  reg [M-1:0] i;
  reg [M-1:0] j;
  reg [M-1:0] k;
  reg [M-1:0] l;
  reg [M-1:0] m;
  reg [M-1:0] n;
  reg [M-1:0] o;
  reg [M-1:0] p;
  
  wire [N-1:0] cipher_1;
  wire [N-1:0] cipher_2;
  wire [N-1:0] cipher_3;
  wire [N-1:0] cipher_4;
  
  reg [N-1:0] cipher_1_hold;
  reg [N-1:0] cipher_2_hold;
  reg [N-1:0] cipher_3_hold;
  reg [N-1:0] cipher_4_hold;
  
  wire [N-1:0] cipher_1_next;
  wire [N-1:0] cipher_2_next;
  wire [N-1:0] cipher_3_next;
  wire [N-1:0] cipher_4_next;
  
  wire ready1;
  wire ready2;
  wire ready3;
  wire ready4;
  wire ready5;
  wire ready6;
  wire ready7;
  wire ready8;
  
  clk_20 clk_20Hz
   (
    // Clock out ports
    .clk_out1(clk_20_Hz),     // output clk_out1
   // Clock in ports
    .clk_in1(clk)      // input clk_in1
);

  custom_counter#(M) counter_dut(.clk(clk_20_Hz),.freeze(freeze),.rst(rst),.count(counter));
  
  random_number#(3*M) nonce_dut(.clk(clk_20_Hz),.rst(rst),
                                .key(nonce),.ready(nonce_ready));
  
  random_number#(8*M) key_dut(.clk(clk_20_Hz),.rst(rst),
                              .key(key),.ready(key_ready));
  
  counter#(N) freeze_counter_dut(.clk(clk_20_Hz),.rst(rst),.count(freeze_count));
  always@(posedge clk_20_Hz or negedge rst)begin
    if(~rst)begin
      freeze <= 'b0;
    end
    else if(freeze_count > 128'd400)begin
      freeze <= 1'b1;
    end
  end
  always@(posedge clk_20_Hz or negedge rst)begin
    if(~rst)begin
      a <= 'b0;
      b <= 'b0;
      c <= 'b0;
      d <= 'b0;
    end
    else if(nonce_ready)begin
      a <= nonce[3*M-1:(2*M)];      //96 bit nonce
      b <= nonce[(2*M)-1:M];
      c <= nonce[M-1:0];
      d <= counter[M-1:0];          //uptill here
    end
  end
  
  always@(posedge clk_20_Hz or negedge rst)begin
    if(~rst)begin
      e <= 'b0;
      f <= 'b0;
      g <= 'b0;
      h <= 'b0;
      i <= 'b0;
      j <= 'b0;
      k <= 'b0;
      l <= 'b0;
    end
    else if(key_ready)begin
      e <= key[8*M-1:7*M];      //256 bit key
      f <= key[(7*M)-1:6*M];
      g <= key[(6*M)-1:5*M];
      h <= key[(5*M)-1:4*M];
      i <= key[(4*M)-1:3*M];
      j <= key[(3*M)-1:2*M];
      k <= key[(2*M)-1:M];
      l <= key[(M)-1:0];        //uptill here
    end
  end
  
  always@(posedge clk_20_Hz or negedge rst)begin
    if(~rst)begin
      m <= 'b0;
      n <= 'b0;
      o <= 'b0;
      p <= 'b0;
    end
    else begin
      m <= 'b1;     //constants
      n <= 'b1;     //constants
      o <= 'b1;     //constants
      p <= 'b1;     //constants
    end
  end
  
  always@(posedge clk_20_Hz or negedge rst)begin
    if(~rst)begin
      cipher_1_hold <= 'b0;
      cipher_2_hold <= 'b0;
      cipher_3_hold <= 'b0;
      cipher_4_hold <= 'b0;;
    end
    else begin
      cipher_1_hold <= cipher_1;
      cipher_2_hold <= cipher_2;
      cipher_3_hold <= cipher_3;
      cipher_4_hold <= cipher_4;
    end
  end
  
  always@(posedge clk_20_Hz or negedge rst)begin
    if(~rst)begin
        ciphertext <= 'b0;
    end
    else begin 
        ciphertext <= ciphertext_next;
    end
  end
  always@(posedge clk_20_Hz or negedge rst)begin
    if(~rst)begin
        ready <= 'b0;
    end
    else if((ciphertext == ciphertext_next) & freeze) begin 
        ready <= 1'b1;
    end
  end
  always@*begin
    ciphertext_next = plaintext ^ ciphertext_key;
  end
  
  multiple_rounds col_1(.clk(clk_20_Hz),.rst(rst),.a(a),.b(e),.c(i),.d(m),
                         .a_out(cipher_1[N-1:3*N/4]),
                         .b_out(cipher_1[(3*N/4)-1:2*N/4]),
                         .c_out(cipher_1[(2*N/4)-1:N/4]),
                         .d_out(cipher_1[(N/4)-1:0]),
                         .ready(ready1));
  
  multiple_rounds col_2(.clk(clk_20_Hz),.rst(rst),.a(b),.b(f),.c(j),.d(n),
                         .a_out(cipher_2[N-1:3*N/4]),
                         .b_out(cipher_2[(3*N/4)-1:2*N/4]),
                         .c_out(cipher_2[(2*N/4)-1:N/4]),
                         .d_out(cipher_2[(N/4)-1:0]),
                         .ready(ready2));
  
  multiple_rounds col_3(.clk(clk_20_Hz),.rst(rst),.a(c),.b(g),.c(k),.d(o),
                         .a_out(cipher_3[N-1:3*N/4]),
                         .b_out(cipher_3[(3*N/4)-1:2*N/4]),
                         .c_out(cipher_3[(2*N/4)-1:N/4]),
                         .d_out(cipher_3[(N/4)-1:0]),
                         .ready(ready3));
  
  multiple_rounds col_4(.clk(clk_20_Hz),.rst(rst),.a(d),.b(h),.c(l),.d(p),
                         .a_out(cipher_4[N-1:3*N/4]),
                         .b_out(cipher_4[(3*N/4)-1:2*N/4]),
                         .c_out(cipher_4[(2*N/4)-1:N/4]),
                         .d_out(cipher_4[(N/4)-1:0]),
                         .ready(ready4));
  
  
                         
  multiple_rounds col_5(.clk(clk_20_Hz),.rst(rst),
                        .a(cipher_1_hold[N-1:3*N/4]),
                        .b(cipher_2_hold[(3*N/4)-1:2*N/4]),
                        .c(cipher_3_hold[(2*N/4)-1:N/4]),
                        .d(cipher_4_hold[(N/4)-1:0]),
                        .a_out(cipher_1_next[N-1:3*N/4]),
                        .b_out(cipher_1_next[(3*N/4)-1:2*N/4]),
                        .c_out(cipher_1_next[(2*N/4)-1:N/4]),
                        .d_out(cipher_1_next[(N/4)-1:0]),
                         .ready(ready5));
  
  multiple_rounds col_6(.clk(clk_20_Hz),.rst(rst),
                        .a(cipher_2_hold[N-1:3*N/4]),
                        .b(cipher_3_hold[(3*N/4)-1:2*N/4]),
                        .c(cipher_4_hold[(2*N/4)-1:N/4]),
                        .d(cipher_1_hold[(N/4)-1:0]),
                        .a_out(cipher_2_next[N-1:3*N/4]),
                        .b_out(cipher_2_next[(3*N/4)-1:2*N/4]),
                        .c_out(cipher_2_next[(2*N/4)-1:N/4]),
                        .d_out(cipher_2_next[(N/4)-1:0]),
                         .ready(ready6));
  
  multiple_rounds col_7(.clk(clk_20_Hz),.rst(rst),
                        .a(cipher_3_hold[N-1:3*N/4]),
                        .b(cipher_4_hold[(3*N/4)-1:2*N/4]),
                        .c(cipher_1_hold[(2*N/4)-1:N/4]),
                        .d(cipher_2_hold[(N/4)-1:0]),
                        .a_out(cipher_3_next[N-1:3*N/4]),
                        .b_out(cipher_3_next[(3*N/4)-1:2*N/4]),
                        .c_out(cipher_3_next[(2*N/4)-1:N/4]),
                        .d_out(cipher_3_next[(N/4)-1:0]),
                         .ready(ready7));
  
  multiple_rounds col_8(.clk(clk_20_Hz),.rst(rst),
                        .a(cipher_4_hold[N-1:3*N/4]),
                        .b(cipher_1_hold[(3*N/4)-1:2*N/4]),
                        .c(cipher_2_hold[(2*N/4)-1:N/4]),
                        .d(cipher_3_hold[(N/4)-1:0]),
                        .a_out(cipher_4_next[N-1:3*N/4]),
                        .b_out(cipher_4_next[(3*N/4)-1:2*N/4]),
                        .c_out(cipher_4_next[(2*N/4)-1:N/4]),
                        .d_out(cipher_4_next[(N/4)-1:0]),
                         .ready(ready8));
  
  assign ciphertext_key = {cipher_1_next,cipher_2_next,cipher_3_next,cipher_4_next};
  
  assign decrypt = ciphertext ^ ciphertext_key;
endmodule