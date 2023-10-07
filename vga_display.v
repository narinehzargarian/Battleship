`timescale 1ns / 1ps

module vga640x480(
	input clk,		//pixel clock: 25MHz
	input phase,			//mode of the game
    input finish,
	input rst,			//asynchronous reset
	input [27: 0] pships,		//player's ships pos
	input [27: 0] cships,		//computer's ships pos
	input [27: 0] pguess,		//players guess
	input [27: 0] cguess,		//computers guess
	output hsync,		//horizontal sync out
	output vsync,		//vertical sync out
	output reg [2:0] red,	//red vga output
	output reg [2:0] green, //green vga output
	output reg [1:0] blue	//blue vga output
	);

	//28 bit registor to store result
    reg [27: 0] p_guess_res;
    reg [27: 0] c_guess_res;
    reg turn;

    initial begin
        p_guess_res = 0;
        c_guess_res = 0;
        turn = 0;
    end
	 
    // video structure constants
    parameter hpixels = 800;// horizontal pixels per line
    parameter vlines = 521; // vertical lines per frame
    parameter hpulse = 96; 	// hsync pulse length
    parameter vpulse = 2; 	// vsync pulse length
    parameter hbp = 144; 	// end of horizontal back porch
    parameter hfp = 784; 	// beginning of horizontal front porch
    parameter vbp = 31; 		// end of vertical back porch
    parameter vfp = 511; 	// beginning of vertical front porch
    parameter mid_v = 271 ;	//mid y position

    //Game map params
    parameter ship_len = 70;	//length of the seg
    parameter ship_w = 20; 	//width of a seg
    parameter in_ship_sep = 10; //seperation between digits
    parameter vf_off = 60;	//palce holder for the player name
    parameter vb_off = 60;	//vb offset
    parameter vm_off = 30;  //vm offset
    parameter horiz_sep = 24 ; 	//horiz offset


    //Computer's ships
    //ships' positions on the first battle ground
    parameter c_sh1_x = hfp - horiz_sep - ship_w;
    parameter c_sh1_y = vbp + vb_off;
    parameter c_sh2_x = c_sh1_x;
    parameter c_sh2_y = c_sh1_y + ship_len + in_ship_sep;
    parameter c_sh3_x = c_sh1_x - ship_len - in_ship_sep;
    parameter c_sh3_y = c_sh1_y;
    parameter c_sh4_x = c_sh3_x;
    parameter c_sh4_y = c_sh3_y + ship_len;
    parameter c_sh5_x = c_sh4_x;
    parameter c_sh5_y = c_sh4_y + (in_ship_sep + ship_len - ship_w);
    parameter c_sh6_x = c_sh3_x - ship_w - in_ship_sep;
    parameter c_sh6_y = c_sh1_y;
    parameter c_sh7_x = c_sh6_x;
    parameter c_sh7_y = c_sh6_y + ship_len + in_ship_sep;

    //ships' positions on the second battle ground
    parameter c_sh8_x = c_sh6_x - horiz_sep - ship_w;
    parameter c_sh8_y = vbp + vb_off;
    parameter c_sh9_x = c_sh8_x;
    parameter c_sh9_y = c_sh8_y + ship_len + in_ship_sep;
    parameter c_sh10_x = c_sh8_x - ship_len - in_ship_sep;
    parameter c_sh10_y = c_sh8_y;
    parameter c_sh11_x = c_sh10_x;
    parameter c_sh11_y = c_sh10_y + ship_len;
    parameter c_sh12_x = c_sh10_x;
    parameter c_sh12_y = c_sh11_y + (in_ship_sep + ship_len - ship_w);
    parameter c_sh13_x = c_sh10_x - ship_w - in_ship_sep;
    parameter c_sh13_y = c_sh8_y;
    parameter c_sh14_x = c_sh13_x;
    parameter c_sh14_y = c_sh13_y + ship_len + in_ship_sep;


    //ships' positions on the 3rd battle ground
    parameter c_sh15_x = c_sh13_x - horiz_sep - ship_w;
    parameter c_sh15_y = vbp + vb_off;
    parameter c_sh16_x = c_sh15_x;
    parameter c_sh16_y = c_sh15_y + ship_len + in_ship_sep;
    parameter c_sh17_x = c_sh15_x - ship_len - in_ship_sep;
    parameter c_sh17_y = c_sh15_y;
    parameter c_sh18_x = c_sh17_x;
    parameter c_sh18_y = c_sh17_y + ship_len;
    parameter c_sh19_x = c_sh17_x;
    parameter c_sh19_y = c_sh18_y + (in_ship_sep + ship_len - ship_w);
    parameter c_sh20_x = c_sh17_x - ship_w - in_ship_sep;
    parameter c_sh20_y = c_sh15_y;
    parameter c_sh21_x = c_sh20_x;
    parameter c_sh21_y = c_sh20_y + ship_len + in_ship_sep;

    //ships' positions on the 4th battle ground
    parameter c_sh22_x = c_sh20_x - horiz_sep - ship_w;
    parameter c_sh22_y = vbp + vb_off;
    parameter c_sh23_x = c_sh22_x;
    parameter c_sh23_y = c_sh22_y + ship_len + in_ship_sep;
    parameter c_sh24_x = c_sh22_x - ship_len - in_ship_sep;
    parameter c_sh24_y = c_sh22_y;
    parameter c_sh25_x = c_sh24_x;
    parameter c_sh25_y = c_sh24_y + ship_len;
    parameter c_sh26_x = c_sh24_x;
    parameter c_sh26_y = c_sh25_y + (in_ship_sep + ship_len - ship_w);
    parameter c_sh27_x = c_sh24_x - ship_w - in_ship_sep;
    parameter c_sh27_y = c_sh22_y;
    parameter c_sh28_x = c_sh27_x;
    parameter c_sh28_y = c_sh27_y + ship_len + in_ship_sep;
	
    //player's ships positions
	//ships' positions on the first battle ground
	parameter p_sh1_x = hfp - horiz_sep - ship_w;
	parameter p_sh1_y = mid_v + vm_off;
	parameter p_sh2_x = p_sh1_x;
	parameter p_sh2_y = p_sh1_y + ship_len + in_ship_sep;
	parameter p_sh3_x = p_sh1_x - ship_len - in_ship_sep;
	parameter p_sh3_y = p_sh1_y;
	parameter p_sh4_x = p_sh3_x;
	parameter p_sh4_y = p_sh3_y + ship_len;
	parameter p_sh5_x = p_sh4_x;
	parameter p_sh5_y = p_sh4_y + (in_ship_sep + ship_len - ship_w);
	parameter p_sh6_x = p_sh3_x - ship_w - in_ship_sep;
	parameter p_sh6_y = p_sh1_y;
	parameter p_sh7_x = p_sh6_x;
	parameter p_sh7_y = p_sh6_y + ship_len + in_ship_sep;

	//ships' positions on the second battle ground
	parameter p_sh8_x = p_sh6_x - horiz_sep - ship_w;
	parameter p_sh8_y = mid_v + vm_off;
	parameter p_sh9_x = p_sh8_x;
	parameter p_sh9_y = p_sh8_y + ship_len + in_ship_sep;
	parameter p_sh10_x = p_sh8_x - ship_len - in_ship_sep;
	parameter p_sh10_y = p_sh8_y;
	parameter p_sh11_x = p_sh10_x;
	parameter p_sh11_y = p_sh10_y + ship_len;
	parameter p_sh12_x = p_sh10_x;
	parameter p_sh12_y = p_sh11_y + (in_ship_sep + ship_len - ship_w);
	parameter p_sh13_x = p_sh10_x - ship_w - in_ship_sep;
	parameter p_sh13_y = p_sh8_y;
	parameter p_sh14_x = p_sh13_x;
	parameter p_sh14_y = p_sh13_y + ship_len + in_ship_sep;

	//ships' positions on the 3rd battle ground
	parameter p_sh15_x = p_sh13_x - horiz_sep - ship_w;
	parameter p_sh15_y = mid_v + vm_off;
	parameter p_sh16_x = p_sh15_x;
	parameter p_sh16_y = p_sh15_y + ship_len + in_ship_sep;
	parameter p_sh17_x = p_sh15_x - ship_len - in_ship_sep;
	parameter p_sh17_y = p_sh15_y;
	parameter p_sh18_x = p_sh17_x;
	parameter p_sh18_y = p_sh17_y + ship_len;
	parameter p_sh19_x = p_sh17_x;
	parameter p_sh19_y = p_sh18_y + (in_ship_sep + ship_len - ship_w);
	parameter p_sh20_x = p_sh17_x - ship_w - in_ship_sep;
	parameter p_sh20_y = p_sh15_y;
	parameter p_sh21_x = p_sh20_x;
	parameter p_sh21_y = p_sh20_y + ship_len + in_ship_sep;

	//ships' positions on the 4th battle ground
	parameter p_sh22_x = p_sh20_x - horiz_sep - ship_w;
	parameter p_sh22_y = mid_v + vm_off;
	parameter p_sh23_x = p_sh22_x;
	parameter p_sh23_y = p_sh22_y + ship_len + in_ship_sep;
	parameter p_sh24_x = p_sh22_x - ship_len - in_ship_sep;
	parameter p_sh24_y = p_sh22_y;
	parameter p_sh25_x = p_sh24_x;
	parameter p_sh25_y = p_sh24_y + ship_len;
	parameter p_sh26_x = p_sh24_x;
	parameter p_sh26_y = p_sh25_y + (in_ship_sep + ship_len - ship_w);
	parameter p_sh27_x = p_sh24_x - ship_w - in_ship_sep;
	parameter p_sh27_y = p_sh22_y;
	parameter p_sh28_x = p_sh27_x;
	parameter p_sh28_y = p_sh27_y + ship_len + in_ship_sep;

    // registers for storing the horizontal & vertical counters
    reg [9:0] hc = 0;
    reg [9:0] vc = 0;

    always @(posedge clk)
    begin
        
        if (hc < hpixels - 1)
            hc <= hc + 1;
        else
        
        begin
            hc <= 0;
            if (vc < vlines - 1)
                vc <= vc + 1;
            else
                vc <= 0;
        end
            
        //end
    end

    // generate sync pulses (active low)
    assign hsync = (hc < hpulse) ? 0:1;
    assign vsync = (vc < vpulse) ? 0:1;

    //Game layout

    //Computer's map
    always @(posedge clk) begin
        //if in the game phase
        if(phase) begin
            p_guess_res = p_guess_res | (cships & pguess);  //contains all the guess results 
            c_guess_res = c_guess_res | (pships & cguess);  //contains all the guess results
        end
        //color ship1
        if (vc >= c_sh1_y && vc < c_sh1_y + ship_len && hc >= c_sh1_x && hc < c_sh1_x + ship_w) begin
        
            //player guesses this ship and correct
            if (phase && p_guess_res[0] && pguess[0] && !finish) begin
                green = 3'b000;
                red = 3'b111;
                blue = 2'b00;
            end
            
            //player guesses this ship but wrong
            else if (phase && !p_guess_res[0] && pguess[0] && !finish) begin
                green = 3'b000;
                red = 3'b000;
                blue = 2'b11;
            end

            else begin
                green = 3'b101;
                red = 3'b101;
                blue = 2'b10;
            end
            
        end
        //coloring ship2
        else if (vc >= c_sh2_y && vc < c_sh2_y + ship_len && hc >= c_sh2_x && hc < c_sh2_x  + ship_w) begin

            //player guesses this ship and correct
            if (phase && p_guess_res[1] && pguess[1] && !finish) begin
                green = 3'b000;
                red = 3'b111;
                blue = 2'b00;
            end
            
            //player guesses this ship but wrong
            else if (phase && !p_guess_res[1] && pguess[1] && !finish) begin
                green = 3'b000;
                red = 3'b000;
                blue = 2'b11;
            end

            else begin
                green = 3'b101;
                red = 3'b101;
                blue = 2'b10;
            end
        end
        //color ship3
        else if (vc >= c_sh3_y && vc < c_sh3_y + ship_w && hc >= c_sh3_x && hc < c_sh3_x + ship_len) begin
            
            //player guesses this ship and correct
            if (phase && p_guess_res[2] && pguess[2] && !finish) begin
                green = 3'b000;
                red = 3'b111;
                blue = 2'b00;
            end
            
            //player guesses this ship but wrong
            else if (phase && !p_guess_res[2] && pguess[2] && !finish) begin
                green = 3'b000;
                red = 3'b000;
                blue = 2'b11;
            end

            else begin
                green = 3'b101;
                red = 3'b101;
                blue = 2'b10;
            end
        end
        //color ship4
        else if (vc >= c_sh4_y && vc < c_sh4_y + ship_w && hc >= c_sh4_x && hc < c_sh4_x + ship_len) begin
            
            //player guesses this ship and correct
            if (phase && p_guess_res[3] && pguess[3] && !finish) begin
                green = 3'b000;
                red = 3'b111;
                blue = 2'b00;
            end
            
            //player guesses this ship but wrong
            else if (phase && !p_guess_res[3] && pguess[3] && !finish) begin
                green = 3'b000;
                red = 3'b000;
                blue = 2'b11;
            end

            else begin
                green = 3'b101;
                red = 3'b101;
                blue = 2'b10;
            end
        end
        //color ship5
        else if (vc >= c_sh5_y && vc < c_sh5_y + ship_w && hc >= c_sh5_x && hc < c_sh5_x + ship_len) begin
            
            //player guesses this ship and correct
            if (phase && p_guess_res[4] && pguess[4] && !finish) begin
                green = 3'b000;
                red = 3'b111;
                blue = 2'b00;
            end
            
            //player guesses this ship but wrong
            else if (phase && !p_guess_res[4] && pguess[4] && !finish) begin
                green = 3'b000;
                red = 3'b000;
                blue = 2'b11;
            end

            else begin
                green = 3'b101;
                red = 3'b101;
                blue = 2'b10;
            end
        end
        //color ship6
        else if (vc >= c_sh6_y && vc < c_sh6_y + ship_len && hc >= c_sh6_x && hc < c_sh6_x + ship_w) begin
            

            //player guesses this ship and correct
            if (phase && p_guess_res[5] && pguess[5] && !finish) begin
                green = 3'b000;
                red = 3'b111;
                blue = 2'b00;
            end
            
            //player guesses this ship but wrong
            else if (phase && !p_guess_res[5] && pguess[5] && !finish) begin
                green = 3'b000;
                red = 3'b000;
                blue = 2'b11;
            end

            else begin
                green = 3'b101;
                red = 3'b101;
                blue = 2'b10;
            end
        end
        //coloring ship7
        else if (vc >= c_sh7_y && vc < c_sh7_y + ship_len && hc >= c_sh7_x && hc < c_sh7_x + ship_w) begin
            

            //player guesses this ship and correct
            if (phase && p_guess_res[6] && pguess[6] && !finish) begin
                green = 3'b000;
                red = 3'b111;
                blue = 2'b00;
            end
            
            //player guesses this ship but wrong
            else if (phase && !p_guess_res[6] && pguess[6] && !finish) begin
                green = 3'b000;
                red = 3'b000;
                blue = 2'b11;
            end

            else begin
                green = 3'b101;
                red = 3'b101;
                blue = 2'b10;
            end
        end
        //color ship8
        else if (vc >= c_sh8_y && vc < c_sh8_y + ship_len && hc >= c_sh8_x && hc < c_sh8_x + ship_w) begin
           
            //player guesses this ship and correct
            if (phase && p_guess_res && pguess[7] && !finish) begin
                green = 3'b000;
                red = 3'b111;
                blue = 2'b00;
            end
            
            //player guesses this ship but wrong
            else if (phase && !p_guess_res && pguess[7] && !finish) begin
                green = 3'b000;
                red = 3'b000;
                blue = 2'b11;
            end

            else begin
                green = 3'b101;
                red = 3'b101;
                blue = 2'b10;
            end
        end
        //color ship9
        else if (vc >= c_sh9_y && vc < c_sh9_y + ship_len && hc >= c_sh9_x && hc < c_sh9_x + ship_w) begin
           
            //player guesses this ship and correct
            if (phase && p_guess_res[8] && pguess[8] && !finish) begin
                green = 3'b000;
                red = 3'b111;
                blue = 2'b00;
            end
            
            //player guesses this ship but wrong
            else if (phase && !p_guess_res[8] && pguess[8] && !finish) begin
                green = 3'b000;
                red = 3'b000;
                blue = 2'b11;
            end

            else begin
                green = 3'b101;
                red = 3'b101;
                blue = 2'b10;
            end
        end
        //color ship10
        else if (vc >= c_sh10_y && vc < c_sh10_y + ship_w && hc >= c_sh10_x && hc < c_sh10_x + ship_len) begin
           
            //player guesses this ship and correct
            if (phase && p_guess_res[9] && pguess[9] && !finish) begin
                green = 3'b000;
                red = 3'b111;
                blue = 2'b00;
            end
            
            //player guesses this ship but wrong
            else if (phase && !p_guess_res[9] && pguess[9] && !finish) begin
                green = 3'b000;
                red = 3'b000;
                blue = 2'b11;
            end

            else begin
                green = 3'b101;
                red = 3'b101;
                blue = 2'b10;
            end
        end
        //color ship11
        else if (vc >= c_sh11_y && vc < c_sh11_y + ship_w && hc >= c_sh11_x && hc < c_sh11_x + ship_len) begin
            
            //player guesses this ship and correct
            if (phase && p_guess_res[10] && pguess[10] && !finish) begin
                green = 3'b000;
                red = 3'b111;
                blue = 2'b00;
            end
            
            //player guesses this ship but wrong
            else if (phase && !p_guess_res[10] && pguess[10] && !finish) begin
                green = 3'b000;
                red = 3'b000;
                blue = 2'b11;
            end

            else begin
                green = 3'b101;
                red = 3'b101;
                blue = 2'b10;
            end
        end
        //coloring ship12
        else if (vc >= c_sh12_y && vc < c_sh12_y + ship_w && hc >= c_sh12_x && hc < c_sh12_x + ship_len) begin
           
            //player guesses this ship and correct
            if (phase && p_guess_res[11] && pguess[11] && !finish) begin
                green = 3'b000;
                red = 3'b111;
                blue = 2'b00;
            end
            
            //player guesses this ship but wrong
            else if (phase && !p_guess_res[11] && pguess[11] && !finish) begin
                green = 3'b000;
                red = 3'b000;
                blue = 2'b11;
            end

            else begin
                green = 3'b101;
                red = 3'b101;
                blue = 2'b10;
            end
        end
        //color ship13
        else if (vc >= c_sh13_y && vc < c_sh13_y + ship_len && hc >= c_sh13_x && hc < c_sh13_x + ship_w) begin
            
            //player guesses this ship and correct
            if (phase && p_guess_res[12] && pguess[12] && !finish) begin
                green = 3'b000;
                red = 3'b111;
                blue = 2'b00;
            end
            
            //player guesses this ship but wrong
            else if (phase && !p_guess_res[12] && pguess[12] && !finish) begin
                green = 3'b000;
                red = 3'b000;
                blue = 2'b11;
            end

            else begin
                green = 3'b101;
                red = 3'b101;
                blue = 2'b10;
            end
        end
        //color ship14
        else if (vc >= c_sh14_y && vc < c_sh14_y + ship_len && hc >= c_sh14_x && hc < c_sh14_x + ship_w) begin
            
            //player guesses this ship and correct
            if (phase && p_guess_res[13] && pguess[13] && !finish) begin
                green = 3'b000;
                red = 3'b111;
                blue = 2'b00;
            end
            
            //player guesses this ship but wrong
            else if (phase && !p_guess_res[13] && pguess[13] && !finish) begin
                green = 3'b000;
                red = 3'b000;
                blue = 2'b11;
            end

            else begin
                green = 3'b101;
                red = 3'b101;
                blue = 2'b10;
            end
        end
        //color ship15
        else if (vc >= c_sh15_y && vc < c_sh15_y + ship_len && hc >= c_sh15_x && hc < c_sh15_x + ship_w) begin
           

            //player guesses this ship and correct
            if (phase && p_guess_res[14] && pguess[14] && !finish) begin
                green = 3'b000;
                red = 3'b111;
                blue = 2'b00;
            end
            
            //player guesses this ship but wrong
            else if (phase && !p_guess_res[14] && pguess[14] && !finish) begin
                green = 3'b000;
                red = 3'b000;
                blue = 2'b11;
            end

            else begin
                green = 3'b101;
                red = 3'b101;
                blue = 2'b10;
            end
        end
        //color ship16
        else if (vc >= c_sh16_y && vc < c_sh16_y + ship_len && hc >= c_sh16_x && hc < c_sh16_x + ship_w) begin
            
            //player guesses this ship and correct
            if (phase && p_guess_res[15] && pguess[15] && !finish) begin
                green = 3'b000;
                red = 3'b111;
                blue = 2'b00;
            end
            
            //player guesses this ship but wrong
            else if (phase && !p_guess_res[15] && pguess[15] && !finish) begin
                green = 3'b000;
                red = 3'b000;
                blue = 2'b11;
            end

            else begin
                green = 3'b101;
                red = 3'b101;
                blue = 2'b10;
            end
        end
        //coloring ship17
        else if (vc >= c_sh17_y && vc < c_sh17_y + ship_w && hc >= c_sh17_x && hc < c_sh17_x + ship_len) begin
           
            //player guesses this ship and correct
            if (phase && p_guess_res[16] && pguess[16] && !finish) begin
                green = 3'b000;
                red = 3'b111;
                blue = 2'b00;
            end
            
            //player guesses this ship but wrong
            else if (phase && !p_guess_res[16] && pguess[16] && !finish) begin
                green = 3'b000;
                red = 3'b000;
                blue = 2'b11;
            end

            else begin
                green = 3'b101;
                red = 3'b101;
                blue = 2'b10;
            end
        end
        //color ship18
        else if (vc >= c_sh18_y && vc < c_sh18_y + ship_w && hc >= c_sh18_x && hc < c_sh18_x + ship_len) begin
            
            //player guesses this ship and correct
            if (phase && p_guess_res[17] && pguess[17] && !finish) begin
                green = 3'b000;
                red = 3'b111;
                blue = 2'b00;
            end
            
            //player guesses this ship but wrong
            else if (phase && !p_guess_res[17] && pguess[17] && !finish) begin
                green = 3'b000;
                red = 3'b000;
                blue = 2'b11;
            end

            else begin
                green = 3'b101;
                red = 3'b101;
                blue = 2'b10;
            end
        end
        //color ship19
        else if (vc >= c_sh19_y && vc < c_sh19_y + ship_w && hc >= c_sh19_x && hc < c_sh19_x + ship_len) begin
            

            //player guesses this ship and correct
            if (phase && p_guess_res[18] && pguess[18] && !finish) begin
                green = 3'b000;
                red = 3'b111;
                blue = 2'b00;
            end
            
            //player guesses this ship but wrong
            else if (phase && !p_guess_res[18] && pguess[18] && !finish) begin
                green = 3'b000;
                red = 3'b000;
                blue = 2'b11;
            end

            else begin
                green = 3'b101;
                red = 3'b101;
                blue = 2'b10;
            end
        end
        //color ship20
        else if (vc >= c_sh20_y && vc < c_sh20_y + ship_len && hc >= c_sh20_x && hc < c_sh20_x + ship_w) begin
        

            //player guesses this ship and correct
            if (phase && p_guess_res[19] && pguess[19] && !finish) begin
                green = 3'b000;
                red = 3'b111;
                blue = 2'b00;
            end
            
            //player guesses this ship but wrong
            else if (phase && !p_guess_res[19] && pguess[19] && !finish) begin
                green = 3'b000;
                red = 3'b000;
                blue = 2'b11;
            end

            else begin
                green = 3'b101;
                red = 3'b101;
                blue = 2'b10;
            end
        end
        //color ship21
        else if (vc >= c_sh21_y && vc < c_sh21_y + ship_len && hc >= c_sh21_x && hc < c_sh21_x + ship_w) begin
            

            //player guesses this ship and correct
            if (phase && p_guess_res[20] && pguess[20] && !finish) begin
                green = 3'b000;
                red = 3'b111;
                blue = 2'b00;
            end
            
            //player guesses this ship but wrong
            else if (phase && !p_guess_res[20] && pguess[20] && !finish) begin
                green = 3'b000;
                red = 3'b000;
                blue = 2'b11;
            end

            else begin
                green = 3'b101;
                red = 3'b101;
                blue = 2'b10;
            end
        end

        //color ship22
        else if (vc >= c_sh22_y && vc < c_sh15_y + ship_len && hc >= c_sh22_x && hc < c_sh22_x + ship_w) begin
            
            //player guesses this ship and correct
            if (phase && p_guess_res[21] && pguess[21] && !finish) begin
                green = 3'b000;
                red = 3'b111;
                blue = 2'b00;
            end
            
            //player guesses this ship but wrong
            else if (phase && !p_guess_res[21] && pguess[21] && !finish) begin
                green = 3'b000;
                red = 3'b000;
                blue = 2'b11;
            end

            else begin
                green = 3'b101;
                red = 3'b101;
                blue = 2'b10;
            end
        end
        //color ship23
        else if (vc >= c_sh23_y && vc < c_sh23_y + ship_len && hc >= c_sh23_x && hc < c_sh23_x + ship_w) begin
           
            //player guesses this ship and correct
            if (phase && p_guess_res[22] && pguess[22] && !finish) begin
                green = 3'b000;
                red = 3'b111;
                blue = 2'b00;
            end
            
            //player guesses this ship but wrong
            else if (phase && !p_guess_res[22] && pguess[22] && !finish) begin
                green = 3'b000;
                red = 3'b000;
                blue = 2'b11;
            end

            else begin
                green = 3'b101;
                red = 3'b101;
                blue = 2'b10;
            end
        end
        //coloring ship24
        else if (vc >= c_sh24_y && vc < c_sh24_y + ship_w && hc >= c_sh24_x && hc < c_sh24_x + ship_len) begin
           

            //player guesses this ship and correct
            if (phase && p_guess_res[23] && pguess[23] && !finish) begin
                green = 3'b000;
                red = 3'b111;
                blue = 2'b00;
            end
            
            //player guesses this ship but wrong
            else if (phase && !p_guess_res[23] && pguess[23] && !finish) begin
                green = 3'b000;
                red = 3'b000;
                blue = 2'b11;
            end

            else begin
                green = 3'b101;
                red = 3'b101;
                blue = 2'b10;
            end
        end
        //color ship25
        else if (vc >= c_sh25_y && vc < c_sh25_y + ship_w && hc >= c_sh26_x && hc < c_sh26_x + ship_len) begin
           
            //player guesses this ship and correct
            if (phase && p_guess_res[24] && pguess[24] && !finish) begin
                green = 3'b000;
                red = 3'b111;
                blue = 2'b00;
            end
            
            //player guesses this ship but wrong
            else if (phase && !p_guess_res[24] && pguess[24] && !finish) begin
                green = 3'b000;
                red = 3'b000;
                blue = 2'b11;
            end

            else begin
                green = 3'b101;
                red = 3'b101;
                blue = 2'b10;
            end
        end
        //color ship26
        else if (vc >= c_sh26_y && vc < c_sh26_y + ship_w && hc >= c_sh26_x && hc < c_sh26_x + ship_len) begin
            

            //player guesses this ship and correct
            if (phase && p_guess_res[25] && pguess[25] && !finish) begin
                green = 3'b000;
                red = 3'b111;
                blue = 2'b00;
            end
            
            //player guesses this ship but wrong
            else if (phase && !p_guess_res[25] && pguess[25] && !finish) begin
                green = 3'b000;
                red = 3'b000;
                blue = 2'b11;
            end

            else begin
                green = 3'b101;
                red = 3'b101;
                blue = 2'b10;
            end
        end
        //color ship27
        else if (vc >= c_sh27_y && vc < c_sh27_y + ship_len && hc >= c_sh27_x && hc < c_sh27_x + ship_w) begin
            

            //player guesses this ship and correct
            if (phase && p_guess_res[26] && pguess[26] && !finish) begin
                green = 3'b000;
                red = 3'b111;
                blue = 2'b00;
            end
            
            //player guesses this ship but wrong
            else if (phase && !p_guess_res[26] && pguess[26] && !finish) begin
                green = 3'b000;
                red = 3'b000;
                blue = 2'b11;
            end

            else begin
                green = 3'b101;
                red = 3'b101;
                blue = 2'b10;
            end
        end
        //color ship28
        else if (vc >= c_sh28_y && vc < c_sh28_y + ship_len && hc >= c_sh28_x && hc < c_sh28_x + ship_w) begin
            
            //player guesses this ship and correct
            if (phase && p_guess_res[27] && pguess[27] && !finish) begin
                green = 3'b000;
                red = 3'b111;
                blue = 2'b00;
            end
            
            //player guesses this ship but wrong
            else if (phase && !p_guess_res[27] && pguess[27] && !finish) begin
                green = 3'b000;
                red = 3'b000;
                blue = 2'b11;
            end

            else begin
                green = 3'b101;
                red = 3'b101;
                blue = 2'b10;
            end
        end
		///////////////////////////////////////////////////////////////////////////////////////////
		//player's map
		///////////////////////////////////////////////////////////////////////////////////////////

		else if (vc >= p_sh1_y && vc < p_sh1_y + ship_len && hc >= p_sh1_x && hc < p_sh1_x + ship_w) begin

				//computer guesses this ship and correct
				if (phase && c_guess_res[0] && cguess[0] && !finish) begin
					green = 3'b000;
					red = 3'b111;
					blue = 2'b00;
				end
				
				//player selected this ship
				else if (pships[0] && !finish) begin
					green = 3'b111;
					red = 3'b111;
					blue = 2'b11;
				end
				
				//computer guesses this ship but wrong
				else if (phase && !c_guess_res[0] && cguess[0] && !finish) begin
					green = 3'b000;
					red = 3'b000;
					blue = 2'b11;
				end

				else begin
					green = 3'b101;
					red = 3'b101;
					blue = 2'b10;
				end
		end
		//coloring ship2
		else if (vc >= p_sh2_y && vc < p_sh2_y + ship_len && hc >= p_sh2_x && hc < p_sh2_x  + ship_w) begin

				//computer guesses this ship and correct
				if (phase && c_guess_res[1] && cguess[1] && !finish) begin
					green = 3'b000;
					red = 3'b111;
					blue = 2'b00;
				end
				
				//player selected this ship
				else if (pships[1] && !finish) begin
					green = 3'b111;
					red = 3'b111;
					blue = 2'b11;
				end
				
				//computer guesses this ship but wrong
				else if (phase && !c_guess_res[1] && cguess[1] && !finish) begin
					green = 3'b000;
					red = 3'b000;
					blue = 2'b11;
				end

				else begin
					green = 3'b101;
					red = 3'b101;
					blue = 2'b10;
				end
		end
		//color ship3
		else if (vc >= p_sh3_y && vc < p_sh3_y + ship_w && hc >= p_sh3_x && hc < p_sh3_x + ship_len) begin

				//computer guesses this ship and correct
				if (phase && c_guess_res[2] && cguess[2] && !finish) begin
					green = 3'b000;
					red = 3'b111;
					blue = 2'b00;
				end
				
				//player selected this ship
				else if (pships[2] && !finish) begin
					green = 3'b111;
					red = 3'b111;
					blue = 2'b11;
				end
				
				//computer guesses this ship but wrong
				else if (phase && !c_guess_res[2] && cguess[2] && !finish) begin
					green = 3'b000;
					red = 3'b000;
					blue = 2'b11;
				end

				else begin
					green = 3'b101;
					red = 3'b101;
					blue = 2'b10;
				end
		end
		//color ship4
		else if (vc >= p_sh4_y && vc < p_sh4_y + ship_w && hc >= p_sh4_x && hc < p_sh4_x + ship_len) begin

				//computer guesses this ship and correct
				if (phase && c_guess_res[3] && cguess[3] && !finish) begin
					green = 3'b000;
					red = 3'b111;
					blue = 2'b00;
				end
				
				//player selected this ship
				else if (pships[3] && !finish) begin
					green = 3'b111;
					red = 3'b111;
					blue = 2'b11;
				end
				
				//computer guesses this ship but wrong
				else if (phase && !c_guess_res[3] && cguess[3] && !finish) begin
					green = 3'b000;
					red = 3'b000;
					blue = 2'b11;
				end

				else begin
					green = 3'b101;
					red = 3'b101;
					blue = 2'b10;
				end
		end
		//color ship5
		else if (vc >= p_sh5_y && vc < p_sh5_y + ship_w && hc >= p_sh5_x && hc < p_sh5_x + ship_len) begin

				//computer guesses this ship and correct
				if (phase && c_guess_res[4] && cguess[4] && !finish) begin
					green = 3'b000;
					red = 3'b111;
					blue = 2'b00;
				end
				
				//player selected this ship
				else if (pships[4] && !finish) begin
					green = 3'b111;
					red = 3'b111;
					blue = 2'b11;
				end
				
				//computer guesses this ship but wrong
				else if (phase && !c_guess_res[4] && cguess[4] && !finish) begin
					green = 3'b000;
					red = 3'b000;
					blue = 2'b11;
				end

				else begin
					green = 3'b101;
					red = 3'b101;
					blue = 2'b10;
				end
		end
		//color ship6
		else if (vc >= p_sh6_y && vc < p_sh6_y + ship_len && hc >= p_sh6_x && hc < p_sh6_x + ship_w) begin

				//computer guesses this ship and correct
				if (phase && c_guess_res[5] && cguess[5] && !finish) begin
					green = 3'b000;
					red = 3'b111;
					blue = 2'b00;
				end
				
				//player selected this ship
				else if (pships[5] && !finish) begin
					green = 3'b111;
					red = 3'b111;
					blue = 2'b11;
				end
				
				//computer guesses this ship but wrong
				else if (phase && !c_guess_res[5] && cguess[5] && !finish) begin
					green = 3'b000;
					red = 3'b000;
					blue = 2'b11;
				end

				else begin
					green = 3'b101;
					red = 3'b101;
					blue = 2'b10;
				end
		end
		//coloring ship7
		else if (vc >= p_sh7_y && vc < p_sh7_y + ship_len && hc >= p_sh7_x && hc < p_sh7_x + ship_w) begin

				//computer guesses this ship and correct
				if (phase && c_guess_res[6] && cguess[6] && !finish) begin
					green = 3'b000;
					red = 3'b111;
					blue = 2'b00;
				end
				
				//player selected this ship
				else if (pships[6] && !finish) begin
					green = 3'b111;
					red = 3'b111;
					blue = 2'b11;
				end
				
				//computer guesses this ship but wrong
				else if (phase && !c_guess_res[6] && cguess[6] && !finish) begin
					green = 3'b000;
					red = 3'b000;
					blue = 2'b11;
				end

				else begin
					green = 3'b101;
					red = 3'b101;
					blue = 2'b10;
				end
		end
		//color ship8
		else if (vc >= p_sh8_y && vc < p_sh8_y + ship_len && hc >= p_sh8_x && hc < p_sh8_x + ship_w) begin

				//computer guesses this ship and correct
				if (phase && c_guess_res[7] && cguess[7] && !finish) begin
					green = 3'b000;
					red = 3'b111;
					blue = 2'b00;
				end
				
				//player selected this ship
				else if (pships[7] && !finish) begin
					green = 3'b111;
					red = 3'b111;
					blue = 2'b11;
				end
				
				//computer guesses this ship but wrong
				else if (phase && !c_guess_res[7] && cguess[7] && !finish) begin
					green = 3'b000;
					red = 3'b000;
					blue = 2'b11;
				end

				else begin
					green = 3'b101;
					red = 3'b101;
					blue = 2'b10;
				end
		end
		//color ship9
		else if (vc >= p_sh9_y && vc < p_sh9_y + ship_len && hc >= p_sh9_x && hc < p_sh9_x + ship_w) begin

				//computer guesses this ship and correct
				if (phase && c_guess_res[8] && cguess[8] && !finish) begin
					green = 3'b000;
					red = 3'b111;
					blue = 2'b00;
				end
				
				//player selected this ship
				else if (pships[8] && !finish) begin
					green = 3'b111;
					red = 3'b111;
					blue = 2'b11;
				end
				
				//computer guesses this ship but wrong
				else if (phase && !c_guess_res[8] && cguess[8] && !finish) begin
					green = 3'b000;
					red = 3'b000;
					blue = 2'b11;
				end

				else begin
					green = 3'b101;
					red = 3'b101;
					blue = 2'b10;
				end
		end
		//color ship10
		else if (vc >= p_sh10_y && vc < p_sh10_y + ship_w && hc >= p_sh10_x && hc < p_sh10_x + ship_len) begin

				//computer guesses this ship and correct
				if (phase && c_guess_res[9] && cguess[9] && !finish) begin
					green = 3'b000;
					red = 3'b111;
					blue = 2'b00;
				end
				
				//player selected this ship
				else if (pships[9] && !finish) begin
					green = 3'b111;
					red = 3'b111;
					blue = 2'b11;
				end
				
				//computer guesses this ship but wrong
				else if (phase && !c_guess_res[9] && cguess[9] && !finish) begin
					green = 3'b000;
					red = 3'b000;
					blue = 2'b11;
				end

				else begin
					green = 3'b101;
					red = 3'b101;
					blue = 2'b10;
				end
		end
		//color ship11
		else if (vc >= p_sh11_y && vc < p_sh11_y + ship_w && hc >= p_sh11_x && hc < p_sh11_x + ship_len) begin
		
				//computer guesses this ship and correct
				if (phase && c_guess_res[10] && cguess[10] && !finish) begin
					green = 3'b000;
					red = 3'b111;
					blue = 2'b00;
				end
				
				//player selected this ship
				else if (pships[10] && !finish) begin
					green = 3'b111;
					red = 3'b111;
					blue = 2'b11;
				end

				
				//computer guesses this ship but wrong
				else if (phase && !c_guess_res[10] && cguess[10] && !finish) begin
					green = 3'b000;
					red = 3'b000;
					blue = 2'b11;
				end

				else begin
					green = 3'b101;
					red = 3'b101;
					blue = 2'b10;
				end
		end
		//coloring ship12
		else if (vc >= p_sh12_y && vc < p_sh12_y + ship_w && hc >= p_sh12_x && hc < p_sh12_x + ship_len) begin

				//computer guesses this ship and correct
				if (phase && c_guess_res[11] && cguess[11] && !finish) begin
					green = 3'b000;
					red = 3'b111;
					blue = 2'b00;
				end
				
				//player selected this ship
				else if (pships[11] && !finish) begin
					green = 3'b111;
					red = 3'b111;
					blue = 2'b11;
				end
				
				//computer guesses this ship but wrong
				else if (phase && !c_guess_res[11] && cguess[11] && !finish) begin
					green = 3'b000;
					red = 3'b000;
					blue = 2'b11;
				end

				else begin
					green = 3'b101;
					red = 3'b101;
					blue = 2'b10;
				end
		end
		//color ship13
		else if (vc >= p_sh13_y && vc < p_sh13_y + ship_len && hc >= p_sh13_x && hc < p_sh13_x + ship_w) begin

				//computer guesses this ship and correct
				if (phase && c_guess_res[12] && cguess[12] && !finish) begin
					green = 3'b000;
					red = 3'b111;
					blue = 2'b00;
				end
				
				//player selected this ship
				else if (pships[12] && !finish) begin
					green = 3'b111;
					red = 3'b111;
					blue = 2'b11;
				end
				
				//computer guesses this ship but wrong
				else if (phase && !c_guess_res[12] && cguess[12] && !finish) begin
					green = 3'b000;
					red = 3'b000;
					blue = 2'b11;
				end

				else begin
					green = 3'b101;
					red = 3'b101;
					blue = 2'b10;
				end
		end
		//color ship14
		else if (vc >= p_sh14_y && vc < p_sh14_y + ship_len && hc >= p_sh14_x && hc < p_sh14_x + ship_w) begin

				//computer guesses this ship and correct
				if (phase && c_guess_res[13] && cguess[13] && !finish) begin
					green = 3'b000;
					red = 3'b111;
					blue = 2'b00;
				end
				
				//player selected this ship
				else if (pships[13] && !finish) begin
					green = 3'b111;
					red = 3'b111;
					blue = 2'b11;
				end
				
				//computer guesses this ship but wrong
				else if (phase && !c_guess_res[13] && cguess[13] && !finish) begin
					green = 3'b000;
					red = 3'b000;
					blue = 2'b11;
				end

				else begin
					green = 3'b101;
					red = 3'b101;
					blue = 2'b10;
				end
		end
		//color ship15
		else if (vc >= p_sh15_y && vc < p_sh15_y + ship_len && hc >= p_sh15_x && hc < p_sh15_x + ship_w) begin

				//computer guesses this ship and correct
				if (phase && c_guess_res[14] && cguess[14] && !finish) begin
					green = 3'b000;
					red = 3'b111;
					blue = 2'b00;
				end
				
				//player selected this ship
				else if (pships[14] && !finish) begin
					green = 3'b111;
					red = 3'b111;
					blue = 2'b11;
				end
				
				//computer guesses this ship but wrong
				else if (phase && !c_guess_res[14] && cguess[14] && !finish) begin
					green = 3'b000;
					red = 3'b000;
					blue = 2'b11;
				end

				else begin
					green = 3'b101;
					red = 3'b101;
					blue = 2'b10;
				end
		end
		//color ship16
		else if (vc >= p_sh16_y && vc < p_sh16_y + ship_len && hc >= p_sh16_x && hc < p_sh16_x + ship_w) begin

				//computer guesses this ship and correct
				if (phase && c_guess_res[15] && cguess[15] && !finish) begin
					green = 3'b000;
					red = 3'b111;
					blue = 2'b00;
				end
				
				//player selected this ship
				else if (pships[15] && !finish) begin
					green = 3'b111;
					red = 3'b111;
					blue = 2'b11;
				end
				
				//computer guesses this ship but wrong
				else if (phase && !c_guess_res[15] && cguess[15] && !finish) begin
					green = 3'b000;
					red = 3'b000;
					blue = 2'b11;
				end

				else begin
					green = 3'b101;
					red = 3'b101;
					blue = 2'b10;
				end
		end
		//coloring ship17
		else if (vc >= p_sh17_y && vc < p_sh17_y + ship_w && hc >= p_sh17_x && hc < p_sh17_x + ship_len) begin

				//computer guesses this ship and correct
				if (phase && c_guess_res[16] && cguess[16] && !finish) begin
					green = 3'b000;
					red = 3'b111;
					blue = 2'b00;
				end
				
				//player selected this ship
				else if (pships[16] && !finish) begin
					green = 3'b111;
					red = 3'b111;
					blue = 2'b11;
				end
				
				//computer guesses this ship but wrong
				else if (phase && !c_guess_res[16] && cguess[16] && !finish) begin
					green = 3'b000;
					red = 3'b000;
					blue = 2'b11;
				end

				else begin
					green = 3'b101;
					red = 3'b101;
					blue = 2'b10;
				end
		end
		//color ship18
		else if (vc >= p_sh18_y && vc < p_sh18_y + ship_w && hc >= p_sh18_x && hc < p_sh18_x + ship_len) begin

				//computer guesses this ship and correct
				if (phase && c_guess_res[17] && cguess[17] && !finish) begin
					green = 3'b000;
					red = 3'b111;
					blue = 2'b00;
				end
				
				//player selected this ship
				else if (pships[17] && !finish) begin
					green = 3'b111;
					red = 3'b111;
					blue = 2'b11;
				end
				
				//computer guesses this ship but wrong
				else if (phase && !c_guess_res[17] && cguess[17] && !finish) begin
					green = 3'b000;
					red = 3'b000;
					blue = 2'b11;
				end

				else begin
					green = 3'b101;
					red = 3'b101;
					blue = 2'b10;
				end
		end
		//color ship19
		else if (vc >= p_sh19_y && vc < p_sh19_y + ship_w && hc >= p_sh19_x && hc < p_sh19_x + ship_len) begin

				//computer guesses this ship and correct
				if (phase && c_guess_res[18] && cguess[18] && !finish) begin
					green = 3'b000;
					red = 3'b111;
					blue = 2'b00;
				end
				
				//player selected this ship
				else if (pships[18] && !finish) begin
					green = 3'b111;
					red = 3'b111;
					blue = 2'b11;
				end
				
				//computer guesses this ship but wrong
				else if (phase && !c_guess_res[18] && cguess[18] && !finish) begin
					green = 3'b000;
					red = 3'b000;
					blue = 2'b11;
				end

				else begin
					green = 3'b101;
					red = 3'b101;
					blue = 2'b10;
				end
		end
		//color ship20
		else if (vc >= p_sh20_y && vc < p_sh20_y + ship_len && hc >= p_sh20_x && hc < p_sh20_x + ship_w) begin

				//computer guesses this ship and correct
				if (phase && c_guess_res[19] && cguess[19] && !finish) begin
					green = 3'b000;
					red = 3'b111;
					blue = 2'b00;
				end
				
				//player selected this ship
				else if (pships[19] && !finish) begin
					green = 3'b111;
					red = 3'b111;
					blue = 2'b11;
				end
				
				//computer guesses this ship but wrong
				else if (phase && !c_guess_res[19] && cguess[19] && !finish) begin
					green = 3'b000;
					red = 3'b000;
					blue = 2'b11;
				end

				else begin
					green = 3'b101;
					red = 3'b101;
					blue = 2'b10;
				end
		end
		//color ship21
		else if (vc >= p_sh21_y && vc < p_sh21_y + ship_len && hc >= p_sh21_x && hc < p_sh21_x + ship_w) begin

				//computer guesses this ship and correct
				if (phase && c_guess_res[20] && cguess[20] && !finish) begin
					green = 3'b000;
					red = 3'b111;
					blue = 2'b00;
				end
				
				//player selected this ship
				else if (pships[20] && !finish) begin
					green = 3'b111;
					red = 3'b111;
					blue = 2'b11;
				end
				
				//computer guesses this ship but wrong
				else if (phase && !c_guess_res[20] && cguess[20] && !finish) begin
					green = 3'b000;
					red = 3'b000;
					blue = 2'b11;
				end

				else begin
					green = 3'b101;
					red = 3'b101;
					blue = 2'b10;
				end
		end

		//color ship22
		else if (vc >= p_sh22_y && vc < p_sh15_y + ship_len && hc >= p_sh22_x && hc < p_sh22_x + ship_w) begin

				//computer guesses this ship and correct
				if (phase && c_guess_res[21] && cguess[21] && !finish) begin
					green = 3'b000;
					red = 3'b111;
					blue = 2'b00;
				end
				
				//player selected this ship
				else if (pships[21] && !finish) begin
					green = 3'b111;
					red = 3'b111;
					blue = 2'b11;
				end
				
				//computer guesses this ship but wrong
				else if (phase && !c_guess_res[21] && cguess[21] && !finish) begin
					green = 3'b000;
					red = 3'b000;
					blue = 2'b11;
				end

				else begin
					green = 3'b101;
					red = 3'b101;
					blue = 2'b10;
				end
		end
		//color ship23
		else if (vc >= p_sh23_y && vc < p_sh23_y + ship_len && hc >= p_sh23_x && hc < p_sh23_x + ship_w) begin

				//computer guesses this ship and correct
				if (phase && c_guess_res[22] && cguess[22] && !finish) begin
					green = 3'b000;
					red = 3'b111;
					blue = 2'b00;
				end
				
				//player selected this ship
				else if (pships[22] && !finish) begin
					green = 3'b111;
					red = 3'b111;
					blue = 2'b11;
				end
				
				//computer guesses this ship but wrong
				else if (phase && !c_guess_res[22] && cguess[22] && !finish) begin
					green = 3'b000;
					red = 3'b000;
					blue = 2'b11;
				end

				else begin
					green = 3'b101;
					red = 3'b101;
					blue = 2'b10;
				end
		end
		//coloring ship24
		else if (vc >= p_sh24_y && vc < p_sh24_y + ship_w && hc >= p_sh24_x && hc < p_sh24_x + ship_len) begin

				//computer guesses this ship and correct
				if (phase && c_guess_res[23] && cguess[23] && !finish) begin
					green = 3'b000;
					red = 3'b111;
					blue = 2'b00;
				end
				
				//player selected this ship
				else if (pships[23] && !finish) begin
					green = 3'b111;
					red = 3'b111;
					blue = 2'b11;
				end
				
				//computer guesses this ship but wrong
				else if (phase && !c_guess_res[23] && cguess[23] && !finish) begin
					green = 3'b000;
					red = 3'b000;
					blue = 2'b11;
				end

				else begin
					green = 3'b101;
					red = 3'b101;
					blue = 2'b10;
				end
		end
		//color ship25
		else if (vc >= p_sh25_y && vc < p_sh25_y + ship_w && hc >= p_sh26_x && hc < p_sh26_x + ship_len) begin

				//computer guesses this ship and correct
				if (phase && c_guess_res[24] && cguess[24] && !finish) begin
					green = 3'b000;
					red = 3'b111;
					blue = 2'b00;
				end
				
				//player selected this ship
				else if (pships[24] && !finish) begin
					green = 3'b111;
					red = 3'b111;
					blue = 2'b11;
				end
				
				//computer guesses this ship but wrong
				else if (phase && !c_guess_res[24] && cguess[24] && !finish) begin
					green = 3'b000;
					red = 3'b000;
					blue = 2'b11;
				end

				else begin
					green = 3'b101;
					red = 3'b101;
					blue = 2'b10;
				end
		end
		//color ship26
		else if (vc >= p_sh26_y && vc < p_sh26_y + ship_w && hc >= p_sh26_x && hc < p_sh26_x + ship_len) begin

				//computer guesses this ship and correct
				if (phase && c_guess_res[25] && cguess[25] && !finish) begin
					green = 3'b000;
					red = 3'b111;
					blue = 2'b00;
				end
				
				//player selected this ship
				else if (pships[25] && !finish) begin
					green = 3'b111;
					red = 3'b111;
					blue = 2'b11;
				end
				
				//computer guesses this ship but wrong
				else if (phase && !c_guess_res[25] && cguess[25] && !finish) begin
					green = 3'b000;
					red = 3'b000;
					blue = 2'b11;
				end

				else begin
					green = 3'b101;
					red = 3'b101;
					blue = 2'b10;
				end
		end
		//color ship27
		else if (vc >= p_sh27_y && vc < p_sh27_y + ship_len && hc >= p_sh27_x && hc < p_sh27_x + ship_w) begin

				//computer guesses this ship and correct
				if (phase && c_guess_res[26] && cguess[26] && !finish) begin
					green = 3'b000;
					red = 3'b111;
					blue = 2'b00;
				end
				
				//player selected this ship
				else if (pships[26] && !finish) begin
					green = 3'b111;
					red = 3'b111;
					blue = 2'b11;
				end
				
				//computer guesses this ship but wrong
				else if (phase && !c_guess_res[26] && cguess[26] && !finish) begin
					green = 3'b000;
					red = 3'b000;
					blue = 2'b11;
				end

				else begin
					green = 3'b101;
					red = 3'b101;
					blue = 2'b10;
				end
		end
		//color ship28
		else if (vc >= p_sh28_y && vc < p_sh28_y + ship_len && hc >= p_sh28_x && hc < p_sh28_x + ship_w) begin

				//computer guesses this ship and correct
				if (phase && c_guess_res[27] && cguess[27] && !finish) begin
					green = 3'b000;
					red = 3'b111;
					blue = 2'b00;
				end
				
				//player selected this ship
				else if (pships[27] && !finish) begin
					green = 3'b111;
					red = 3'b111;
					blue = 2'b11;
				end
				
				//computer guesses this ship but wrong
				else if (phase && !c_guess_res[27] && cguess[27] && !finish) begin
					green = 3'b000;
					red = 3'b000;
					blue = 2'b11;
				end

				else begin
					green = 3'b101;
					red = 3'b101;
					blue = 2'b10;
				end
		end
		//color black
        else begin
            green = 3'b000;
            red = 3'b000;
            blue = 2'b00;
        end

    end

endmodule


//		else if (vc >= p_sh1_y && vc < p_sh1_y + ship_len && hc >= p_sh1_x && hc < p_sh1_x + ship_w) begin
//			//player selected this ship
//				if (pships[0] && !finish) begin
//					green = 3'b111;
//					red = 3'b111;
//					blue = 2'b11;
//				end
//
//				//computer guesses this ship and correct
//				else if (phase && c_guess_res[0] && cguess[0] && !finish) begin
//					green = 3'b000;
//					red = 3'b111;
//					blue = 2'b00;
//				end
//				
//				//computer guesses this ship but wrong
//				else if (phase && !c_guess_res[0] && cguess[0] && !finish) begin
//					green = 3'b000;
//					red = 3'b000;
//					blue = 2'b11;
//				end
//
//				else begin
//					green = 3'b101;
//					red = 3'b101;
//					blue = 2'b10;
//				end
//		end
//		//coloring ship2
//		else if (vc >= p_sh2_y && vc < p_sh2_y + ship_len && hc >= p_sh2_x && hc < p_sh2_x  + ship_w) begin
//			//player selected this ship
//				if (pships[1] && !finish) begin
//					green = 3'b111;
//					red = 3'b111;
//					blue = 2'b11;
//				end
//
//				//computer guesses this ship and correct
//				else if (phase && c_guess_res[1] && cguess[1] && !finish) begin
//					green = 3'b000;
//					red = 3'b111;
//					blue = 2'b00;
//				end
//				
//				//computer guesses this ship but wrong
//				else if (phase && !c_guess_res[1] && cguess[1] && !finish) begin
//					green = 3'b000;
//					red = 3'b000;
//					blue = 2'b11;
//				end
//
//				else begin
//					green = 3'b101;
//					red = 3'b101;
//					blue = 2'b10;
//				end
//		end
//		//color ship3
//		else if (vc >= p_sh3_y && vc < p_sh3_y + ship_w && hc >= p_sh3_x && hc < p_sh3_x + ship_len) begin
//			//player selected this ship
//				if (pships[2] && !finish) begin
//					green = 3'b111;
//					red = 3'b111;
//					blue = 2'b11;
//				end
//
//				//computer guesses this ship and correct
//				else if (phase && c_guess_res[2] && cguess[2] && !finish) begin
//					green = 3'b000;
//					red = 3'b111;
//					blue = 2'b00;
//				end
//				
//				//computer guesses this ship but wrong
//				else if (phase && !c_guess_res[2] && cguess[2] && !finish) begin
//					green = 3'b000;
//					red = 3'b000;
//					blue = 2'b11;
//				end
//
//				else begin
//					green = 3'b101;
//					red = 3'b101;
//					blue = 2'b10;
//				end
//		end
//		//color ship4
//		else if (vc >= p_sh4_y && vc < p_sh4_y + ship_w && hc >= p_sh4_x && hc < p_sh4_x + ship_len) begin
//			//player selected this ship
//				if (pships[3] && !finish) begin
//					green = 3'b111;
//					red = 3'b111;
//					blue = 2'b11;
//				end
//
//				//computer guesses this ship and correct
//				else if (phase && c_guess_res[3] && cguess[3] && !finish) begin
//					green = 3'b000;
//					red = 3'b111;
//					blue = 2'b00;
//				end
//				
//				//computer guesses this ship but wrong
//				else if (phase && !c_guess_res[3] && cguess[3] && !finish) begin
//					green = 3'b000;
//					red = 3'b000;
//					blue = 2'b11;
//				end
//
//				else begin
//					green = 3'b101;
//					red = 3'b101;
//					blue = 2'b10;
//				end
//		end
//		//color ship5
//		else if (vc >= p_sh5_y && vc < p_sh5_y + ship_w && hc >= p_sh5_x && hc < p_sh5_x + ship_len) begin
//			//player selected this ship
//				if (pships[4] && !finish) begin
//					green = 3'b111;
//					red = 3'b111;
//					blue = 2'b11;
//				end
//
//				//computer guesses this ship and correct
//				else if (phase && c_guess_res[4] && cguess[4] && !finish) begin
//					green = 3'b000;
//					red = 3'b111;
//					blue = 2'b00;
//				end
//				
//				//computer guesses this ship but wrong
//				else if (phase && !c_guess_res[4] && cguess[4] && !finish) begin
//					green = 3'b000;
//					red = 3'b000;
//					blue = 2'b11;
//				end
//
//				else begin
//					green = 3'b101;
//					red = 3'b101;
//					blue = 2'b10;
//				end
//		end
//		//color ship6
//		else if (vc >= p_sh6_y && vc < p_sh6_y + ship_len && hc >= p_sh6_x && hc < p_sh6_x + ship_w) begin
//			//player selected this ship
//				if (pships[5] && !finish) begin
//					green = 3'b111;
//					red = 3'b111;
//					blue = 2'b11;
//				end
//
//				//computer guesses this ship and correct
//				else if (phase && c_guess_res[5] && cguess[5] && !finish) begin
//					green = 3'b000;
//					red = 3'b111;
//					blue = 2'b00;
//				end
//				
//				//computer guesses this ship but wrong
//				else if (phase && !c_guess_res[5] && cguess[5] && !finish) begin
//					green = 3'b000;
//					red = 3'b000;
//					blue = 2'b11;
//				end
//
//				else begin
//					green = 3'b101;
//					red = 3'b101;
//					blue = 2'b10;
//				end
//		end
//		//coloring ship7
//		else if (vc >= p_sh7_y && vc < p_sh7_y + ship_len && hc >= p_sh7_x && hc < p_sh7_x + ship_w) begin
//			//player selected this ship
//				if (pships[6] && !finish) begin
//					green = 3'b111;
//					red = 3'b111;
//					blue = 2'b11;
//				end
//
//				//computer guesses this ship and correct
//				else if (phase && c_guess_res[6] && cguess[6] && !finish) begin
//					green = 3'b000;
//					red = 3'b111;
//					blue = 2'b00;
//				end
//				
//				//computer guesses this ship but wrong
//				else if (phase && !c_guess_res[6] && cguess[6] && !finish) begin
//					green = 3'b000;
//					red = 3'b000;
//					blue = 2'b11;
//				end
//
//				else begin
//					green = 3'b101;
//					red = 3'b101;
//					blue = 2'b10;
//				end
//		end
//		//color ship8
//		else if (vc >= p_sh8_y && vc < p_sh8_y + ship_len && hc >= p_sh8_x && hc < p_sh8_x + ship_w) begin
//			//player selected this ship
//				if (pships[7] && !finish) begin
//					green = 3'b111;
//					red = 3'b111;
//					blue = 2'b11;
//				end
//
//				//computer guesses this ship and correct
//				else if (phase && c_guess_res[7] && cguess[7] && !finish) begin
//					green = 3'b000;
//					red = 3'b111;
//					blue = 2'b00;
//				end
//				
//				//computer guesses this ship but wrong
//				else if (phase && !c_guess_res[7] && cguess[7] && !finish) begin
//					green = 3'b000;
//					red = 3'b000;
//					blue = 2'b11;
//				end
//
//				else begin
//					green = 3'b101;
//					red = 3'b101;
//					blue = 2'b10;
//				end
//		end
//		//color ship9
//		else if (vc >= p_sh9_y && vc < p_sh9_y + ship_len && hc >= p_sh9_x && hc < p_sh9_x + ship_w) begin
//			//player selected this ship
//				if (pships[8] && !finish) begin
//					green = 3'b111;
//					red = 3'b111;
//					blue = 2'b11;
//				end
//
//				//computer guesses this ship and correct
//				else if (phase && c_guess_res[8] && cguess[8] && !finish) begin
//					green = 3'b000;
//					red = 3'b111;
//					blue = 2'b00;
//				end
//				
//				//computer guesses this ship but wrong
//				else if (phase && !c_guess_res[8] && cguess[8] && !finish) begin
//					green = 3'b000;
//					red = 3'b000;
//					blue = 2'b11;
//				end
//
//				else begin
//					green = 3'b101;
//					red = 3'b101;
//					blue = 2'b10;
//				end
//		end
//		//color ship10
//		else if (vc >= p_sh10_y && vc < p_sh10_y + ship_w && hc >= p_sh10_x && hc < p_sh10_x + ship_len) begin
//			//player selected this ship
//				if (pships[9] && !finish) begin
//					green = 3'b111;
//					red = 3'b111;
//					blue = 2'b11;
//				end
//
//				//computer guesses this ship and correct
//				else if (phase && c_guess_res[9] && cguess[9] && !finish) begin
//					green = 3'b000;
//					red = 3'b111;
//					blue = 2'b00;
//				end
//				
//				//computer guesses this ship but wrong
//				else if (phase && !c_guess_res[9] && cguess[9] && !finish) begin
//					green = 3'b000;
//					red = 3'b000;
//					blue = 2'b11;
//				end
//
//				else begin
//					green = 3'b101;
//					red = 3'b101;
//					blue = 2'b10;
//				end
//		end
//		//color ship11
//		else if (vc >= p_sh11_y && vc < p_sh11_y + ship_w && hc >= p_sh11_x && hc < p_sh11_x + ship_len) begin
//			//player selected this ship
//				if (pships[10] && !finish) begin
//					green = 3'b111;
//					red = 3'b111;
//					blue = 2'b11;
//				end
//
//				//computer guesses this ship and correct
//				else if (phase && c_guess_res[10] && cguess[10] && !finish) begin
//					green = 3'b000;
//					red = 3'b111;
//					blue = 2'b00;
//				end
//				
//				//computer guesses this ship but wrong
//				else if (phase && !c_guess_res[10] && cguess[10] && !finish) begin
//					green = 3'b000;
//					red = 3'b000;
//					blue = 2'b11;
//				end
//
//				else begin
//					green = 3'b101;
//					red = 3'b101;
//					blue = 2'b10;
//				end
//		end
//		//coloring ship12
//		else if (vc >= p_sh12_y && vc < p_sh12_y + ship_w && hc >= p_sh12_x && hc < p_sh12_x + ship_len) begin
//			//player selected this ship
//				if (pships[11] && !finish) begin
//					green = 3'b111;
//					red = 3'b111;
//					blue = 2'b11;
//				end
//
//				//computer guesses this ship and correct
//				else if (phase && c_guess_res[11] && cguess[11] && !finish) begin
//					green = 3'b000;
//					red = 3'b111;
//					blue = 2'b00;
//				end
//				
//				//computer guesses this ship but wrong
//				else if (phase && !c_guess_res[11] && cguess[11] && !finish) begin
//					green = 3'b000;
//					red = 3'b000;
//					blue = 2'b11;
//				end
//
//				else begin
//					green = 3'b101;
//					red = 3'b101;
//					blue = 2'b10;
//				end
//		end
//		//color ship13
//		else if (vc >= p_sh13_y && vc < p_sh13_y + ship_len && hc >= p_sh13_x && hc < p_sh13_x + ship_w) begin
//			//player selected this ship
//				if (pships[12] && !finish) begin
//					green = 3'b111;
//					red = 3'b111;
//					blue = 2'b11;
//				end
//
//				//computer guesses this ship and correct
//				else if (phase && c_guess_res[12] && cguess[12] && !finish) begin
//					green = 3'b000;
//					red = 3'b111;
//					blue = 2'b00;
//				end
//				
//				//computer guesses this ship but wrong
//				else if (phase && !c_guess_res[12] && cguess[12] && !finish) begin
//					green = 3'b000;
//					red = 3'b000;
//					blue = 2'b11;
//				end
//
//				else begin
//					green = 3'b101;
//					red = 3'b101;
//					blue = 2'b10;
//				end
//		end
//		//color ship14
//		else if (vc >= p_sh14_y && vc < p_sh14_y + ship_len && hc >= p_sh14_x && hc < p_sh14_x + ship_w) begin
//			//player selected this ship
//				if (pships[13] && !finish) begin
//					green = 3'b111;
//					red = 3'b111;
//					blue = 2'b11;
//				end
//
//				//computer guesses this ship and correct
//				else if (phase && c_guess_res[13] && cguess[13] && !finish) begin
//					green = 3'b000;
//					red = 3'b111;
//					blue = 2'b00;
//				end
//				
//				//computer guesses this ship but wrong
//				else if (phase && !c_guess_res[13] && cguess[13] && !finish) begin
//					green = 3'b000;
//					red = 3'b000;
//					blue = 2'b11;
//				end
//
//				else begin
//					green = 3'b101;
//					red = 3'b101;
//					blue = 2'b10;
//				end
//		end
//		//color ship15
//		else if (vc >= p_sh15_y && vc < p_sh15_y + ship_len && hc >= p_sh15_x && hc < p_sh15_x + ship_w) begin
//			//player selected this ship
//				if (pships[14] && !finish) begin
//					green = 3'b111;
//					red = 3'b111;
//					blue = 2'b11;
//				end
//
//				//computer guesses this ship and correct
//				else if (phase && c_guess_res[14] && cguess[14] && !finish) begin
//					green = 3'b000;
//					red = 3'b111;
//					blue = 2'b00;
//				end
//				
//				//computer guesses this ship but wrong
//				else if (phase && !c_guess_res[14] && cguess[14] && !finish) begin
//					green = 3'b000;
//					red = 3'b000;
//					blue = 2'b11;
//				end
//
//				else begin
//					green = 3'b101;
//					red = 3'b101;
//					blue = 2'b10;
//				end
//		end
//		//color ship16
//		else if (vc >= p_sh16_y && vc < p_sh16_y + ship_len && hc >= p_sh16_x && hc < p_sh16_x + ship_w) begin
//			//player selected this ship
//				if (pships[15] && !finish) begin
//					green = 3'b111;
//					red = 3'b111;
//					blue = 2'b11;
//				end
//
//				//computer guesses this ship and correct
//				else if (phase && c_guess_res[15] && cguess[15] && !finish) begin
//					green = 3'b000;
//					red = 3'b111;
//					blue = 2'b00;
//				end
//				
//				//computer guesses this ship but wrong
//				else if (phase && !c_guess_res[15] && cguess[15] && !finish) begin
//					green = 3'b000;
//					red = 3'b000;
//					blue = 2'b11;
//				end
//
//				else begin
//					green = 3'b101;
//					red = 3'b101;
//					blue = 2'b10;
//				end
//		end
//		//coloring ship17
//		else if (vc >= p_sh17_y && vc < p_sh17_y + ship_w && hc >= p_sh17_x && hc < p_sh17_x + ship_len) begin
//			//player selected this ship
//				if (pships[16] && !finish) begin
//					green = 3'b111;
//					red = 3'b111;
//					blue = 2'b11;
//				end
//
//				//computer guesses this ship and correct
//				else if (phase && c_guess_res[16] && cguess[16] && !finish) begin
//					green = 3'b000;
//					red = 3'b111;
//					blue = 2'b00;
//				end
//				
//				//computer guesses this ship but wrong
//				else if (phase && !c_guess_res[16] && cguess[16] && !finish) begin
//					green = 3'b000;
//					red = 3'b000;
//					blue = 2'b11;
//				end
//
//				else begin
//					green = 3'b101;
//					red = 3'b101;
//					blue = 2'b10;
//				end
//		end
//		//color ship18
//		else if (vc >= p_sh18_y && vc < p_sh18_y + ship_w && hc >= p_sh18_x && hc < p_sh18_x + ship_len) begin
//			//player selected this ship
//				if (pships[17] && !finish) begin
//					green = 3'b111;
//					red = 3'b111;
//					blue = 2'b11;
//				end
//
//				//computer guesses this ship and correct
//				else if (phase && c_guess_res[17] && cguess[17] && !finish) begin
//					green = 3'b000;
//					red = 3'b111;
//					blue = 2'b00;
//				end
//				
//				//computer guesses this ship but wrong
//				else if (phase && !c_guess_res[17] && cguess[17] && !finish) begin
//					green = 3'b000;
//					red = 3'b000;
//					blue = 2'b11;
//				end
//
//				else begin
//					green = 3'b101;
//					red = 3'b101;
//					blue = 2'b10;
//				end
//		end
//		//color ship19
//		else if (vc >= p_sh19_y && vc < p_sh19_y + ship_w && hc >= p_sh19_x && hc < p_sh19_x + ship_len) begin
//			//player selected this ship
//				if (pships[18] && !finish) begin
//					green = 3'b111;
//					red = 3'b111;
//					blue = 2'b11;
//				end
//
//				//computer guesses this ship and correct
//				else if (phase && c_guess_res[18] && cguess[18] && !finish) begin
//					green = 3'b000;
//					red = 3'b111;
//					blue = 2'b00;
//				end
//				
//				//computer guesses this ship but wrong
//				else if (phase && !c_guess_res[18] && cguess[18] && !finish) begin
//					green = 3'b000;
//					red = 3'b000;
//					blue = 2'b11;
//				end
//
//				else begin
//					green = 3'b101;
//					red = 3'b101;
//					blue = 2'b10;
//				end
//		end
//		//color ship20
//		else if (vc >= p_sh20_y && vc < p_sh20_y + ship_len && hc >= p_sh20_x && hc < p_sh20_x + ship_w) begin
//			//player selected this ship
//				if (pships[19] && !finish) begin
//					green = 3'b111;
//					red = 3'b111;
//					blue = 2'b11;
//				end
//
//				//computer guesses this ship and correct
//				else if (phase && c_guess_res[19] && cguess[19] && !finish) begin
//					green = 3'b000;
//					red = 3'b111;
//					blue = 2'b00;
//				end
//				
//				//computer guesses this ship but wrong
//				else if (phase && !c_guess_res[19] && cguess[19] && !finish) begin
//					green = 3'b000;
//					red = 3'b000;
//					blue = 2'b11;
//				end
//
//				else begin
//					green = 3'b101;
//					red = 3'b101;
//					blue = 2'b10;
//				end
//		end
//		//color ship21
//		else if (vc >= p_sh21_y && vc < p_sh21_y + ship_len && hc >= p_sh21_x && hc < p_sh21_x + ship_w) begin
//			//player selected this ship
//				if (pships[20] && !finish) begin
//					green = 3'b111;
//					red = 3'b111;
//					blue = 2'b11;
//				end
//
//				//computer guesses this ship and correct
//				else if (phase && c_guess_res[20] && cguess[20] && !finish) begin
//					green = 3'b000;
//					red = 3'b111;
//					blue = 2'b00;
//				end
//				
//				//computer guesses this ship but wrong
//				else if (phase && !c_guess_res[20] && cguess[20] && !finish) begin
//					green = 3'b000;
//					red = 3'b000;
//					blue = 2'b11;
//				end
//
//				else begin
//					green = 3'b101;
//					red = 3'b101;
//					blue = 2'b10;
//				end
//		end
//
//		//color ship22
//		else if (vc >= p_sh22_y && vc < p_sh15_y + ship_len && hc >= p_sh22_x && hc < p_sh22_x + ship_w) begin
//			//player selected this ship
//				if (pships[21] && !finish) begin
//					green = 3'b111;
//					red = 3'b111;
//					blue = 2'b11;
//				end
//
//				//computer guesses this ship and correct
//				else if (phase && c_guess_res[21] && cguess[21] && !finish) begin
//					green = 3'b000;
//					red = 3'b111;
//					blue = 2'b00;
//				end
//				
//				//computer guesses this ship but wrong
//				else if (phase && !c_guess_res[21] && cguess[21] && !finish) begin
//					green = 3'b000;
//					red = 3'b000;
//					blue = 2'b11;
//				end
//
//				else begin
//					green = 3'b101;
//					red = 3'b101;
//					blue = 2'b10;
//				end
//		end
//		//color ship23
//		else if (vc >= p_sh23_y && vc < p_sh23_y + ship_len && hc >= p_sh23_x && hc < p_sh23_x + ship_w) begin
//			//player selected this ship
//				if (pships[22] && !finish) begin
//					green = 3'b111;
//					red = 3'b111;
//					blue = 2'b11;
//				end
//
//				//computer guesses this ship and correct
//				else if (phase && c_guess_res[22] && cguess[22] && !finish) begin
//					green = 3'b000;
//					red = 3'b111;
//					blue = 2'b00;
//				end
//				
//				//computer guesses this ship but wrong
//				else if (phase && !c_guess_res[22] && cguess[22] && !finish) begin
//					green = 3'b000;
//					red = 3'b000;
//					blue = 2'b11;
//				end
//
//				else begin
//					green = 3'b101;
//					red = 3'b101;
//					blue = 2'b10;
//				end
//		end
//		//coloring ship24
//		else if (vc >= p_sh24_y && vc < p_sh24_y + ship_w && hc >= p_sh24_x && hc < p_sh24_x + ship_len) begin
//			//player selected this ship
//				if (pships[23] && !finish) begin
//					green = 3'b111;
//					red = 3'b111;
//					blue = 2'b11;
//				end
//
//				//computer guesses this ship and correct
//				else if (phase && c_guess_res[23] && cguess[23] && !finish) begin
//					green = 3'b000;
//					red = 3'b111;
//					blue = 2'b00;
//				end
//				
//				//computer guesses this ship but wrong
//				else if (phase && !c_guess_res[23] && cguess[23] && !finish) begin
//					green = 3'b000;
//					red = 3'b000;
//					blue = 2'b11;
//				end
//
//				else begin
//					green = 3'b101;
//					red = 3'b101;
//					blue = 2'b10;
//				end
//		end
//		//color ship25
//		else if (vc >= p_sh25_y && vc < p_sh25_y + ship_w && hc >= p_sh26_x && hc < p_sh26_x + ship_len) begin
//			//player selected this ship
//				if (pships[24] && !finish) begin
//					green = 3'b111;
//					red = 3'b111;
//					blue = 2'b11;
//				end
//
//				//computer guesses this ship and correct
//				else if (phase && c_guess_res[24] && cguess[24] && !finish) begin
//					green = 3'b000;
//					red = 3'b111;
//					blue = 2'b00;
//				end
//				
//				//computer guesses this ship but wrong
//				else if (phase && !c_guess_res[24] && cguess[24] && !finish) begin
//					green = 3'b000;
//					red = 3'b000;
//					blue = 2'b11;
//				end
//
//				else begin
//					green = 3'b101;
//					red = 3'b101;
//					blue = 2'b10;
//				end
//		end
//		//color ship26
//		else if (vc >= p_sh26_y && vc < p_sh26_y + ship_w && hc >= p_sh26_x && hc < p_sh26_x + ship_len) begin
//			//player selected this ship
//				if (pships[25] && !finish) begin
//					green = 3'b111;
//					red = 3'b111;
//					blue = 2'b11;
//				end
//
//				//computer guesses this ship and correct
//				else if (phase && c_guess_res[25] && cguess[25] && !finish) begin
//					green = 3'b000;
//					red = 3'b111;
//					blue = 2'b00;
//				end
//				
//				//computer guesses this ship but wrong
//				else if (phase && !c_guess_res[25] && cguess[25] && !finish) begin
//					green = 3'b000;
//					red = 3'b000;
//					blue = 2'b11;
//				end
//
//				else begin
//					green = 3'b101;
//					red = 3'b101;
//					blue = 2'b10;
//				end
//		end
//		//color ship27
//		else if (vc >= p_sh27_y && vc < p_sh27_y + ship_len && hc >= p_sh27_x && hc < p_sh27_x + ship_w) begin
//			//player selected this ship
//				if (pships[26] && !finish) begin
//					green = 3'b111;
//					red = 3'b111;
//					blue = 2'b11;
//				end
//
//				//computer guesses this ship and correct
//				else if (phase && c_guess_res[26] && cguess[26] && !finish) begin
//					green = 3'b000;
//					red = 3'b111;
//					blue = 2'b00;
//				end
//				
//				//computer guesses this ship but wrong
//				else if (phase && !c_guess_res[26] && cguess[26] && !finish) begin
//					green = 3'b000;
//					red = 3'b000;
//					blue = 2'b11;
//				end
//
//				else begin
//					green = 3'b101;
//					red = 3'b101;
//					blue = 2'b10;
//				end
//		end
//		//color ship28
//		else if (vc >= p_sh28_y && vc < p_sh28_y + ship_len && hc >= p_sh28_x && hc < p_sh28_x + ship_w) begin
//			//player selected this ship
//				if (pships[27] && !finish) begin
//					green = 3'b111;
//					red = 3'b111;
//					blue = 2'b11;
//				end
//
//				//computer guesses this ship and correct
//				else if (phase && c_guess_res[27] && cguess[27] && !finish) begin
//					green = 3'b000;
//					red = 3'b111;
//					blue = 2'b00;
//				end
//				
//				//computer guesses this ship but wrong
//				else if (phase && !c_guess_res[27] && cguess[27] && !finish) begin
//					green = 3'b000;
//					red = 3'b000;
//					blue = 2'b11;
//				end
//
//				else begin
//					green = 3'b101;
//					red = 3'b101;
//					blue = 2'b10;
//				end
//		end
//		//color black
//        else begin
//            green = 3'b000;
//            red = 3'b000;
//            blue = 2'b00;
//        end
//
//    end
//
//endmodule
