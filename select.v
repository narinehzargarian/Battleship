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
                    
                    //seg = 8'b11111110;      //first seg of next digit
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
                    
                    //seg = 8'b11111110;      //first seg of next digit
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

            //     case (seg)
            //     //first ship
            //         8'b11111110: begin
            //             seg <= 
            //             (btnR ? seg:
            //              btnL ? 8'b11111011:
            //              btnD ? seg:
            //              btnU ? 8'b11111101: seg); 
            //         end
            //     //second ship
            //         8'b11111101: begin
            //             seg <= 
            //             (btnR ? seg:
            //             btnL ? 8'b11110111:
            //             btnD ? 8'b11111110:
            //             btnU ? seg: seg); 
            //         end
            //     //third ship
            //     8'b11111011: begin
            //         seg <= 
            //         (btnR ? 8'b11111110:
            //          btnL ? 8'b11011111:
            //          btnD ? seg:
            //          btnU ? 8'b11110111: seg); 
            //     end
            //     //forth ship
            //     8'b11110111: begin
            //         seg <= 
            //         (btnR ? 8'b11111101:
            //          btnL ? 8'b10111111:
            //          btnD ? 8'b11111011:
            //          btnU ? 8'b11101111: seg); 
            //     end
            //     // //fifth ship
            //     // 8'b11101111: begin
            //     //     seg <= 
            //     //     (btnR ? 8'b11111101:
            //     //      btnL ? 8'b10111111:
            //     //      btnD ? 8'b11110111:
            //     //      btnU ? seg: seg); 
            //     // end

            //     // //sixth ship
            //      8'b11011111: begin
            //         seg <= 
            //         (btnR ? 8'b11111011:
            //          btnL ? (an <= 4'b1101):
            //          btnD ? seg:
            //          btnU ? 8'b10111111: seg); 
            //     end
            //     // //seventh ship
            //     // 8'b10111111: begin
            //     //     seg <= 
            //     //     (btnR ? 8'b11110111:
            //     //      btnL ? (an <= 4'b1101):
            //     //      btnD ? 8'b11011111:
            //     //      btnU ? seg: seg); 
            //     // end

            //     // default: seg <= seg;
            // endcase
    end
endmodule

/*
    set_selection (
        input clk,      //800 Hz
        input confirm,  //btn center
        input seg,
        input an,
        output pships,
        output chState      //change state 
    );
    reg [27: 0] pships = 0;
    reg [2: 0] conf_count = 0; 
    
    always @ (posedge clk) begin
        if(confirm && conf_count < 4) begin
            conf_count += 1;    //incr # of selections

            case (an)
            //first battle ground
                4'b1110: begin
                    case(seg)
                        8'b11111110: pships += 1'b1 << 0;
                        8'b11111101: pships += 1'b1 << 1;
                        8'b11111011: pships += 1'b1 << 2;
                        8'b11110111: pships += 1'b1 << 3;
                        8'b11101111: pships += 1'b1 << 4;
                        8'b11011111: pships += 1'b1 << 5;
                        8'b10111111: pships += 1'b1 << 6;
                    endcase
                end
            //second battle ground
                4'b1101: begin
                    case(seg)
                        8'b11111110: pships += 1'b1 << 7;
                        8'b11111101: pships += 1'b1 << 8;
                        8'b11111011: pships += 1'b1 << 9;
                        8'b11110111: pships += 1'b1 << 10;
                        8'b11101111: pships += 1'b1 << 11;
                        8'b11011111: pships += 1'b1 << 12;
                        8'b10111111: pships += 1'b1 << 13;
                    endcase
                end
            //third battle ground
                4'b1011: begin
                    case(seg)
                        8'b11111110: pships += 1'b1 << 14;
                        8'b11111101: pships += 1'b1 << 15;
                        8'b11111011: pships += 1'b1 << 16;
                        8'b11110111: pships += 1'b1 << 17;
                        8'b11101111: pships += 1'b1 << 18;
                        8'b11011111: pships += 1'b1 << 19;
                        8'b10111111: pships += 1'b1 << 20;
                    endcase
                end
            
            //fourth battle ground
                4'b0111: begin
                    case(seg)
                        8'b11111110: pships += 1'b1 << 21;
                        8'b11111101: pships += 1'b1 << 22;
                        8'b11111011: pships += 1'b1 << 23;
                        8'b11110111: pships += 1'b1 << 24;
                        8'b11101111: pships += 1'b1 << 25;
                        8'b11011111: pships += 1'b1 << 26;
                        8'b10111111: pships += 1'b1 << 27;
                    endcase
                end

            endcase     //end case (an)
        end     //end if (confirm) 
        
    end     //always

    assign
*/

/*
*/