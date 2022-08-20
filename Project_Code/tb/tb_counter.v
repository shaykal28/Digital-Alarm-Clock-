`timescale 1ms/1ms

module tb_counter();

reg clock,reset,one_minute,load_new_c;
reg [3:0]    new_current_time_ms_hr,
	     new_current_time_ms_min,
	     new_current_time_ls_hr,
	     new_current_time_ls_min;
wire [3:0]   current_time_ms_hr,
	     current_time_ms_min,
	     current_time_ls_hr,
	     current_time_ls_min;

counter DUT(.clk(clock),.reset(reset),.one_minute(one_minute),.load_new_c(load_new_c),
	    .new_current_time_ms_hr(new_current_time_ms_hr),.new_current_time_ls_hr(new_current_time_ls_hr),
	    .new_current_time_ms_min(new_current_time_ms_min),.new_current_time_ls_min(new_current_time_ls_min),
	    .current_time_ms_hr(current_time_ms_hr),.current_time_ls_hr(current_time_ls_hr),
	    .current_time_ms_min(current_time_ms_min),.current_time_ls_min(current_time_ls_min));

task initialize;
begin
 clock = 1'b0;
 reset = 1'b0;
 one_minute = 1'b0;
 load_new_c = 1'b0;
 new_current_time_ms_hr = 4'd0;
 new_current_time_ls_hr = 4'd9;
 new_current_time_ms_min = 4'd1;
 new_current_time_ls_min = 4'd6;
end
endtask

always begin
#2 clock = ~clock;
end


always begin
#2 one_minute = ~ one_minute;
end

task reset_call();
begin
 reset = 1'b1;
 repeat(2)
 @(negedge clock);
 reset = 1'b0;
end
endtask

task load_enable(input x);
begin
 load_new_c = x;
end
endtask

task load_stimulus (input [3:0] a,b,c,d);
begin
 new_current_time_ms_hr = a;
 new_current_time_ls_hr = b;
 new_current_time_ms_min = c;
 new_current_time_ls_min = d;
end
endtask

initial begin
initialize;
#4 reset_call;
@(posedge clock);
load_enable(1);
@(posedge clock);
load_enable(0);
#4060 load_enable(1);
load_stimulus(4'd1,4'd8,4'd3,4'd2);
#4 load_enable(0);
#5000 $finish;
end

endmodule



