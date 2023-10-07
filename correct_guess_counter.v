`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    04:53:29 03/10/2022 
// Design Name: 
// Module Name:    correct_guess_counter 
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
module correct_guess_counter(
    input clk,      
    input sel,
    input phase,
    input sw,
    input [27: 0] c_curr_guess,
    input [27: 0] p_curr_guess,
    input [27: 0] cships,
    input [27: 0] pships,
    output finish
    );

    reg [2: 0] c_correct = 0;
    reg [2: 0] p_correct = 0;

    assign finish = (c_correct >= 4 || p_correct >= 4);

    always @(posedge clk) begin
        
        if(phase && sw && sel) begin 
            c_correct <= c_correct + |(pships & c_curr_guess);
        end
        
        else if(phase && sel && !sw) begin     //in the game mode
            p_correct <= p_correct + |(cships & p_curr_guess);
        end
    end

endmodule
