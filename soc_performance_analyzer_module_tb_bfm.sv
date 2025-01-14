`include "vunit_defines.svh"
import verbosity_pkg::*;
import avalon_mm_pkg::*;
import avalon_utilities_pkg::*;

`timescale 1 ns / 1ps

module BFM_tb;
    //Input
    logic Clk;
    logic Reset_n;
    logic   [8:0] ReadAddress;
    logic Read;
    logic Write;
    logic Select;

    // Outputs
    wire [31:0] ReadData;
    logic [31:0] WriteData;
    wire    ReadAck;
    wire    WriteAck;

assign Reset = ~Reset_n;

altera_avalon_mm_master_bfm
#(
    .AV_ADDRESS_W                (9), // Address width in bits
    .AV_SYMBOL_W                 (8),  // Data symbol width in bits
    .AV_NUMSYMBOLS               (4),  // Number of symbols per word
    .AV_BURSTCOUNT_W             (3),  // Burst port width in bits
    .AV_READRESPONSE_W           (0),
    .AV_WRITERESPONSE_W          (0),   
    .USE_READ                    (1),  // Use read pin on interface
    .USE_WRITE                   (0),  // Use write pin on interface
    .USE_ADDRESS                 (1),  // Use address pins on interface
    .USE_BYTE_ENABLE             (0),  // Use byte_enable pins on interface
    .USE_BURSTCOUNT              (0),  // Use burstcount pin on interface 
    .USE_READ_DATA               (1),  // Use readdata pin on interface 
    .USE_READ_DATA_VALID         (0),  // Use readdatavalid pin on interface
    .USE_WRITE_DATA              (0),  // Use writedata pin on interface   
    .USE_BEGIN_TRANSFER          (0),  // Use begintransfer pin on interface
    .USE_BEGIN_BURST_TRANSFER    (0),  // Use beginbursttransfer pin on interface
    .USE_WAIT_REQUEST            (0),  // Use waitrequest pin on interface
    .USE_ARBITERLOCK             (0),  // Use arbiterlock pin on interface
    .USE_LOCK                    (0),  // Use lock pin on interface
    .USE_DEBUGACCESS             (0),  // Use debugaccess pin on interface 
    .USE_TRANSACTIONID           (0),  // Use transactionid interface pin
    .USE_WRITERESPONSE           (0),  // Use write response interface pins
    .USE_READRESPONSE            (0),  // Use read response interface pins  
    .USE_CLKEN                   (0),  // Use NTCM interface pins  
    .AV_REGISTERINCOMINGSIGNALS  (0),  // Indicate that waitrequest is come from register 
    .AV_FIX_READ_LATENCY         (0),  // Fixed read latency in cycles
    .AV_MAX_PENDING_READS        (0),
    .AV_BURST_LINEWRAP           (0),  
    .AV_BURST_BNDR_ONLY          (0),  // Assert Addr alignment
    .AV_CONSTANT_BURST_BEHAVIOR  (1),  // Address, burstcount, transaction                                 // avm_writeresponserequest need to be held co                                 // in burst transaction
    .AV_READ_WAIT_TIME           (3),  // Fixed wait time cycles when
    .AV_WRITE_WAIT_TIME          (0),  // USE_WAIT_REQ
    .REGISTER_WAITREQUEST        (0),  // Waitrequest is registered at 
    .VHDL_ID                     (0),  // VHDL BFM ID number
    .PRINT_HELLO                 (1)   // To enable the printing of __hello message
)
avalon_master_rd 
(
    .clk(Clk),
    .reset(Reset),
    .avm_waitrequest(),
    .avm_readdatavalid(ReadAck),
    .avm_readdata(ReadData),
    .avm_write(),         
    .avm_read(Read),
    .avm_address(ReadAddress),
    .avm_byteenable(),   
    .avm_burstcount(),
    .avm_beginbursttransfer(),
    .avm_begintransfer(),   
    .avm_writedata(),
    .avm_lock(),
    .avm_transactionid(),
    .avm_readresponse(),
    .avm_readid(),
    .avm_writeresponserequest(),
    .avm_writeresponsevalid(),
    .avm_writeresponse(),
    .avm_response(),
    .avm_clken(),
    .avm_arbiterlock(),
    .avm_debugaccess(),
    .avm_writeid()
);


