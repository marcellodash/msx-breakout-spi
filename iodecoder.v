`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:35:49 06/15/2013 
// Design Name: 
// Module Name:    iodecoder 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
// Decode IO request.
//
//////////////////////////////////////////////////////////////////////////////////
module iodecoder(
    input iorq_L,
    input m1_L,
    input [15:0] a,
    output spi_select,
    output config_select
    );

	assign spi_select = (a == 16'h0406 & m1_L & !iorq_L) ? 0 : 1;
	assign config_select = (a == 16'h0506 & m1_L & !iorq_L) ? 0 : 1;

endmodule
