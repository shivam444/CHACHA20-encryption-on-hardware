module lfsr#(parameter N = 32)(input clk, input rst, input start,
                               input random_seed,
                               output[N-1:0]out);
  localparam index1 = 0;
  localparam index2 = N/4;
  localparam index3 = (N/4) + (N/8);
  localparam index4 = (N/4) + 1 + (N/2);
  localparam index5 = (N/2)+1;
  
  reg [N-1:0] present_state;
  reg [N-1:0] next_state;
  reg flag = 0;
  
  always@*begin
    next_state = {(present_state[index1]^
                   present_state[index2]^
                   present_state[index3]^
                   present_state[index4]), present_state[N-1:N/2],
                  (present_state[index3]^
                   present_state[index5]), present_state[(N/2)-1:3],
                   random_seed};
  end
  
  always@(posedge clk or negedge rst)begin
    if(~rst)begin
      present_state <= 1'b1;
    end
    else if(start == 'b1)begin
      present_state <= next_state;
    end
  end
  
  assign out = present_state;
endmodule