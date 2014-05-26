`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:59:36 06/15/2013 
// Design Name: 
// Module Name:    zxspi 
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
//////////////////////////////////////////////////////////////////////////////////
module zxspi(
    input reset,
    input clk,
    input rd_L,
    input wr_L,
    input iorq_L,
    input m1_L,
    input [15:0] a,
    inout [7:0] d,
    output spi_clk,
    output mosi,
    input miso,
    output [3:0] spi_cs
	 
    );

	wire spi_select;			// IORQ for SPI write or read
	wire spi_write;			// IORQ for SPI write
	wire spi_read;				// IORQ for SPI received buffer read
	wire config_select;		// IORQ for config read or write
	wire [3:0] serclk_speed;	// Speed of SPI clock
	wire serclk_polarity;	// SPI clock polarity
	wire serclk;				// serial clock
	wire spi_writing;			// 1 = currently reading SPI
	wire spi_start_read;		// Signal start reading from SPI.
	reg [1:0] spi_cs_reg;	// SPI chip selects
	wire [3:0] spi_cs_demuxed;		// SPI chip selects demultiplexed: active low
	
	assign spi_write=spi_select | wr_L;		// Active low
	assign spi_read=spi_select | rd_L;		// Active low
	assign spi_cs=spi_writing ? spi_cs_demuxed : 4'b1111;
	assign d[7]=(config_select | rd_L) ? 1'bZ : spi_writing;
	assign d[6:5]=(config_select | rd_L) ? 2'bZZ : spi_cs_reg;
	assign spi_clk=serclk_polarity ? serclk | !spi_writing : !serclk & spi_writing;
	assign spi_start_read=config_select | wr_L | !d[5];
	
	assign spi_cs_demuxed = (spi_cs_reg==2'b00) ? 4'b1110 :
	                        (spi_cs_reg==2'b01) ? 4'b1101 :
									(spi_cs_reg==2'b10) ? 4'b1011 :
									                      4'b0111;
	always @(posedge clk or posedge reset)
	begin
		if(reset)
			spi_cs_reg <= 0;
		else if(!(config_select | rd_L))
			spi_cs_reg <= d[6:5];
	end
	
	iodecoder iod (
		.iorq_L(iorq_L),
		.m1_L(m1_L),
		.a(a),
		.spi_select(spi_select),
		.config_select(config_select));
		
	config_register cfg (
		.reset(reset),
		.clk(clk),
		.rd_L(rd_L),
		.wr_L(wr_L),
		.config_select(config_select),
		.serclk_polarity_in(d[0]),
		.serclk_speed_in(d[4:1]),
		.serclk_polarity_bus_out(d[0]),
		.serclk_speed_bus_out(d[4:1]),
		.serclk_polarity_out(serclk_polarity),
		.serclk_speed_out(serclk_speed),
		.set_inhibit(d[5]));
		
	serclk_generator sgen (
		.reset(reset),
		.clk(clk),
		.speed_select(serclk_speed),
		.clkout(serclk));
		
	shiftreg_out sout (
		.reset(reset),
		.set_clk(clk),
		.set_enable(spi_write),
		.busy(spi_writing),
		.data_in(d),
		.serial_clk(serclk),
		.serial_out(mosi));
		
	// reads always happen simultaneously to a write so the
	// spi_writing indicator makes us read, too.
	shiftreg_in sin (
		.reset(reset),
		.data(d),
		.data_rq(spi_read),
		.enable(spi_writing),
		.serclk(serclk),
		.ser_in(miso));

endmodule
