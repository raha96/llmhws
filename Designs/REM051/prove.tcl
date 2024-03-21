# Analyze design under verification files
set ROOT_PATH [pwd]
set RTL_PATH ${ROOT_PATH}/src
set PROP_PATH ${ROOT_PATH}/properties

#clear

analyze -vhdl ${RTL_PATH}/sha256_control.vhd
#analyze -vhdl	${RTL_PATH}/gv_sha256.vhd

# Analyze property files
analyze -sva  ${PROP_PATH}/v_sha256_control.sv
analyze -sva ${PROP_PATH}/bindings.sv

  
# Elaborate design and properties
#elaborate -top sha256_control
elaborate -vhdl -top {sha256_control}
#elaborate

# Set up Clocks and Resets
clock clk_i
reset -none -non_resettable_regs 0
#reset {rstN = "0"}

# Get design information to check general complexity
get_design_info

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

