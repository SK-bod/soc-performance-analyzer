#!/usr/bin/env python3

"""
soc_performance_analyzer_module test in VUnit framework
"""
from pathlib import Path
from vunit import VUnit
import os 

ROOT = Path(__file__).resolve().parent

# Sources path for DUT
DUT_PATH = ROOT / "soc-performance-analyzer-module"

# Sources path for TB
TEST_PATH = ROOT / "testbench"

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
tb_lib.add_source_files([TEST_PATH / "soc_performance_analyzer_module_tb.sv"])


# Run vunit function
vu.main()
