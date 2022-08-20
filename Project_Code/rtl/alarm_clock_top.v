/********************************************************************************************

Copyright 2018-2019 - Maven Silicon Softech Pvt Ltd. All Rights Reserved.

This source code is an unpublished work belongs to Maven Silicon Softech Pvt Ltd.
It is considered a trade secret and is not to be divulged or used by parties who 
have not received written authorization from Maven Silicon Softech Pvt Ltd.

Maven Silicon Softech Pvt Ltd
Bangalore - 560076

Webpage: www.maven-silicon.com

Filename:	alarm_clock_top.v   

Description:	This is the top module of Alarm clock.
                It has instantiated all the sub-modules 
		which are connected via internal wires .

Date:		01/05/2018

Author:		Maven Silicon

Email:	        online@maven-silicon.com	

Version:	1.0

*********************************************************************************************/
module alarm_clock_top(clock,
	               key,
		       reset,
		       time_button,
		       alarm_button,
		       stopwatch,
		       ms_hour,
		       ls_hour,
		       ms_minute,
		       ls_minute,
		       alarm_sound);
// Define port directions for the signals
input clock,reset,time_button,alarm_button,stopwatch;
input [3:0] key;

output  [7:0] ms_hour,ls_hour,ms_minute,ls_minute;
output alarm_sound;


//Define the Interconnecting internal wires
wire one_min_sig,one_sec_sig;
wire reset_count_sig,load_new_c_sig,show_new_time_sig,show_a_sig,load_new_a_sig,shift_sig;
wire [3:0] key_buffer_ms_hr_sig,key_buffer_ls_hr_sig,key_buffer_ms_min_sig,key_buffer_ls_min_sig;
wire [3:0] alarm_time_ms_hr_sig,alarm_time_ls_hr_sig,alarm_time_ms_min_sig,alarm_time_ls_min_sig;
wire [3:0] current_time_ms_hr_sig,current_time_ls_hr_sig,current_time_ms_min_sig,current_time_ls_min_sig;


//Instantiate lower sub-modules. Use interconnect(Internal) signals for connecting the sub modules

// Instantiate the timing generator module
aclk_timegen DUT0(.clk(clock),
		  .reset(reset),
		  .reset_count(reset_count_sig),	
		  .fast_watch(stopwatch),
		  .one_min(one_min_sig),
		  .one_sec(one_sec_sig));


// Instantiate the counter module
counter DUT1(   .clk(clock),	
		.reset(reset),
		.one_minute(one_min_sig),
		.load_new_c(load_new_c_sig),
		.new_current_time_ms_hr(key_buffer_ms_hr_sig),
                .new_current_time_ls_hr(key_buffer_ls_hr_sig),
		.new_current_time_ms_min(key_buffer_ms_min_sig),
	 	.new_current_time_ls_min(key_buffer_ls_min_sig),
		.current_time_ms_hr(current_time_ms_hr_sig),
		.current_time_ls_hr(current_time_ls_hr_sig),
		.current_time_ms_min(current_time_ms_min_sig),
		.current_time_ls_min(current_time_ls_min_sig));

// Instantiate the alarm register module
alarm_reg DUT2(.clock(clock),
		.reset(reset),
		.load_new_alarm(load_new_a_sig),
		.new_alarm_ms_hr(key_buffer_ms_hr_sig),
                .new_alarm_ls_hr(key_buffer_ls_hr_sig),
		.new_alarm_ms_min(key_buffer_ms_min_sig),
		.new_alarm_ls_min(key_buffer_ls_min_sig),
		.alarm_time_ms_hr(alarm_time_ms_hr_sig),		
		.alarm_time_ls_hr(alarm_time_ls_hr_sig),
		.alarm_time_ms_min(alarm_time_ms_min_sig),
		.alarm_time_ls_min(alarm_time_ls_min_sig));


// Instantiate the key register module
keyreg DUT3(.clock(clock),
		.reset(reset),
		.key(key),
		.shift(shift_sig),
		.key_buffer_ms_hr(key_buffer_ms_hr_sig),
		.key_buffer_ls_hr(key_buffer_ls_hr_sig),
                .key_buffer_ms_min(key_buffer_ms_min_sig),
		.key_buffer_ls_min(key_buffer_ls_min_sig));


// Instantiate the FSM controller
fsm DUT4(.clock(clock),
	 .reset(reset),
	 .time_button(time_button),
	 .alarm_button(alarm_button),
	 .key(key),
	 .one_second(one_sec_sig),
         .reset_count(reset_count_sig),
	 .load_new_c(load_new_c_sig),
	 .show_new_time(show_new_time_sig),
	 .show_a(show_a_sig),
	 .load_new_a(load_new_a_sig),
	 .shift(shift_sig));

// Instantiate the lcd_driver_4 module
lcd_driver_4 DUT5(.show_a(show_a_sig),
		  .show_current_time(show_new_time_sig),
		  .alarm_time_ms_hr(alarm_time_ms_hr_sig),
		  .alarm_time_ls_hr(alarm_time_ls_hr_sig),
		  .alarm_time_ms_min(alarm_time_ms_min_sig),
	  	  .alarm_time_ls_min(alarm_time_ls_min_sig),
		  .key_ms_hr(key_buffer_ms_hr_sig),
		  .key_ls_hr(key_buffer_ls_hr_sig),
		  .key_ms_min(key_buffer_ms_min_sig),
		  .key_ls_min(key_buffer_ls_min_sig),
		  .current_time_ms_hr(current_time_ms_hr_sig),
		  .current_time_ls_hr(current_time_ls_hr_sig),
                  .current_time_ms_min(current_time_ms_min_sig),
		  .current_time_ls_min(current_time_ls_min_sig),
		  .sound_a(alarm_sound),
		  .display_ms_hr(ms_hour),
		  .display_ls_hr(ls_hour),
		  .display_ms_min(ms_minute),
		  .display_ls_min(ls_minute));

endmodule


		   

