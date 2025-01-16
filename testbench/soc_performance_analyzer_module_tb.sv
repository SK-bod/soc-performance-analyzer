`include "vunit_defines.svh"

module tb_soc_module;

    localparam integer clk_period = 10;

    logic [31:0]read_data;
    logic [8:0]read_address = 9'b000000000;
    logic read = 1'b0;

    logic [31:0]write_data;
    logic write = 1'b0;

    logic clk = 1'b0;
    logic reset_n = 1'b0;

    soc_performance_analyzer_module dut_soc_module(.read_data(read_data), .read_address(read_address),
    .read(read), .write_data(write_data), .write(write), .clk(clk), .reset_n(reset_n));

   `TEST_SUITE begin
        #5ns 
        reset_n <= 1'b1;
        `TEST_CASE("test_case_check_write_signal") begin
            $display("Hello world");    
            //set address
            write_data <= 32'hAAAAAAAA;
            read_address <= 9'b000000000;
            //write
            #40ns
            @(negedge clk);
            write <= 1'b1;
            @(negedge clk);
            write <= 1'b0;
            //read
            #40ns
            @(negedge clk);
            read <= 1'b1;
            @(negedge clk);
            read <= 1'b0;
            //set address
            write_data <= 32'hBBBBBBBB;
            read_address <= 9'b000000010;
            //write
            #20ns
            @(negedge clk);
            write <= 1'b1;
            @(negedge clk);
            write <= 1'b0;
            //read
            #20ns
            @(negedge clk);
            read <= 1'b1;
            @(negedge clk);
            read <= 1'b0;
            //set address
            write_data <= 32'hCCCCCCCC;
            read_address <= 9'b000000100;
            //write
            #20ns
            @(negedge clk);
            write <= 1'b1;
            @(negedge clk);
            write <= 1'b0;
            //read
            #20ns
            @(negedge clk);
            read <= 1'b1;
            @(negedge clk);
            read <= 1'b0;
        end
   end

    
   `WATCHDOG(400ns);

    always begin
        #(clk_period/2 * 1ns);
        clk <= !clk;
   end


endmodule 
