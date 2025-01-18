#!/usr/bin/env python3

"""
sk_module test in VUnit framework
"""
import os
from pathlib import Path
from vunit import VUnit

ROOT = Path(__file__).resolve().parent

# Sources path for DUT
DUT_PATH = ROOT / "soc-performance-analyzer-module"

# Sources path for TB
TEST_PATH = ROOT / "testbench"

HOME = Path.home()

# create Vunit instance
vu = VUnit.from_argv()
#vu.enable_location_preprocessing()

vu.add_verilog_builtins()

# Adding BFM
altera_avalon_bfm = vu.add_library("altera_avalon_bfm")
SopcBuilderIpBase = os.path.join(HOME,"intelFPGA_lite","18.1", "ip", "altera", "sopc_builder_ip", "verification")
altera_avalon_bfm.add_source_file(os.path.join(SopcBuilderIpBase, "altera_avalon_mm_slave_bfm", "altera_avalon_mm_slave_bfm.sv"))
altera_avalon_bfm.add_source_file(os.path.join(SopcBuilderIpBase, "altera_avalon_mm_master_bfm", "altera_avalon_mm_master_bfm.sv"))
altera_avalon_bfm.add_source_file(os.path.join(SopcBuilderIpBase, "altera_avalon_st_sink_bfm", "altera_avalon_st_sink_bfm.sv"))
altera_avalon_bfm.add_source_file(os.path.join(SopcBuilderIpBase, "altera_avalon_st_source_bfm", "altera_avalon_st_source_bfm.sv"))
altera_avalon_bfm.add_source_file(os.path.join(SopcBuilderIpBase, "lib", "avalon_mm_pkg.sv"))
altera_avalon_bfm.add_source_file(os.path.join(SopcBuilderIpBase, "lib", "avalon_utilities_pkg.sv"))
altera_avalon_bfm.add_source_file(os.path.join(SopcBuilderIpBase, "lib", "verbosity_pkg.sv"))

# # Create library 
# design_lib = vu.add_library("design_lib")
# Add design files
altera_avalon_bfm.add_source_files([DUT_PATH / "soc_performance_analyzer_module.vhd"])


# Add tb files
altera_avalon_bfm.add_source_files([TEST_PATH / "soc_performance_analyzer_module_tb_bfm.sv"])


# Run vunit function
vu.main()
