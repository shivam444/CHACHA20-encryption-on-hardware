module random_number#(parameter N=32)(input clk, input rst,
                                      output [N-1:0] key, output ready);
  wire [N-1:0] count_load;
  wire [N-1:0] start_count;
  wire [N-1:0] random_seed;
  wire [(4*N)-1:0] new_key_count;
  reg start;
  reg new_key;
  wire clk_123;
  wire clk_100;
  reg flag;
  reg flag_next;
  
    clk_22 clk_22_Hz
   (
    // Clock out ports
    .clk_out1(clk_22),     // output clk_out1
   // Clock in ports
    .clk_in1(clk)      // input clk_in1
);
//    clk_100 clk_100_Hz
//   (
//    // Clock out ports
//    .clk_out1(clk_100),     // output clk_out1
//   // Clock in ports
//    .clk_in1(clk)      // input clk_in1
//);

  counter #(.N(N)) count1(.clk(clk),.rst(rst),.count(count_load));
  counter #(.N(N)) count2(.clk(clk_22),.rst(rst),.count(start_count));
  
  counter #(.N(4*N)) count3(.clk(clk),.rst(rst),.count(new_key_count));
  
  always@* begin
    if(start_count > 'd100 && start_count < 'd500 && flag == 1'b0)begin
      start = 1'b1;
      flag_next = 1'b1;
    end
    else begin
      start = 1'b0;
      flag_next = 1'b0;
    end
  end
  always@(posedge clk or negedge rst)begin
    if(~rst) begin
      flag <= 1'b0;
    end
    else begin
      flag <= flag_next;
    end
  end
  always@(posedge clk or negedge rst)begin
    if(~rst) begin
      new_key <= 1'b1;
    end
    else if(new_key_count > 128'b100)begin
      new_key <= 1'b0;
    end
  end
  
  lfsr_random_seed #(.N(N)) random_seed_gen(.clk(clk),.rst(rst),.out(random_seed));
  
  PRNG #(.N(N)) random_num_gen (.clk(clk),.rst(rst),.start(start),
                      .new_key(new_key),.count_load(count_load),
                      .random_seed1(random_seed[N/4]),
                      .random_seed2(random_seed[N-4]),
                      .key(key),.ready(ready));
endmodule