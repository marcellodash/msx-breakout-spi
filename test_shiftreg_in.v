`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   17:50:10 06/15/2013
// Design Name:   shiftreg_in
// Module Name:   /home/dylan/ZXSPI/test_shiftreg_in.v
// Project Name:  ZXSPI
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: shiftreg_in
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module test_shiftreg_in;

	// Inputs
	reg reset;
	reg data_rq;
	reg read_rq;
	reg serclk;
	reg ser_in;
	reg clk;

	// Outputs
	wire [7:0] data;
	wire data_ready;
	wire busy;

	// Instantiate the Unit Under Test (UUT)
	shiftreg_in uut (
		.reset(reset), 
		.data(data), 
		.data_rq(data_rq), 
		.read_rq(read_rq), 
		.data_ready(data_ready), 
		.serclk(serclk), 
		.ser_in(ser_in), 
		.clk(clk),
		.busy(busy)
	);

	initial begin
		// Initialize Inputs
		reset = 0;
		data_rq = 0;
		read_rq = 0;
		serclk = 0;
		ser_in = 0;
		clk = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		read_rq=1;
		#100 read_rq=0;
		#400
		ser_in=1;
		#400
		ser_in=0;
		#400
		ser_in=1;
		#400
		ser_in=0;
		#400
		ser_in=1;
		#400
		ser_in=0;
		#400
		ser_in=1;
		#400
		ser_in=0;
		
		#200
		data_rq=1;
		
		#400
		data_rq=0;
		
		#200
		read_rq=1;
		#200
		read_rq=0;
		#200
		ser_in=0;
		#400
		ser_in=1;
		#400
		ser_in=0;
		#400
		ser_in=1;
		#400
		ser_in=0;
		#400
		ser_in=1;
		#400
		ser_in=0;	
		#400
		ser_in=1;
		
		#200
		data_rq=1;
		#400
		data_rq=0;

	end
	
	always
		#100 clk=!clk;
	always
		#200 serclk=!serclk;
      
endmodule

