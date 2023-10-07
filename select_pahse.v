`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    07:43:59 03/01/2022 
// Design Name: 
// Module Name:    select_pahse 
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
module select_phase(
    input clk,      //clock 800Hz
    input sel,      // middle button
    input [7: 0] seg,	//ships
    input [3: 0] an,		//battle fields
    output phase,	//phase
    output pships
    );
	
    reg [27: 0] pships = 0;
    reg [2: 0] sel_count = 0; 
    assign phase = (sel_count < 3'd4) ? 0: 1;

    always @ (posedge clk) begin
        if(sel && sel_count < 4 && phase == 0) begin
            sel_count <= sel_count + 1'b1;    //incr # of selections

            case (an)
                //first battle field
                    4'b1110: begin
                        case(seg)
                            8'b11111110: pships <= pships + (1'b1 << 1);
                            8'b11111101: pships <= pships + (1'b1 << 0);
                            8'b11111011: pships <= pships + (1'b1 << 4);
                            8'b11110111: pships <= pships + (1'b1 << 3);
                            8'b11101111: pships <= pships + (1'b1 << 2);
                            8'b11011111: pships <= pships + (1'b1 << 6);
                            8'b10111111: pships <= pships + (1'b1 << 5);
                        endcase
                    end
                //second battle field
                    4'b1101: begin
                        case(seg)
                            8'b11111110: pships <= pships + (1'b1 << 8);
                            8'b11111101: pships <= pships + (1'b1 << 7);
                            8'b11111011: pships <= pships + (1'b1 << 11);
                            8'b11110111: pships <= pships + (1'b1 << 10);
                            8'b11101111: pships <= pships + (1'b1 << 9);
                            8'b11011111: pships <= pships + (1'b1 << 13);
                            8'b10111111: pships <= pships + (1'b1 << 12);
                        endcase
                    end
                //third battle field
                    4'b1011: begin
                        case(seg)
                            8'b11111110: pships <= pships + (1'b1 << 15);
                            8'b11111101: pships <= pships + (1'b1 << 14);
                            8'b11111011: pships <= pships + (1'b1 << 18);
                            8'b11110111: pships <= pships + (1'b1 << 17);
                            8'b11101111: pships <= pships + (1'b1 << 16);
                            8'b11011111: pships <= pships + (1'b1 << 20);
                            8'b10111111: pships <= pships + (1'b1 << 19);
                        endcase
                    end
                
                //fourth battle field
                    4'b0111: begin
                        case(seg)
                            8'b11111110: pships <= pships + (1'b1 << 22);
                            8'b11111101: pships <= pships + (1'b1 << 21);
                            8'b11111011: pships <= pships + (1'b1 << 25);
                            8'b11110111: pships <= pships + (1'b1 << 24);
                            8'b11101111: pships <= pships + (1'b1 << 23);
                            8'b11011111: pships <= pships + (1'b1 << 27);
                            8'b10111111: pships <= pships + (1'b1 << 26);
                        endcase
                    end


            //     4'b1110: begin
            //         case(seg)
            //             8'b11111110: pships <= pships + (1'b1 << 0);
            //             8'b11111101: pships <= pships + (1'b1 << 1);
            //             8'b11111011: pships <= pships + (1'b1 << 2);
            //             8'b11110111: pships <= pships + (1'b1 << 3);
            //             8'b11101111: pships <= pships + (1'b1 << 4);
            //             8'b11011111: pships <= pships + (1'b1 << 5);
            //             8'b10111111: pships <= pships + (1'b1 << 6);
            //         endcase
            //     end
            // //second battle field
            //     4'b1101: begin
            //         case(seg)
            //             8'b11111110: pships <= pships + (1'b1 << 7);
            //             8'b11111101: pships <= pships + (1'b1 << 8);
            //             8'b11111011: pships <= pships + (1'b1 << 9);
            //             8'b11110111: pships <= pships + (1'b1 << 10);
            //             8'b11101111: pships <= pships + (1'b1 << 11);
            //             8'b11011111: pships <= pships + (1'b1 << 12);
            //             8'b10111111: pships <= pships + (1'b1 << 13);
            //         endcase
            //     end
            // //third battle field
            //     4'b1011: begin
            //         case(seg)
            //             8'b11111110: pships <= pships + (1'b1 << 14);
            //             8'b11111101: pships <= pships + (1'b1 << 15);
            //             8'b11111011: pships <= pships + (1'b1 << 16);
            //             8'b11110111: pships <= pships + (1'b1 << 17);
            //             8'b11101111: pships <= pships + (1'b1 << 18);
            //             8'b11011111: pships <= pships + (1'b1 << 19);
            //             8'b10111111: pships <= pships + (1'b1 << 20);
            //         endcase
            //     end
            
            // //fourth battle field
            //     4'b0111: begin
            //         case(seg)
            //             8'b11111110: pships <= pships + (1'b1 << 21);
            //             8'b11111101: pships <= pships + (1'b1 << 22);
            //             8'b11111011: pships <= pships + (1'b1 << 23);
            //             8'b11110111: pships <= pships + (1'b1 << 24);
            //             8'b11101111: pships <= pships + (1'b1 << 25);
            //             8'b11011111: pships <= pships + (1'b1 << 26);
            //             8'b10111111: pships <= pships + (1'b1 << 27);
            //         endcase
            //     end

            endcase     //end case (an)
        end     //end if (confirm) 
        
    end     //always

endmodule
