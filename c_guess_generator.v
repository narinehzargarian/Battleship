`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    02:45:42 03/03/2022 
// Design Name: 
// Module Name:    c_guess_generator 
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
module c_guess_generator
(    
    input clk,      //clk 4Hz
    input rst,
	input sel,
    input sw,       // sw = 1 is computer's turn (hit select)
	input phase,
    output reg [27: 0] comp_guess = 0,
    output reg [27: 0] sing_guess
);
    reg [27: 0] guess_0 = 28'd1 << 5;
    reg [27: 0] guess_1 = 28'd1 << 6;
    reg [27: 0] guess_2 = 28'd1 << 16;
    reg [27: 0] guess_3 = 28'd1 << 22;
    reg [27: 0] guess_4 = 28'd1 << 2;
    reg [27: 0] guess_5 = 28'd1 << 7;
    reg [27: 0] guess_6 = 28'd1 << 10;
    reg [27: 0] guess_7 = 28'd1 << 9;
    reg [27: 0] guess_8 = 28'd1 << 25;
    reg [27: 0] guess_9 = 28'd1 << 19;
    reg [27: 0] guess_10 = 28'd1 << 26;
    reg [27: 0] guess_11 = 28'd1 << 14;
    reg [27: 0] guess_12 = 28'd1 << 4;
    reg [27: 0] guess_13 = 28'd1 << 11;
    reg [27: 0] guess_14 = 28'd1 << 8;
    reg [27: 0] guess_15 = 28'd1 << 3;
    reg [27: 0] guess_16 = 28'd1 << 18;
    reg [27: 0] guess_17 = 28'd1 << 0;
    reg [27: 0] guess_18 = 28'd1 << 13;
    reg [27: 0] guess_19 = 28'd1 << 12;
    reg [27: 0] guess_20 = 28'd1 << 23;
    reg [27: 0] guess_21 = 28'd1 << 20;
    reg [27: 0] guess_22 = 28'd1 << 21;
    reg [27: 0] guess_23 = 28'd1 << 24;
    reg [27: 0] guess_24 = 28'd1 << 27;
    reg [27: 0] guess_25 = 28'd1 << 1;
    reg [27: 0] guess_26 = 28'd1 << 15;
    reg [27: 0] guess_27 = 28'd1 << 17;

    //guess counter
    reg [4:0] counter = 0;
    reg turn_comp;

	 
    always @ (posedge clk or posedge rst) begin
		if (rst) begin
			  counter <= 0;
        end else if (sw && sel && phase && counter < 5'd28) begin        //if in game phase

				 case (counter)
					  5'd0: begin
                          comp_guess <= comp_guess | guess_0;
                          sing_guess <= guess_0;
                      end
					  5'd1: begin
                          comp_guess <= comp_guess | guess_1;
                          sing_guess <= guess_1;
                      end
					  5'd2: begin
                          comp_guess <= comp_guess | guess_2;
                          sing_guess <= guess_2;
                      end
					  5'd3: begin
                          comp_guess <= comp_guess | guess_3;
                          sing_guess <= guess_3;
                      end
					  5'd4: begin
                          comp_guess <= comp_guess | guess_4;
                          sing_guess <= guess_4;
                      end
					  5'd5: begin 
                          comp_guess <= comp_guess | guess_5;
                          sing_guess <= guess_5;
                      end
					  5'd6: begin
                          comp_guess <= comp_guess | guess_6;
                          sing_guess <= guess_6;
                      end
					  5'd7: begin
                          comp_guess <= comp_guess | guess_7;
                          sing_guess <= guess_7;
                      end
					  5'd8: begin
                          comp_guess <= comp_guess | guess_8;
                          sing_guess <= guess_8;
                      end
					  5'd9: begin
                          comp_guess <= comp_guess | guess_9;
                          sing_guess <= guess_9;
                      end
					  5'd10: begin
                          comp_guess <= comp_guess | guess_10;
                          sing_guess <= guess_10;
                      end
					  5'd11: begin
                          comp_guess <= comp_guess | guess_11;
                          sing_guess <= guess_11;
                      end
					  5'd12: begin
                          comp_guess <= comp_guess | guess_12;
                          sing_guess <= guess_12;
								 end
					  5'd13: begin
                          comp_guess <= comp_guess | guess_13;
                          sing_guess <= guess_13;
                      end
					  5'd14: begin
                          comp_guess <= comp_guess | guess_14;
                          sing_guess <= guess_14;
                      end
					  5'd15: begin
                          comp_guess <= comp_guess | guess_15;
                          sing_guess <= guess_15;
                      end
					  5'd16: begin
                          comp_guess <= comp_guess | guess_16;
                          sing_guess <= guess_16;
                      end
					  5'd17: begin
                          comp_guess <= comp_guess | guess_17;
                          sing_guess <= guess_17;
                      end
					  5'd18: begin
                          comp_guess <= comp_guess | guess_18;
                          sing_guess <= guess_18;
                      end
					  5'd19: begin
                          comp_guess <= comp_guess | guess_19;
                          sing_guess <= guess_19;
                      end
					  5'd20: begin
                          comp_guess <= comp_guess | guess_20;
                          sing_guess <= guess_20;
                      end
					  5'd21: begin
                          comp_guess <= comp_guess | guess_21;
                          sing_guess <= guess_21;
                      end
					  5'd22: begin
                          comp_guess <= comp_guess | guess_22;
                          sing_guess <= guess_22;
                      end
					  5'd23: begin
                          comp_guess <= comp_guess | guess_23;
                          sing_guess <= guess_23;
                      end
					  5'd24: begin
                          comp_guess <= comp_guess | guess_24;
                          sing_guess <= guess_24;
                      end
					  5'd25: begin
                           comp_guess <= comp_guess | guess_25;
                           sing_guess <= guess_25;
                      end
					  5'd26: begin
                          comp_guess <= comp_guess | guess_26;
                          sing_guess <= guess_26;
                      end
					  5'd27: begin 
                          comp_guess <= comp_guess | guess_27;
                          sing_guess <= guess_27;
								end
				 endcase
				 
				 counter <= counter + 1;

        end     //if (phase)

    end     //always
endmodule
