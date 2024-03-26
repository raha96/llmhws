module v_aes_binary( 
		//input rst, 
		input clk,	
		input data_stable,	 
		input key_ready,				
		input finished,		
		input [1:0] round_type_sel
		);

parameter WAIT_KEY = 3'b001, WAIT_DATA= 3'b010, INITIAL_ROUND= 3'b011, DO_ROUND= 3'b100, FINAL_ROUND= 3'b000;

property accessToFinalRound;
	@(posedge clk) (aes_binary.FSM==FINAL_ROUND) |-> 
	$past(aes_binary.FSM==DO_ROUND) ||
	$past(aes_binary.FSM==FINAL_ROUND);
endproperty
checkAccessToFinalRound: assert property(accessToFinalRound);

endmodule
