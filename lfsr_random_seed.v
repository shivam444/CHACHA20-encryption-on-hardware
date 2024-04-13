module lfsr_random_seed#(parameter N = 32)(input clk, input rst,
                               output[N-1:0]out);
  localparam index1 = 0;
  localparam index2 = N/4;
  localparam index3 = (N/4) + (N/8);
  localparam index4 = (N/4) + 1 + (N/2);
  localparam index5 = (N/2)+1;
  
  wire [N-1:0] count;
  wire [N-1:0] start_count; //suppose to run at differnt clk to create a random count
  reg [N-1:0] present_state;
  reg [N-1:0] next_state;
  reg flag = 0;
  
  counter #(.N(N)) count1(.clk(clk),.rst(rst),.count(count));
  counter #(.N(N)) count2(.clk(clk),.rst(rst),.count(start_count));
  
  always@*begin
    next_state = {(present_state[index1]^
                   present_state[index2]^
                   present_state[index3]^
                   present_state[index4]), present_state[N-1:N/2],
                  (present_state[index3]^
                   present_state[index5]), present_state[(N/2)-1:2]};
  end
  always@(posedge clk or negedge rst)begin
    if(~rst)begin
      present_state <= 'b0;
    end 
    else if(start_count > 'd5 && start_count < 'd1000)begin
      present_state <= count;
    end
    else if(flag) begin
      present_state <= next_state;
    end
  end
  always@(posedge clk or negedge rst)begin
      if(~rst)begin
        flag <= 1'b0;
      end
      else if(start_count > 'd5 && start_count < 'd1000)begin
          flag <= 1'b1;
      end
  end
        
  assign out = present_state;
endmodule