altera_avalon_mm_master_bfm
#(
    .AV_ADDRESS_W                (0), // Address width in bits
    .AV_SYMBOL_W                 (8),  // Data symbol width in bits
    .AV_NUMSYMBOLS               (4),  // Number of symbols per word
    .AV_BURSTCOUNT_W             (3),  // Burst port width in bits
    .AV_READRESPONSE_W           (0),
    .AV_WRITERESPONSE_W          (8),   
    .USE_READ                    (0),  // Use read pin on interface
    .USE_WRITE                   (1),  // Use write pin on interface
    .USE_ADDRESS                 (0),  // Use address pins on interface
    .USE_BYTE_ENABLE             (0),  // Use byte_enable pins on interface
    .USE_BURSTCOUNT              (0),  // Use burstcount pin on interface 
    .USE_READ_DATA               (0),  // Use readdata pin on interface 
    .USE_READ_DATA_VALID         (0),  // Use readdatavalid pin on interface
    .USE_WRITE_DATA              (1),  // Use writedata pin on interface   
    .USE_BEGIN_TRANSFER          (0),  // Use begintransfer pin on interface
    .USE_BEGIN_BURST_TRANSFER    (0),  // Use beginbursttransfer pin on interface
    .USE_WAIT_REQUEST            (0),  // Use waitrequest pin on interface
    .USE_ARBITERLOCK             (0),  // Use arbiterlock pin on interface
    .USE_LOCK                    (0),  // Use lock pin on interface
    .USE_DEBUGACCESS             (0),  // Use debugaccess pin on interface 
    .USE_TRANSACTIONID           (0),  // Use transactionid interface pin
    .USE_WRITERESPONSE           (0),  // Use write response interface pins
    .USE_READRESPONSE            (0),  // Use read response interface pins  
    .USE_CLKEN                   (0),  // Use NTCM interface pins  
    .AV_REGISTERINCOMINGSIGNALS  (0),  // Indicate that waitrequest is come from register 
    .AV_FIX_READ_LATENCY         (0),  // Fixed read latency in cycles
    .AV_MAX_PENDING_READS        (0),
    .AV_BURST_LINEWRAP           (0),  
    .AV_BURST_BNDR_ONLY          (0),  // Assert Addr alignment
    .AV_CONSTANT_BURST_BEHAVIOR  (0),  // Address, burstcount, transaction                                 // avm_writeresponserequest need to be held co                                 // in burst transaction
    .AV_READ_WAIT_TIME           (0),  // Fixed wait time cycles when
    .AV_WRITE_WAIT_TIME          (0),  // USE_WAIT_REQ
    .REGISTER_WAITREQUEST        (0),  // Waitrequest is registered at 
    .VHDL_ID                     (0),  // VHDL BFM ID number
    .PRINT_HELLO                 (1)   // To enable the printing of __hello message
)
avalon_master_wr 
(
    .clk(Clk),
    .reset(Reset),
    .avm_waitrequest(),
    .avm_readdatavalid(),
    .avm_readdata(),
    .avm_write(Write),         
    .avm_read(),
    .avm_address(),
    .avm_byteenable(),   
    .avm_burstcount(),
    .avm_beginbursttransfer(),
    .avm_begintransfer(),   
    .avm_writedata(WriteData),
    .avm_lock(),
    .avm_transactionid(),
    .avm_readresponse(),
    .avm_readid(),
    .avm_writeresponserequest(),
    .avm_writeresponsevalid(),
    .avm_writeresponse(),
    .avm_response(),
    .avm_clken(),
    .avm_arbiterlock(),
    .avm_debugaccess(),
    .avm_writeid()
);

