`timescale 1ns / 1ps

module battle_ship(
      input wire clk,			//master clock = 50MHz
      input wire clr,
      input wire btnU,
      input wire btnD,
      input wire btnR,
      input wire btnL,
      input wire sel,
	    input sw,
      output wire [2:0] red,	//red vga output - 3 bits
      output wire [2:0] green,  //green vga output - 3 bits
      output wire [1:0] blue,	    //blue vga output - 2 bits
      output wire [3:0] an,
      output wire [7:0] seg,
      output wire hsync,		//horizontal sync out
      output wire vsync			//vertical sync out
	);

	// clocks
  	wire clock_1Hz;
	wire clock_800Hz;
	wire clock_25Mhz;
	wire clock_4Hz;
	wire segclk;

	// Turn vars
	wire turn;
	
	// phase vars
	wire phase;
  wire finish;
	
	// Select vars
	wire [27: 0] pships;
	wire [27: 0] cships;
  wire [27: 0] c_curr_guess;
  wire [27: 0] p_curr_guess;
	assign cships = 28'b1000000100010000000000010000;

	// debounced buttons
	wire db_btnR;
	wire db_btnL;
	wire db_btnU;
	wire db_btnD;
	wire db_btnSel;
	wire db_btnRst;
	
	// debouncers
	debouncer db_r(
    .clk (clock_4Hz),
    .btn_in (btnR),
    .btn_out (db_btnR)
	);
	debouncer db_l(
		.clk (clock_4Hz),
		.btn_in (btnL),
		.btn_out (db_btnL)
	);
	debouncer db_u(
		.clk (clock_4Hz),
		.btn_in (btnU),
		.btn_out (db_btnU)
	);
	debouncer db_d(
		.clk (clock_4Hz),
		.btn_in (btnD),
		.btn_out (db_btnD)
	);
	debouncer db_sel(
		.clk (clock_4Hz),
		.btn_in (sel),
		.btn_out (db_btnSel)
	);
	debouncer db_rst(
		.clk (clock_4Hz),
		.btn_in (clr),
		.btn_out (db_btnRst)
	);
	
	//clocks
//  clockdiv myClocks(
//    .clk (clk),
//    .clock_25Mhz (clock_25Mhz),
//    .clock_4Hz (clock_4Hz),
//    .clock_800Hz (clock_800Hz),
//    .clock_1Hz (clock_1Hz)
//  );
  
  clockdiv myClock(
		.clk(clk),
		.clr(clr),
		.segclk(segclk),
		.dclk(clock_25Mhz),
		.clock_4Hz(clock_4Hz),
		.clock_1Hz(clock_1Hz)
	);


	// VGA display
	wire [27:0] cguess;
	wire [27:0] pguess;
	
	vga640x480 myDisplay(
		.clk(clock_25Mhz),
		.rst(clr),
		.phase(phase),
    .finish (finish),
		.cships(cships),
		.pships(pships),
		.hsync(hsync),
		.vsync(vsync),
		.cguess(cguess),
		.pguess(pguess),
		.red(red),
		.green(green),
		.blue(blue)
	);

	//confirm select
	select_phase confirm_select(
		.clk (clock_4Hz),
		.sel (db_btnSel),
		.seg (seg),
		.an (an),
		.phase (phase),
		.pships (pships)
	);
  
	//ship segments
	select mySelections(
		.clk (clock_4Hz),
		.rst (db_btnRst),     	//rst switch
		.phase (phase),   		//phase switch
		.sel  (db_btnSel),     	//select btn
		.btnU (db_btnU),
		.btnR (db_btnR),
		.btnL (db_btnL),
		.btnD (db_btnD),
		.seg (seg),
		.an (an)
	);

  //correct guess counter
  correct_guess_counter correct_guesses(
      .clk (clock_4Hz),
      .sel (db_btnSel),
      .phase(phase),
      .sw (sw),
      .c_curr_guess (c_curr_guess),
      .p_curr_guess (p_curr_guess),
      .cships (cships),
      .pships (pships),
      .finish (finish)
  ); 
	
	// game phase
	game_phase myGame(     
		.clk (clock_4Hz),
		.sel (db_btnSel),    
		.rst (db_btnRst),
		.phase (phase),	
		.sw (sw),
		.seg (seg),
		.an (an),
		.pships (pguess),    // actually represents pguess
    .sing_guess (p_curr_guess)    //player's curr guess
	);
	
	// computer guesses
	c_guess_generator cguesses
	(
		 .clk (clock_4Hz),
		 .sel (db_btnSel),         //middle btn
		 .rst (db_btnRst),
		 .sw (sw),
		 .phase (phase),
		 .comp_guess (cguess),
     .sing_guess (c_curr_guess)   //computer's curr guess
	);

endmodule