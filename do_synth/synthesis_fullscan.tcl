# synthesis_fullscan.tcl

read_file -format vhdl ../rtl/b14.vhd
current_design b14

# ----------------------------------------
# Initial compile (basic synthesis)
# ----------------------------------------
compile


# ----------------------------------------
# DFT signals (full scan mode)
# ----------------------------------------
set_scan_configuration -style multiplexed_flip_flop
set test_default_period 100
set_dft_signal -view existing_dft -type ScanClock -timing {45 55} -port clock
set_dft_signal -view existing_dft -type Reset -active_state 1 -port reset

set_dft_signal -view spec -type ScanDataIn -port SERIAL_IN
set_dft_signal -view spec -type ScanDataOut -port SERIAL_OUT
set_dft_signal -view spec -type ScanEnable -port SCAN_EN -active_state 1
create_test_protocol

# Synthesize
compile -scan


# ----------------------------------------
#DFT Preview and DRC
# ----------------------------------------

dft_drc

# ----------------------------------------
# Scan chain configuration
# ----------------------------------------
set_scan_configuration -chain_count 1
set_scan_configuration -clock_mixing no_mix
set_scan_path chain1 -scan_data_in SERIAL_IN -scan_data_out SERIAL_OUT

# Insert DFT
insert_dft
set_scan_state scan_existing


# ----------------------------------------
#Reports
# ----------------------------------------
report_area > reports/area_b14.rpt
report_timing > reports/timing_b14.rpt
report_power > reports/power_b14.rpt
report_scan_path -view existing_dft -chain all > reports/chain_b14.rep
report_scan_path -view existing_dft -cell all > reports/cell_b14.rep

# ----------------------------------------
# Output files
# ----------------------------------------
change_names -hierarchy -rule verilog
write -format verilog -hierarchy -out results/b14_fullscan.vg
write -format ddc -hierarchy -output results/b14_fullscan.ddc
write_scan_def -output results/b14_fullscan.def

set test_stil_netlist_format verilog
set test_protocol_style full_scan
write_test_protocol -output results/b14_fullscan.stil
