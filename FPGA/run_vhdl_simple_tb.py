#!/usr/bin/env python3

"""
sk_module test in VUnit framework
"""
from pathlib import Path
from vunit import VUnit

ROOT = Path(__file__).resolve().parent

# Sources path for DUT
DUT_PATH = ROOT / "sk_module"

# Sources path for TB
TEST_PATH = ROOT / "test_bench"

# create Vunit instance
vu = VUnit.from_argv()
vu.enable_location_preprocessing()

# # Create library 
design_lib = vu.add_library("design_lib")
# Add design files
design_lib.add_source_files([DUT_PATH / "sk_module.vhd"])

# # Create Testbench 
tb_lib = vu.add_library("tb_lib")
# Add tb files
tb_lib.add_source_files([TEST_PATH / "*.vhd"])

# Run vunit function
vu.main()