sk_module DUT
(
    .read_data		(ReadData),
    .read_address	(ReadAddress),
    .read			(Read),
    .write_data		(WriteData),
    .write			(Write),
    .clk			(Clk),
    .reset_n		(Reset_n)
);

localparam CLOCK_PERIOD = 25; // 25.0 ns = 40 MHz

reg [31:0] Data = 0;

initial 
    begin
        Clk = 0;
        forever 
            begin
            #(CLOCK_PERIOD / 2);
            Clk = ~Clk;
        end
    end

`TEST_SUITE begin
    `TEST_SUITE_SETUP begin
        $display("Testbench num.1");
        Reset_n = 0;
    end
    `TEST_CASE_SETUP begin
        $display("Starting new test case. Resetting DUT...");
        // Reset
        WaitClocks(10);
        Reset_n = 0;

        WaitClocks(10);
        Reset_n = 1;

        WaitClocks(3);
        $display("... done!");
    end

    `TEST_CASE("MM000") begin
        //write
        $display("Write message and read it");
        avalon_write(32'h0,32'hDEADBEEF);
        WaitClocks(5);
        avalon_write(32'h0,32'hFEEDFACE);   
        WaitClocks(5);
        avalon_write(32'h0,32'hBAADCAFE);   
        WaitClocks(5);
        //read
        avalon_read(32'h00000000, Data);
        $write("Data received: %08h\n", Data);

        avalon_read(32'h00000002, Data);
        $write("Data received: %08h\n", Data);

        avalon_read(32'h00000004, Data);
        $write("Data received: %08h\n", Data);
    end
end

task WaitClocks;
input integer numClocks;
begin : WaitClocksTask
    integer i;

    for(i=0;i<numClocks;i=i+1)
    begin
        @(posedge Clk);
    end

    #1;
end
endtask

    `WATCHDOG(100ms);

    // ============================================================
    // Tasks
    // ============================================================
    //
    // Avalon-MM single-transaction read and write procedures.
    //
    // ------------------------------------------------------------
    task avalon_write (
    // ------------------------------------------------------------
        input int  addr,
        input int    data
    );
    begin
    // Construct the BFM request
    avalon_master_wr.set_command_request(REQ_WRITE);
    avalon_master_wr.set_command_idle(0, 0);
    avalon_master_wr.set_command_init_latency(0);
    avalon_master_wr.set_command_address(addr);    
    avalon_master_wr.set_command_byte_enable('1,0);
    avalon_master_wr.set_command_data(data, 0);      
    // Queue the command
    avalon_master_wr.push_command();
    
    // Wait until the transaction has completed
    while (avalon_master_wr.get_response_queue_size() != 1)
        // @(posedge `CLK_BFM.clk);
        @(posedge Clk);
    // Dequeue the response and discard
    avalon_master_wr.pop_response();
    end
    endtask
            
    // ------------------------------------------------------------
    task avalon_read (
    // ------------------------------------------------------------
        input int   addr,
        output int    data
    );
    begin
    // Construct the BFM request
    avalon_master_rd.set_command_request(REQ_READ);
    avalon_master_rd.set_command_idle(0, 0);
    avalon_master_rd.set_command_init_latency(0);
    avalon_master_rd.set_command_address(addr);    
    avalon_master_rd.set_command_byte_enable('1,0);
    avalon_master_rd.set_command_data(0, 0);      
    // Queue the command
    avalon_master_rd.push_command();
    
    // Wait until the transaction has completed
    while (avalon_master_rd.get_response_queue_size() != 1)
        // @(posedge `CLK_BFM.clk);
        @(posedge Clk);
    // Dequeue the response and return the data
    avalon_master_rd.pop_response();
    data = avalon_master_rd.get_response_data(0);   
    end
    endtask


endmodule