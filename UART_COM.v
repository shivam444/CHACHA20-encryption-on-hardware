`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.04.2024 14:53:02
// Design Name: 
// Module Name: UART_COM
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


module uart_top(
    input   wire    clk,
    input   wire    rst_n,

    input   wire    rxd,
    output  wire    txd,
    output ready
    );

    parameter M = 128; 
    
//    reg [M-1:0] memory;
//    reg [M-1:0] memory_next;
    
    wire clk_100hz;
    wire [511:0] key;
    wire key_ready;
    //wire trig_in_ack;
    //wire encrypt_ready;
//    reg [9:0] count;
//    reg [9:0] ns_count;
    wire clk_100;
    
    clk_100 clk_100mhz
   (
    // Clock out ports
    .clk_out1(clk_100),     // output clk_out1
   // Clock in ports
    .clk_in1(clk)      // input clk_in1
    );
    
    wire    bclk;
    baud_gen    inst_baud_gen(
        .clk    (clk_100),
        .rst_n  (rst_n),
        .bclk   (bclk)
    );
    
    
    
    wire    tx_ready;
    reg    [7:0]    loop_dout;
    reg tx_cmd  =   0;
    uart_tx     inst_uart_tx(
        .bclk       (bclk),
        .rst_n      (rst_n),
        .tx_cmd     (tx_cmd),
        .tx_din     (loop_dout),
        .tx_ready   (tx_ready),
        .txd        (txd)
    );


    wire    rx_ready;
    wire    rx_done;
    wire [7:0] dout_tmp;
    reg [7:0] encrypted_dout_temp;
    wire [7:0] encrypted_dout_temp_val;
//    wire [7:0] probe_out0;
//    reg [8:0] mem_count;
//    reg [8:0] mem_count_ns;
    
    uart_rx     inst_uart_rx(
        .bclk       (bclk),
        .rst_n      (rst_n),
        .rxd        (rxd),

        .rx_done    (rx_done),
        .rx_ready   (rx_ready),
        .rx_dout    (dout_tmp)
    );


    CHACHA_20#(.N(M)) key_dut(.clk(clk_100),.rst(rst_n),.start(1'b1),
                                  .plaintext('b0),
                                  .ciphertext(key),
                                  .ready(key_ready));
                                  
//    always@*begin
//        encrypted_dout_temp = dout_tmp^key;
//    end 
    
    genvar i;
    generate
        for(i=0;i<8;i=i+1)begin                          
            xor x(encrypted_dout_temp_val[i],dout_tmp[i],key[i]);
        end
    endgenerate
    
    
    always@(posedge clk_100 or negedge rst_n)begin
        if(~rst_n)begin
            encrypted_dout_temp <= 'b0;
        end
        else begin
            encrypted_dout_temp <= encrypted_dout_temp_val;
        end
    end
        
    always @(posedge bclk or negedge rst_n) begin
        if(!rst_n) begin
            tx_cmd <= 0;
            loop_dout <= 0;
        end else if(rx_done && tx_ready) begin
            loop_dout <= encrypted_dout_temp^key ;
            tx_cmd <= 1;
        end else if (tx_ready) begin
            loop_dout <= 0;
            tx_cmd <= 0;
        end else begin
            tx_cmd <= 0;
        end
    end

    
    
    
    assign ready = key_ready;
    
    //ILA instansiation
    ila_0 ILA_key (
	.clk(clk_100), // input wire clk


	.probe0(key) // input wire [511:0] probe0
    );
    
//    ila_0 your_instance_name (
//	.clk(clk_100), // input wire clk

//	.trig_in(clk_100),// input wire trig_in 
//	.trig_in_ack(trig_in_ack),// output wire trig_in_ack 
//	.probe0(key) // input wire [511:0] probe0
//    );
//    vio_0 your_instance_name (
//  .clk(clk_100),                // input wire clk
//  .probe_in0(decrypted_dout_temp),    // input wire [7 : 0] probe_in0
//  .probe_out0()  // output wire [7 : 0] probe_out0
//    );
endmodule
