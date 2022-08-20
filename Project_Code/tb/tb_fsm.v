`timescale 1ms/1ms
module tb_fsm();

reg clk,reset,time_button,alarm_button,one_second;
reg [3:0] key;

wire reset_count,load_new_c,show_new_time,show_a,load_new_a,shift;

fsm DUT(.clock(clk),.reset(reset),.time_button(time_button),.alarm_button(alarm_button),.one_second(one_second),.key(key),
		.reset_count(reset_count),.load_new_c(load_new_c),.show_new_time(show_new_time),.show_a(show_a),.load_new_a(load_new_a),
		.shift(shift));
		
task initialize;
begin
  clk = 1'b0;
  reset = 1'b0;
  time_button = 1'b0;
  alarm_button = 1'b0;
  one_second = 1'b0;
end
endtask

always begin
 #2 clk = ~ clk;
end

task reset_call();
begin
  reset = 1'b1;
  repeat(2)
  @(negedge clk);
  reset = 1'b0;
end
endtask

task one_sec_high;
begin
  repeat(10)
  begin
  @(negedge clk);
  one_second = 1'b1;                                                                      
  end                                                                                   
  @(negedge clk); 
  one_second=1'b0; 
end 
endtask

task alarm_but_press; 
begin 
 @(negedge clk); 
 alarm_button= 1'b1; 
 @(negedge clk); 
 alarm_button= 1'b0; 
end 
endtask  

task time_but_press; 
begin 
@(negedge clk); 
time_button =1'b1; 
@(negedge clk);  
time_button =1'b0; 
end 
endtask 

task key_t(input [3:0]a); 
begin 
 @(negedge clk); 
 key = a;  
 @(negedge clk); 
 key = 'd10; 
end 
endtask 

initial begin
 initialize;
 #4 reset_call;
 alarm_but_press;
 key_t(1); 
 key_t(2); 
 key_t(5); 
 key_t(9); 
 time_but_press; 
 key_t(0); 
 key_t(9); 
 key_t(3); 
 key_t(5); 
 alarm_but_press; 
 key_t(3); 
 one_sec_high; 
 key_t(1); 
 one_sec_high; 
 #50 $finish; 
end 

endmodule
