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
  ${RTL_PATH}/sha512_core.v \
  ${RTL_PATH}/sha512_h_constants.v \
  ${RTL_PATH}/sha512_k_constants.v \
  ${RTL_PATH}/sha512_w_mem.v


# Analyze property files
analyze -sva \
 ${PROP_PATH}/v_sha512_core.sva \
 ${PROP_PATH}/bindings.sva

 
  
# Elaborate design and properties
elaborate -top sha512_core
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

