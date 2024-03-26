module v_sha256_control(  
	input clk_i, 
	input ce_i,
	input start_i, 
	input end_i, 
	input ack_i,
	input bytes_i, 
	input error_i, 
	input bytes_error_reg, 
	input st_cnt_reg, 
	input sha_last_blk_reg, 
	input padding_reg, 
	input one_insert, 
	input wait_run_ce, 
	input bitlen_o, 
	input words_sel_o, 
	input Kt_addr_o, 
	input sch_ld_o, 
	input core_ld_o, 
	input oregs_ld_o, 
	input sch_ce_o, 
	input core_ce_o, 
	input oregs_ce_o, 
	input bytes_ena_o, 
	input one_insert_o, 
	input di_req_o, 
	input data_valid_o, 
	input error_o                                       
);                      


parameter st_reset = 3'b000, st_sha_data_input=3'b001, st_sha_blk_process = 3'b010, st_sha_blk_nxt =3'b011, st_sha_padding  = 3'b100, st_sha_data_valid=3'b101, st_error =3'b110;


property validSignal;
	@(posedge clk_i) (sha256_control.data_valid_o==1'b1) |-> (sha256_control.hash_control_st_reg==st_sha_data_valid);
endproperty 
checkValidSiganlAtValidState: assert property(validSignal);  


endmodule
