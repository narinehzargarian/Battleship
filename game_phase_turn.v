`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    05:04:39 03/10/2022 
// Design Name: 
// Module Name:    game_phase_turn 
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
module game_phase(
    input clk,
    input sel,      // middle button
	 input sw,
	input rst,
	input phase,		// 0=select, 1=game
    input [7: 0] seg,	//ships
    input [3: 0] an,		//battle fields
    output reg [27: 0] pships = 0, // actually represents pguess
    output reg [27: 0] sing_guess = 0
    );
    reg [4: 0] sel_count = 0; 

    always @ (posedge clk or posedge rst) begin
		if (rst) begin
				sel_count <= 0;
        end else if(!sw && sel && phase) begin
            sel_count <= sel_count + 1'b1;    //incr # of selections

            case (an)
                //first battle field
                    4'b1110: begin
                        case(seg)
                            8'b11111110: begin
                                pships <= pships | (1'b1 << 1);
                                sing_guess <= 28'd0 | (1'b1 << 1);
                            end
                            8'b11111101: begin 
                                pships <= pships | (1'b1 << 0);
                                sing_guess <= 28'd0 | (1'b1 << 0);
                            end
                            8'b11111011: begin 
                                pships <= pships | (1'b1 << 4);
                                sing_guess <=  28'd0 | (1'b1 << 4);
                            end
                            8'b11110111: begin
                                pships <= pships | (1'b1 << 3);
                                sing_guess <= 28'd0 | (1'b1 << 3);
                            end
                            8'b11101111: begin
                                pships <= pships | (1'b1 << 2);
                                sing_guess <= 28'd0 | (1'b1 << 2);
                            end
                            8'b11011111: begin
                                pships <= pships | (1'b1 << 6);
                                sing_guess <= 28'd0 | (1'b1 << 6);
                            end
                            8'b10111111: begin
                                pships <= pships | (1'b1 << 5);
                                sing_guess <= 28'd0 | (1'b1 << 5);
                            end
                        endcase
                    end
                //second battle field
                    4'b1101: begin
                        case(seg)
                            8'b11111110: begin
                                pships <= pships | (1'b1 << 8);
                                sing_guess <= 28'd0 | (1'b1 << 5);
                            end
                            8'b11111101: begin
                                pships <= pships | (1'b1 << 7);
                                sing_guess <= 28'd0 | (1'b1 << 7);
                            end
                            8'b11111011: begin
                                pships <= pships | (1'b1 << 11);
                                sing_guess <= 28'd0 | (1'b1 << 11);
                            end
                            8'b11110111: begin 
                                pships <= pships | (1'b1 << 10);
                                sing_guess <= 28'd0 | (1'b1 << 10);
                            end
                            8'b11101111: begin
                                pships <= pships | (1'b1 << 9);
                                sing_guess <= 28'd0 | (1'b1 << 9);
                            end
                            8'b11011111: begin 
                                pships <= pships | (1'b1 << 13);
                                sing_guess <= 28'd0 | (1'b1 << 13);
                            end
                            8'b10111111: begin
                                pships <= pships | (1'b1 << 12);
                                sing_guess <= 28'd0 | (1'b1 << 12);
                            end
                        endcase
                    end
                //third battle field
                    4'b1011: begin
                        case(seg)
                            8'b11111110: begin
                                pships <= pships | (1'b1 << 15);
                                sing_guess <= 28'd0 | (1'b1 << 15);
                            end
                            8'b11111101: begin
                                pships <= pships | (1'b1 << 14);
                                sing_guess <= 28'd0 | (1'b1 << 14);
                            end
                            8'b11111011: begin
                                pships <= pships | (1'b1 << 18);
                                sing_guess <= 28'd0 | (1'b1 << 18);
                            end
                            8'b11110111: begin
                                pships <= pships | (1'b1 << 17);
                                sing_guess <= 28'd0 | (1'b1 << 17);
                            end
                            8'b11101111: begin 
                                pships <= pships | (1'b1 << 16);
                                sing_guess <= 28'd0 | (1'b1 << 16);
                            end
                            8'b11011111: begin
                                pships <= pships | (1'b1 << 20);
                                sing_guess <= 28'd0 | (1'b1 << 20);
                            end
                            8'b10111111: begin
                                pships <= pships | (1'b1 << 19);
                                sing_guess <= 28'd0 | (1'b1 << 19);
                            end
                        endcase
                    end
                
                //fourth battle field
                    4'b0111: begin
                        case(seg)
                            8'b11111110: begin 
                                pships <= pships | (1'b1 << 22);
                                sing_guess <= 28'd0 | (1'b1 << 22);
                            end
                            8'b11111101: begin
                                pships <= pships | (1'b1 << 21);
                                sing_guess <= 28'd0 | (1'b1 << 21);
                            end
                            8'b11111011: begin
                                pships <= pships | (1'b1 << 25);
                                sing_guess <= 28'd0 | (1'b1 << 25);
                            end
                            8'b11110111: begin
                                pships <= pships | (1'b1 << 24);
                                sing_guess <= 28'd0 | (1'b1 << 24);
                            end
                            8'b11101111: begin
                                pships <= pships | (1'b1 << 23);
                                sing_guess <= 28'd0 | (1'b1 << 23);
                            end
                            8'b11011111: begin
                                pships <= pships | (1'b1 << 27);
                                sing_guess <=  28'd0 | (1'b1 << 27);
                            end
                            8'b10111111: begin 
                                pships <= pships | (1'b1 << 26);
                                sing_guess <= 28'd0 | (1'b1 << 26);
                            end
                        endcase
                    end

            endcase     //end case (an)
				
        end     //end if (confirm) 
        
    end     //always



endmodule
