module fibonacci_top
(
	input clk,
	input reset_n,
	input start,
	input [2:0] i,
	output ready,
	output [7:0] sseg,
	output [3:0] sel
);

wire [19:0] f;
wire start_db;
wire done_tick;
wire [3:0] bcd [3:0];

db_fsm db_fsm_inst
(
	.clk(clk),
	.reset_n(reset_n),
	.sw(!start),
	.db(start_db)
);

fibonacci fibonacci_inst
(
	.clk(clk),.reset_n(reset_n),
	.start(start_db),
	.i(~i),
	.ready(ready), .done_tick(done_tick),
	.f(f)
);

bin_to_bcd bin_to_bcd_inst
(
   .bin(f[13:0]),
   .bcd({bcd[3],bcd[2],bcd[1],bcd[0]})   
);

sseg_time_mux sseg_time_mux_inst
(
	.clk(clk),
	.hex0(bcd[0]),.hex1(bcd[1]),.hex2(bcd[2]),.hex3(bcd[3]),
	.dp(4'b1110),
	.sel(sel),
	.sseg(sseg)
);

endmodule