`timescale 1ns / 1ps

module clockdiv(
	input wire clk,		//master clock: 50MHz
	input wire clr,		//asynchronous reset
	output wire dclk,		//pixel clock: 25MHz
	output wire segclk,	//7-segment clock: 381.47Hz
	output reg clock_4Hz,
	output reg clock_1Hz
	);

	// 17-bit counter variable
	reg [16:0] q;
	reg [25: 0] clk_cnt_4;
	reg [25: 0] clk_cnt_1;

	// Clock divider --
	// Each bit in q is a clock signal that is
	// only a fraction of the master clock.
	always @(posedge clk or posedge clr)
	begin
		// reset condition
		if (clr == 1) begin
			q <= 0; 
			clk_cnt_4 <= 0; 
			clk_cnt_1 <= 0;
		// increment counter by one
		end else begin
			q <= q + 1;
			clk_cnt_4 <= clk_cnt_4 + 1'b1;
			clk_cnt_1 <= clk_cnt_1 + 1'b1;
			if (clk_cnt_4 == 12500000) begin
            clk_cnt_4 <= 0;
            clock_4Hz <= ~clock_4Hz;
			end
			
			if (clk_cnt_1 == 50000000) begin
            clk_cnt_1 <= 0;
            clock_1Hz <= ~clock_1Hz;
			end
		end
	end

	// 50Mhz: 2^17 = 381.47Hz
	assign segclk = q[16];

	// 50Mhz: 2^1 = 25MHz
	assign dclk = q[1];

endmodule
