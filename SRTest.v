`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   21:42:12 06/14/2013
// Design Name:   shiftreg_out
// Module Name:   /home/dylan/ZXSPI/SRTest.v
// Project Name:  ZXSPI
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: shiftreg_out
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module SRTest;

	// Inputs
	reg serial_clk;
	reg reset;
	reg set_enable;
	reg set_clk;
	reg [7:0] data_in;

	// Outputs
	wire serial_out;
	wire serial_clk_out;
	wire busy;

	// Instantiate the Unit Under Test (UUT)
	shiftreg_out uut (
		.serial_clk(serial_clk), 
		.serial_out(serial_out),
		.busy(busy), 
		.reset(reset), 
		.set_enable(set_enable), 
		.set_clk(set_clk), 
		.data_in(data_in)
	);

	initial begin
		// Initialize Inputs
		serial_clk = 0;
		reset = 1;
		set_enable = 1;
		set_clk = 0;
		data_in = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		#1000 reset=0;
		#100 data_in=8'hF1;
		set_enable=0;
		#800 set_enable=1;
		#25000 data_in=8'hA5;
		#100 set_enable=0;
		#400 set_enable=1;
	end
	
		always
			#100 set_clk=!set_clk;
		always
			#200 serial_clk=!serial_clk;
			
      
endmodule

