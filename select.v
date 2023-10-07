`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/27/2022 05:59:34 PM
// Design Name: 
// Module Name: select
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module select(
    input clk,
    input rst,
    input phase,     //mode
    input sel,      //select btn
    input btnU,     //up btn
    input btnD,     //down btn
    input btnR,     //right btn
    input btnL,     //left btn   
    output reg [3: 0] an,
    output reg [7: 0] seg,
    output [27:0] pships,
    output [27:0] cships
    );
    
    //count the selection
	reg [2: 0] sel_count;
    
    initial begin
        an = 4'b1110;
        seg = 8'b11111110;
        sel_count = 0;
    end
	 
    always @ (posedge clk) begin
        
            //first ship
            if (seg == 8'b11111110) begin
                if (btnR) begin
                    an <= (an == 4'b1110) ? 
                        4'b0111: (an >> 1'b1) | 4'd8;    //next right digit
                end
                else begin
                    seg <= 
                    (btnL ? 8'b11111011:
                    btnU ? 8'b11111101: seg);
                end
            end

            //second ship
            else if (seg == 8'b11111101) begin
                if (btnR) begin
                    an <= (an == 4'b1110) ? 
                        4'b0111: (an >> 1'b1) | 4'd8;    //next right digit
                end
                else begin
                    seg <= 
                    (btnL ? 8'b11110111:
                    btnD ? 8'b11111110: seg);
                end
                
            end

            //third ship
            else if (seg == 8'b11111011) begin
                seg <= 
                    (btnR ? 8'b11111110:
                    btnL? 8'b11011111:
                    btnU ? 8'b11110111: seg); 
            end
            //forth ship
            else if(seg == 8'b11110111) begin
                seg <= 
                    (btnR ? 8'b11111101:
                    btnL ? 8'b10111111:
                    btnD ? 8'b11111011:
                    btnU ? 8'b11101111: seg); 
            end

            //fifth ship
            else if (seg == 8'b11101111) begin
                seg <= 
                    (btnR ? 8'b11111101:
                    btnL ? 8'b10111111:
                    btnD ? 8'b11110111: seg);
            end
            //sixth ship
            else if (seg == 8'b11011111) begin
                if (btnL) begin
                    an <= (an == 4'b0111) ?
                        4'b1110: ((an << 1) | 1'b1);    //next digit
                end
                else begin
                    seg <= 
                        (btnR ? 8'b11111011:    
                        btnU ? 8'b10111111: seg);
                end
            end
            //seventh ship
            else if (8'b10111111) begin
                if (btnL) begin 
                    an <= (an == 4'b0111) ?
                        4'b1110: ((an << 1) | 1'b1);    //next digit
                end
                else begin
                    seg <= 
                        (btnR ? 8'b11110111:
                        btnD ? 8'b11011111: seg);
                end
            end
            else begin
                seg <= seg;
            end

    end
endmodule
