module tb_alarm_reg();

reg clock,reset,load_new_alarm;
reg [3:0]  new_alarm_ms_hr,
           new_alarm_ls_hr,
           new_alarm_ms_min,
           new_alarm_ls_min;
wire [3:0] alarm_time_ms_hr,
           alarm_time_ls_hr,
           alarm_time_ms_min,
           alarm_time_ls_min;

alarm_reg DUT(.clock(clock),.reset(reset),.load_new_alarm(load_new_alarm),
	      .new_alarm_ms_hr(new_alarm_ms_hr),.new_alarm_ls_hr(new_alarm_ls_hr),
	      .new_alarm_ms_min(new_alarm_ms_min),.new_alarm_ls_min(new_alarm_ls_min),
		.alarm_time_ms_hr(alarm_time_ms_hr),.alarm_time_ls_hr(alarm_time_ls_hr),
		.alarm_time_ms_min(alarm_time_ms_min),.alarm_time_ls_min(alarm_time_ls_min));

parameter CYCLE = 10;

task initialize;
 begin
  clock = 1'b0;
  reset = 1'b0;
  load_new_alarm = 1'b0;
  new_alarm_ms_hr = 4'b0;
  new_alarm_ls_hr = 4'b0;
  new_alarm_ms_min = 4'b0;
  new_alarm_ls_min = 4'b0;
 end
endtask

always begin
 #(CYCLE/2) clock = ~clock;
end


task reset_call();
 begin  
 #5 reset = 1'b1;
 @(negedge clock);
 reset = 1'b0;
 end
endtask

task load(input x);
 begin
 load_new_alarm = x;
 end
endtask

task stimulus(input [3:0] a,input [3:0] b,input [3:0] c,input [3:0] d);
begin
 new_alarm_ms_hr = a;
 new_alarm_ls_hr = b;
 new_alarm_ms_min = c;
 new_alarm_ls_min = d;
end
endtask

initial begin
initialize;
#15;
load(1);
stimulus(1,1,4,5);
#12;
load(0);
stimulus(2,3,5,9);
#38;
load(1);
stimulus(1,6,3,2);
#15;
reset_call();
load(0);
#40;
load(1);
stimulus(0,4,3,7);
#50 $finish;
end

initial begin
$monitor("reset=%b load=%b alarm_ms_hr=%4b alarm_ls_hr=%4b alarm_ms_min=%4b alarm_ls_min=%4b",
          reset,load,alarm_time_ms_hr,alarm_time_ls_hr,alarm_time_ms_min,alarm_time_ls_min);
end


endmodule   
   


