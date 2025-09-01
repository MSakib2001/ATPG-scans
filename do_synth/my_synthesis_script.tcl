# my_synthesis_script.tcl

# ----------------------------------------
# Read the RTL (comment out to allow schematic browsing manually)
# ----------------------------------------
# read_file -format vhdl {/filespace/s/msakib/ece553/dft/rtl/my_adder.vhd}

# ----------------------------------------
# Initial compile (basic synthesis)
# ----------------------------------------
#compile


# ----------------------------------------
# DFT signals (full scan mode)
# ----------------------------------------
set_scan_configuration -style multiplexed_flip_flop
set_scan_configuration -chain_count 2
set_scan_configuration -clock_mixing no_mix
#set_scan_element false {dta_int_reg_7_ dta_int_reg_6_ dta_int_reg_5_}
set test_default_period 100
set_dft_signal -view existing_dft -type ScanClock -timing {45 55} -port clk
set_dft_signal -view existing_dft -type Reset -active_state 0 -port rstn

set_dft_signal -view spec -type ScanDataIn -port SERIAL_IN
set_dft_signal -view spec -type ScanDataOut -port SERIAL_OUT
set_dft_signal -view spec -type ScanEnable -port SCAN_EN -active_state 1

set_dft_signal -view spec -type ScanDataIn -port SERIAL_IN2
set_dft_signal -view spec -type ScanDataOut -port SERIAL_OUT2
set_dft_signal -view spec -type ScanEnable -port SCAN_EN2 -active_state 1

compile

create_test_protocol


# ----------------------------------------
#DFT Preview and DRC
# ----------------------------------------
preview_dft
dft_drc

# ----------------------------------------
# Scan chain configuration
# ----------------------------------------

set_scan_path chain1 -scan_data_in SERIAL_IN -scan_data_out SERIAL_OUT
set_scan_path chain2 -scan_data_in SERIAL_IN2 -scan_data_out SERIAL_OUT2
# ----------------------------------------
# Create protocol & compile with scan
# ----------------------------------------

insert_dft
set_scan_state scan_existing

compile -scan

# ----------------------------------------
#Reports
# ----------------------------------------
report_area > reports/area.rpt
report_timing > reports/timing.rpt
report_power > reports/power_exclude.rpt
report_scan_path -view existing_dft -chain all > reports/chain.rep
report_scan_path -view existing_dft -cell all > reports/cell.rep

# ----------------------------------------
# Output files
# ----------------------------------------
change_names -hierarchy -rule verilog
write -format verilog -hierarchy -out results/my_adder_dft.vg
write -format ddc -hierarchy -output results/my_adder_dft.ddc
write_scan_def -output results/my_adder_scan.def

# Optional for TetraMAX
set test_stil_netlist_format verilog
