# soc-performance-analyzer
soc-performance-analyzer is a FPGA module that can be used for  registration of events with their time stamp, triggered by a single write instruction to a specific space location address. It is used to measure algorithm execution time in hard processor system (HPS).  The module is written for CYCLONE V SoC, and is tested on DE0-Nano-SoC.

The module is based on DPRAM with two ports, port_A to read only (Avalon-mm slave ), and port_B (Avalon-mm slave 1) to write only. Schematics used for this module is presented below:
![soc_performance_analyzer_module](https://github.com/user-attachments/assets/42f5cbda-fd70-4a98-a600-55756b01cf68)

RAM_ADDRESS_WIDTH_B_IN is generic used to set the whole module, dependency between this and RAM_WORD_A (amount of words to store in module) is presented below:

RAM_WORDS_A = 2^RAM_ADDRESS_WIDTH_B_IN
