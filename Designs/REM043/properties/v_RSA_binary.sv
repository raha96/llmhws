module v_RSA_binary( 
		input clk,	
		input start,	 
		input key_ready,				
		input finished
		);

	parameter RESULT=3'b000, 
		  IDLE=3'b001, 
		  INIT=3'b010, 
		  LOAD1=3'b011, 
		  LOAD2=3'b100, 
		  MULT=3'b101, 
		  SQR=3'b110;

	property constant_9_Cycle;
		@(posedge clk) (finished==1'b1) |-> 
		$past(RSA_binary.FSM==INIT,9);
	endproperty
	checkConstant_9_Cycle: assert property(constant_9_Cycle);

endmodule
