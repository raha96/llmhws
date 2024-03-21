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

analyze -verilog \
  ${RTL_PATH}/write_once_register.v

# Analyze property files
analyze -sv09 \
 ${PROP_PATH}/v_write_once.sva \
 ${PROP_PATH}/bindings.sva 
 
  
# Elaborate design and properties
elaborate -top register_write_once_example
#elaborate

# Set up Clocks and Resets
clock Clk
reset ip_resetn

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

