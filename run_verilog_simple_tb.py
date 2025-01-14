#!/usr/bin/env python3

"""
soc_performance_analyzer_module test in VUnit framework
"""
from pathlib import Path
from vunit import VUnit
import os 

ROOT = Path(__file__).resolve().parent

# Sources path for DUT
DUT_PATH = ROOT / "soc_performance_analyzer_module"

# Sources path for TB
TEST_PATH = ROOT / "test_bench"

# create Vunit instance
vu = VUnit.from_argv()
vu.add_verilog_builtins()
vu.enable_location_preprocessing()

# # Create library 
design_lib = vu.add_library("design_lib")
# Add design files
design_lib.add_source_files([DUT_PATH / "soc_performance_analyzer_module.vhd"])

# # Create Testbench 
tb_lib = vu.add_library("tb_lib")
# Add tb files
tb_lib.add_source_files([TEST_PATH / "*.sv"])

altera_avalon_bfm = vu.add_library("altera_avalon_bfm")
SopcBuilderIpBase = os.path.join("D:\intelFPGA_lite","18.1", "ip", "altera", "sopc_builder_ip", "verification")
altera_avalon_bfm.add_source_file(os.path.join(SopcBuilderIpBase, "altera_avalon_mm_slave_bfm", "altera_avalon_mm_slave_bfm.sv"))
altera_avalon_bfm.add_source_file(os.path.join(SopcBuilderIpBase, "altera_avalon_mm_master_bfm", "altera_avalon_mm_master_bfm.sv"))
altera_avalon_bfm.add_source_file(os.path.join(SopcBuilderIpBase, "altera_avalon_st_sink_bfm", "altera_avalon_st_sink_bfm.sv"))
altera_avalon_bfm.add_source_file(os.path.join(SopcBuilderIpBase, "altera_avalon_st_source_bfm", "altera_avalon_st_source_bfm.sv"))
altera_avalon_bfm.add_source_file(os.path.join(SopcBuilderIpBase, "lib", "avalon_mm_pkg.sv"))
altera_avalon_bfm.add_source_file(os.path.join(SopcBuilderIpBase, "lib", "avalon_utilities_pkg.sv"))
altera_avalon_bfm.add_source_file(os.path.join(SopcBuilderIpBase, "lib", "verbosity_pkg.sv"))

# Run vunit function
vu.main()
