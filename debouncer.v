`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:09:43 02/28/2022 
// Design Name: 
// Module Name:    debouncer 
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
module dff(     //dff
    input clk, //clock 4Hz
    input D,    //input button
    output Q  
);
	 reg Q;
    always @(posedge clk) begin
        Q <= D;
    end
    
endmodule

module debouncer(
    input clk, //clock 4Hz
    input btn_in, 
    output btn_out
    );

    wire Q1, Q2, Q2_bar;
    dff dff1(
        .clk (clk),
        .D (btn_in),
        .Q (Q1)
    );
    dff dff2 (
        .clk (clk),
        .D (Q1),
        .Q (Q2)
    );
    assign Q2_bar  = ~Q2;
    assign btn_out = Q2_bar & Q1;

endmodule

