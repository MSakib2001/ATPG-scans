# =====================================================
# Load design
# =====================================================
read_netlist results/b14_pscan.vg 
read_netlist /cae/apps/data/saed32_edk-2023/lib/stdcell_lvt/verilog/saed32nm_lvt.v

# =====================================================
# Build design
# =====================================================
run_build_model b14


# =====================================================
# Check design rule
# =====================================================
set_drc results/b14_fullscan.stil

run_drc

# =====================================================
# Add stuck-at faults for ATPG
# =====================================================
add_faults -all

# =====================================================
# Configure ATPG options
# =====================================================
set_atpg -abort_limit 300
set_atpg -merge high

# =====================================================
# Optional: Use random patterns before deterministic ATPG
# =====================================================
set_random_patterns -length 100


# =====================================================
# Show fault coverage
# =====================================================
set_faults -fault_coverage

# =====================================================
# Run ATPG
# =====================================================
run_atpg -auto_compression


# =====================================================
# Write patterns
# =====================================================
write_patterns b14_pattern_pscan.v -internal -format binary
