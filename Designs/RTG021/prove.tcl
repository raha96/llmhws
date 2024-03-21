##################################################################
#### File Name: jg_spv.tcl
#### File for security path verification of a design 
###
###     Developed by 
###
###     Nusrat Farzna Dipu
###     Graduate Research Assistant
###     University of Florida
###     Email: ndipu@ufl.edu
###
####################################################################
# Analyze design under verification files
set ROOT_PATH [pwd]
set RTL_PATH ${ROOT_PATH}/src
set PROP_PATH ${ROOT_PATH}/properties


analyze -v2k \
	${RTL_PATH}/avalanche_entropy.v \
	${RTL_PATH}/chacha_core.v\
	${RTL_PATH}/chacha_qr.v \
	${RTL_PATH}/chacha.v \
	${RTL_PATH}/pseudo_entropy.v \
	${RTL_PATH}/rosc_entropy.v \
	${RTL_PATH}/sha512_core.v \
	${RTL_PATH}/sha512_h_constants.v \
	${RTL_PATH}/sha512_k_constants.v \
	${RTL_PATH}/sha512.v \
	${RTL_PATH}/sha512_w_mem.v \
	${RTL_PATH}/trng_csprng_fifo.v \
	${RTL_PATH}/trng_csprng.v \
	${RTL_PATH}/trng_debug_ctrl.v \
	${RTL_PATH}/trng_mixer.v \
	${RTL_PATH}/trng.v


# Analyze property files
analyze -sv09 \
 ${PROP_PATH}/v_trng.sva \
 ${PROP_PATH}/bindings.sva 
 
  
# Elaborate design and properties
elaborate -top trng
#elaborate

# Set up Clocks and Resets
clock clk
reset reset_n


# Get design information to check general complexity
get_design_info

# Prove properties
# 1st pass: Quick validation of properties with default engines
set_max_trace_length 10
prove -all
#
# 2nd pass: Validation of remaining properties with different engine
set_max_trace_length 50
set_prove_per_property_time_limit 30s
set_engine_mode {K I N} 
prove -all

# Report proof results
report 

