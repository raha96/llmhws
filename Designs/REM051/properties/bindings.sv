module binding_module;
bind sha256_control v_sha256_control s_sha256_control(  

  	clk_i, 
	ce_i,
        start_i, 
        end_i, 
        ack_i,
        bytes_i, 
        error_i, 
        bytes_error_reg, 
        st_cnt_reg, 
        sha_last_blk_reg, 
        padding_reg, 
        one_insert, 
	wait_run_ce, 
      bitlen_o, 
       words_sel_o, 
       Kt_addr_o, 
       sch_ld_o, 
       core_ld_o, 
        oregs_ld_o, 
        sch_ce_o, 
        core_ce_o, 
        oregs_ce_o, 
        bytes_ena_o, 
        one_insert_o, 
        di_req_o, 
        data_valid_o, 
        error_o 

/*
//original
	.clk_i(clk_i),                                 
	.ce_i(ce_i),                                    
	.start_i(start_i),                               
	.end_i(end_i),                                  
	.wr_i(wr_i),                                   
	.bytes_i(bytes_i),
	.error_i(error_i),                                
	.bitlen_o(bitlen_o),               
	.words_sel_o(words_sel_o),              
	.Kt_addr_o(Kt_addr_o),                 
	.sch_ld_o(sch_ld_o),                                      
	.core_ld_o(core_ld_o),                                     
	.oregs_ld_o(oregs_ld_o),                                   
	.sch_ce_o(sch_ce_o),                                       
	.core_ce_o(core_ce_o),                                      
	.oregs_ce_o(oregs_ce_o),                                  
	.bytes_ena_o(bytes_ena_o),               
	.one_insert_o(one_insert_o),                                 
	.di_req_o(di_req_o),                                       
	.data_valid_o(data_valid_o),                                 
	.error_o(error_o)

//	.data_valid(data_valid),
//	.hash_control_st_reg(hash_control_st_reg)   
*/                                    
    );  


endmodule
