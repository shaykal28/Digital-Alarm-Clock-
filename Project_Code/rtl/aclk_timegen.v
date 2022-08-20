module aclk_timegen( input clk,reset,reset_count,fast_watch,
		     output reg one_min,one_sec);

reg [13:0] cycle_count;
reg one_min_temp;

always@(posedge clk or posedge reset) begin //for minutes
    if(reset) begin
	cycle_count <= 14'b0;
	one_min_temp <= 1'b0;
    end

    else if(reset_count) begin
	cycle_count <= 14'b0;
	one_min_temp <= 1'b0;
    end
    
    else if(cycle_count[13:0] == 14'd15359) begin //for seconds
	    one_min_temp <= 1'b1;
	    cycle_count <= 14'b0;
    end
	
    else begin
	    cycle_count <= cycle_count + 1;
	    one_min_temp <= 1'b0;
    end
  
end

always@(posedge clk or posedge reset) begin
    if(reset) begin
	one_sec <= 1'b0;
    end

    else if(reset_count) begin
	one_sec <= 1'b0;
    end

    else begin
	if(cycle_count[7:0] == 8'd255) begin
	     one_sec <= 1'b1;
	end
	else begin
	     one_sec <= 1'b0;
	end
    end
end

always@(*) begin
 
    if(!fast_watch) begin
	one_min <= one_min_temp;
    end

    else begin
	one_min <= one_sec;
    end 

 end

endmodule      
        
		    	    
		  
