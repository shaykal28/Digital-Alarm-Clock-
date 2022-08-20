module tb_lcd_driver();

reg [3:0] key,alarm_time,current_time;
reg show_alarm,show_new_time;

wire [7:0] display_time;
wire sound_alarm;


lcd_driver DUT(.key(key),.alarm_time(alarm_time),.current_time(current_time),.show_alarm(show_alarm),
               .show_new_time(show_new_time),.display_time(display_time),.sound_alarm(sound_alarm));

task initialize;
begin
show_alarm = 0'b0; 
show_new_time = 0'b0;
key = 4'b0;
alarm_time = 4'b0;
current_time = 4'b0;
end 
endtask

task show_type(input x, input y);
begin
show_alarm = x;
show_new_time = y;
end
endtask

task stimulus(input [3:0] a,input [3:0] b,input [3:0] c);
begin
key = a;
alarm_time = b;
current_time = c;
end
endtask

initial begin
initialize;
#10;
show_type(0,0);
stimulus(4'b0110,4'b0100,4'b0111);
#10;
show_type(1,0);
stimulus(4'b0110,4'b0011,4'b1011);
#10;
show_type(0,1);
stimulus(4'b0010,4'b1011,4'b1001);
#10;
stimulus(4'b0010,4'b1001,4'b1001);
#50;
$finish;
end

endmodule


