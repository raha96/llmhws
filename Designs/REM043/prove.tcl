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

#clear

analyze -vhdl ${RTL_PATH}/RSA_binary.vhd
#analyze -vhdl	${RTL_PATH}/gv_sha256.vhd

# Analyze property files
analyze -sva  ${PROP_PATH}/v_RSA_binary.sv
analyze -sva ${PROP_PATH}/bindings.sv

  
# Elaborate design and properties
#elaborate -top sha256_control
elaborate -vhdl -top {RSA_binary}
#elaborate

# Set up Clocks and Resets
clock clk
#reset -none
reset -none -non_resettable_regs 1
#reset {rstN = "0"}

# Get design information to check general complexity
get_design_info

#visualize -force {(FSM = s_aes_binary.WAIT_KEY)} {1:1} -name viz_conf:0
#visualize -extract_conf -reason -transitive {FSM {1}} 1:$ -name viz_conf:0 -window {Reset Analysis}
#visualize -extract_conf -reason -transitive {round_index {1}} 1:$ -name viz_conf:0 -window {Reset Analysis}

# Prove properties
# 1st pass: Quick validation of properties with default engines
set_max_trace_length 10
prove -all
#
# 2nd pass: Validation of remaining properties with different engine
set_max_trace_length 200
set_prove_per_property_time_limit 30s
set_engine_mode {K I N} 
prove -all

# Report proof results
report

