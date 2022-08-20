`timescale 1ms/1ms

module tb_keyreg();

reg reset,clock,shift;
reg [3:0] key;
wire [3:0]   key_buffer_ls_min,
             key_buffer_ms_min,
             key_buffer_ls_hr,
             key_buffer_ms_hr;

keyreg DUT(.clock(clock),.reset(reset),.shift(shift),.key(key),.key_buffer_ls_min(key_buffer_ls_min),.key_buffer_ms_min(key_buffer_ms_min),
           .key_buffer_ls_hr(key_buffer_ls_hr),.key_buffer_ms_hr(key_buffer_ms_hr));

task initialize;
begin
 clock = 1'b0;
 reset = 1'b0;
 shift = 1'b0;
 key = 4'd4;
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

task key_stimulus(input [3:0] y);
begin
 key = y;
end
endtask

task shift_call(input x);
begin
 shift = x;
end
endtask

initial begin
initialize;
#4 reset_call;
#2 shift_call(1);
@(negedge clock);
key_stimulus(4'd3);
@(negedge clock);
key_stimulus(4'd6);
@(negedge clock);
key_stimulus(4'd1);
#2 shift_call(0);
#100 shift_call(1);
@(negedge clock);
key_stimulus(4'd2);
@(negedge clock);
key_stimulus(4'd5);
@(negedge clock);
key_stimulus(4'd1);
@(negedge clock);
key_stimulus(4'd2);
#2 shift_call(0);
#50 $finish;
end
endmodule






