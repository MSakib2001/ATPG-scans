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

# Exclude flops from scan chain but keep them as DFFs
set_scan_element false {addr_reg[0] addr_reg[1] addr_reg[2] addr_reg[3] 
                        reg0_reg[0] reg0_reg[1] reg0_reg[2] reg0_reg[3] reg0_reg[4] reg0_reg[5] reg0_reg[6] reg0_reg[7] reg0_reg[8] reg0_reg[9] reg0_reg[10] 
                        reg0_reg[11] reg0_reg[12] reg0_reg[13] reg0_reg[14] reg0_reg[15] reg0_reg[16] reg0_reg[17] reg0_reg[18] reg0_reg[19] reg0_reg[20] 
                        reg0_reg[21] reg0_reg[22] reg0_reg[23] reg0_reg[24] reg0_reg[25] reg0_reg[26] reg0_reg[27] reg0_reg[28] reg0_reg[29]
                        reg1_reg[0] reg1_reg[1] reg1_reg[2] reg1_reg[3] reg1_reg[4] reg1_reg[5] reg1_reg[6] reg1_reg[7] reg1_reg[8] reg1_reg[9] reg1_reg[10]
                        reg2_reg[0] reg2_reg[1] reg2_reg[2] reg2_reg[3] reg2_reg[4] reg2_reg[5] reg2_reg[6] reg2_reg[7] reg2_reg[8] reg2_reg[9] reg2_reg[10]
                        reg3_reg[0] reg3_reg[1] reg3_reg[2] reg3_reg[3] reg3_reg[4] reg3_reg[5] reg3_reg[6] reg3_reg[7] reg3_reg[8] reg3_reg[9] reg3_reg[10]
                        }

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
report_area > reports/area_p_b14.rpt
report_timing > reports/timing_p_b14.rpt
report_power > reports/power_b14.rpt
report_scan_path -view existing_dft -chain all > reports/chain_p_b14.rep
report_scan_path -view existing_dft -cell all > reports/cell_p_b14.rep

# ----------------------------------------
# Output files
# ----------------------------------------
change_names -hierarchy -rule verilog
write -format verilog -hierarchy -out results/b14_pscan.vg
write -format ddc -hierarchy -output results/b14_pscan.ddc
write_scan_def -output results/b14_pscan.def

set test_stil_netlist_format verilog
#set test_protocol_style full_scan
write_test_protocol -output results/b14_pscan.stil
