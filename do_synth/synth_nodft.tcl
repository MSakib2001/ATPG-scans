read_file -format vhdl {../rtl/b14.vhd}

create_test_protocol

compile -scan

change_names -hierarchy -rule verilog

write -format verilog -hierarchy -out results/b14_nodft.vg
write -format ddc -hierarchy -output results/b14_nodft.ddc
write_scan_def -output results/b14_nodft.def
set test_stil_netlist_format verilog
write_test_protocol -output results/b14_nodft.stil

