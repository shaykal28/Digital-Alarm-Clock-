`timescale 1ms/1ms

module tb_aclk_timegen();
reg clock,reset,reset_count,fast_watch;
wire one_min,one_sec;

aclk_timegen DUT(.clk(clock),.reset(reset),.reset_count(reset_count),.fast_watch(fast_watch),
		 .one_min(one_min),.one_sec(one_sec));
task initialize;
begin
 clock = 1'b0;
 reset = 1'b0;
 reset_count = 1'b0;
 fast_watch = 1'b0;
end
endtask

always begin
#2 clock = ~clock;
end

task reset_call();
begin
 reset = 1'b1;
 repeat(2)
 @(negedge clock);
 reset = 1'b0;
end
endtask

task reset_count_call;
begin
 reset_count = 1'b1;
 repeat(2)
 @(negedge clock);
 reset_count = 1'b0;
end
endtask

task fast_watch_call(input x);
begin
 fast_watch = x;
end
endtask

initial begin
initialize;
#12 reset_call;
#93000 fast_watch_call(1);
#10000 fast_watch_call(0);
#20000 $finish;
end

initial begin
$monitor("clock=%0b reset=%0b fast_watch=%0b one_minute=%0b one_second=%0b",clock,reset,fast_watch,one_min,one_sec);
end

endmodule

