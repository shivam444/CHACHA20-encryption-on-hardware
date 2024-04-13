`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.04.2024 23:49:52
// Design Name: 
// Module Name: UART
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


module baud_gen(
    input   wire    clk,
    input   wire    rst_n,
    output  reg     bclk
    );
    reg [8:0]   cnt;
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            cnt     <=  0;
            bclk    <=  0;
        end else if(cnt > 9) begin
            // 115200 * 16 = 1843.2kbps
            // 50M / 1843200 = 27.126
            cnt     <=  0;
            bclk    <=  1;
        end else begin
            cnt     <=  cnt + 1;
            bclk    <=  0;
        end
    end
endmodule

module uart_tx(
    input   wire            bclk,
    input   wire            rst_n,
    input   wire            tx_cmd,
    input   wire    [7:0]   tx_din,
    output  reg             tx_ready,
    output  reg             txd
);
    parameter [3:0] Lframe  = 8;
    parameter [2:0] s_idle  = 3'b000;
    parameter [2:0] s_start = 3'b001;
    parameter [2:0] s_wait  = 3'b010;
    parameter [2:0] s_shift = 3'b011;
    parameter [2:0] s_stop  = 3'b100;

    reg [2:0]   cur_state   =   s_idle;
    reg [3:0]   cnt         =   0;
    reg [3:0]   dcnt        =   0;
    
    always @(posedge bclk or negedge rst_n) begin
        if(!rst_n) begin
            cur_state   <=  s_idle;
            cnt         <=  0;
            tx_ready    <=  0;
            txd         <=  1;
        end else begin
            case (cur_state)
                s_idle: begin
                    tx_ready    <=  1;
                    cnt         <=  0;
                    txd         <=  1;
                    if(tx_cmd == 1'b1) begin
                        cur_state <= s_start;
                    end else begin
                        cur_state <= s_idle;
                    end
                end

                s_start: begin
                    tx_ready    <=  0;
                    txd         <=  1'b0;
                    cur_state   <=  s_wait;
                end

                s_wait: begin
                    tx_ready    <=  0;
                    if(cnt >= 4'b1110) begin
                        cnt         <=  0;
                        if(dcnt == Lframe) begin
                            cur_state   <=  s_stop;
                            dcnt        <=  0;
                            txd         <=  1'b1;
                        end else begin
                            cur_state   <=  s_shift;
                            txd         <=  txd;
                        end
                    end else begin
                        cur_state   <=  s_wait;
                        cnt         <=  cnt + 1;
                    end
                end

                s_shift: begin
                    tx_ready        <=  0;
                    txd             <=  tx_din[dcnt];
                    dcnt            <=  dcnt + 1;
                    cur_state       <=  s_wait;
                end

                s_stop: begin
                    txd             <=  1'b1;
                    if(cnt >= 4'b1110) begin
                        cur_state   <=  s_idle;
                        cnt         <=  0;
                        tx_ready    <=  1;
                    end else begin
                        cur_state   <=  s_stop;
                        cnt         <=  cnt + 1;    
                    end
                end

                default: begin
                    cur_state       <=  s_idle;
                end
            endcase

        end
    end
endmodule

module uart_rx(
    input   wire        bclk,
    input   wire        rst_n,
    input   wire        rxd,
    input   wire        key_flag,
    output  reg         rx_done,
    output  reg         rx_ready,
    output  reg [7:0]   rx_dout
    );

    parameter [3:0] Lframe      = 8;
    parameter [1:0] s_idle      = 2'b00;
    parameter [1:0] s_sample    = 2'b01;
    parameter [1:0] s_stop      = 2'b10;

    reg       [1:0] cur_state   = s_idle;
    reg       [3:0] cnt         = 0;
    reg       [3:0] num         = 0;
    reg       [3:0] dcnt        = 0;
    
    reg [511:0] key;

    always @(posedge bclk or negedge rst_n) begin
        if(!rst_n) begin
            cur_state <= s_idle;
            cnt <= 0;
            dcnt <= 0;
            num <= 0;
            rx_dout <= 0;
            rx_ready <= 0;
            rx_done <=  0;
            key <= 'b0;
        end else begin
            case (cur_state)
            // Idle State
                s_idle: begin
                    rx_dout <= 0;
                    dcnt <=0;
                    rx_ready <= 1;
                    rx_done <=  0;
                    if(cnt == 4'b1111) begin
                        cnt <= 0;
                        if(num > 7) begin
                            cur_state <= s_sample;
                            num <= 0;
                        end else begin
                            cnt <= 0;
                            cur_state <= s_idle;
                            num <= 0;
                        end 
                    end else begin
                        cnt <= cnt + 1;
                        if(rxd == 1'b0) begin
                            num <= num + 1;
                        end else begin
                            num <= num;
                        end
                    end
                end
            // Sampling State
                s_sample: begin
                    rx_ready <= 1'b0;
                    rx_done <=  0;
                    if(dcnt == Lframe) begin
                        cur_state <= s_stop;
                    end else begin
                        cur_state <= s_sample;
                        if(cnt == 4'b1111) begin
                            dcnt <= dcnt + 1;
                            cnt <= 0;
                            if(num > 7) begin
                                num <= 0;
                                rx_dout[dcnt] <= 1;
                            end else begin
                                rx_dout[dcnt] <= 0;
                                num <= 0;
                            end
                        end else begin
                            cnt <= cnt + 1;
                            if(rxd == 1'b1) begin
                                num <= num + 1;
                            end else begin
                                num <= num;
                            end
                        end
                    end
                end
            // Stop State
                s_stop: begin
                    rx_ready <= 1'b1;
                    rx_done <=  1'b1;
                    if(cnt == 4'b1111) begin
                        cnt <= 0;
                        cur_state <= s_idle;
                    end else begin
                        cnt <= cnt + 1;
                    end
                end
                default: begin
                    cur_state <= s_idle;
                end
            endcase
        end
    end
endmodule


//module uart_top(
//    input   wire    clk,
//    input   wire    rst_n,

//    input   wire    rxd,
//    output  wire    txd
//    );

//    wire    bclk;
//    baud_gen    inst_baud_gen(
//        .clk    (clk),
//        .rst_n  (rst_n),
//        .bclk   (bclk)
//    );
    
//    wire    tx_ready;
//    reg    [7:0]    loop_dout;
//    reg tx_cmd  =   0;
//    uart_tx     inst_uart_tx(
//        .bclk       (bclk),
//        .rst_n      (rst_n),
//        .tx_cmd     (tx_cmd),
//        .tx_din     (loop_dout),
//        .tx_ready   (tx_ready),
//        .txd        (txd)
//    );

//    wire    rx_ready;
//    wire    rx_done;
//    wire [7:0] dout_tmp;
//    uart_rx     inst_uart_rx(
//        .bclk       (bclk),
//        .rst_n      (rst_n),
//        .rxd        (rxd),

//        .rx_done    (rx_done),
//        .rx_ready   (rx_ready),
//        .rx_dout    (dout_tmp)
//    );

//    always @(posedge bclk or negedge rst_n) begin
//        if(!rst_n) begin
//            tx_cmd <= 0;
//            loop_dout <= 0;
//        end else if(rx_done && tx_ready) begin
//            loop_dout <= dout_tmp;
//            tx_cmd <= 1;
//        end else if (tx_ready) begin
//            loop_dout <= 0;
//            tx_cmd <= 0;
//        end else begin
//            tx_cmd <= 0;
//        end
//    end
//endmodule
