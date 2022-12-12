module fibonacci(
	input clk,reset_n,
	input start,
	input [2:0] i,
	output reg ready, done_tick,
	output [19:0] f
);
localparam [1:0]
idle=2'b00,
op=2'b01,
done=2'b10;

reg [1:0] current_state,next_state;
reg [19:0] t0_reg,t0_next,t1_reg,t1_next;
reg [2:0] n_reg,n_next;
always @(posedge clk or negedge reset_n)
begin
	if(!reset_n)
	begin
		current_state<=idle;
		t0_reg<=0;
		t1_reg<=0;
		n_reg<=0;
	end
	else
	begin
		current_state<=next_state;
		t0_reg<=t0_next;
		t1_reg<=t1_next;
		n_reg<=n_next;
	end
end
always @*
begin
	next_state = current_state;
	ready = 0;
	done_tick = 0;
	t0_next = t0_reg;
	t1_next = t1_reg;
	n_next = n_reg;
	case(current_state)
		idle:
		begin
			ready=1;
			if(start)
			begin
				t0_next = 0;
				t1_next=1;
				n_next=i;
				next_state=op;
			end
		end
		op:
		begin
			if(n_reg==0)
			begin
				t1_next = 0;
				next_state = done;
			end
			else if(n_reg == 1)
				next_state = done;
			else
			begin
				t1_next = t1_reg + t0_reg;
				t0_next = t1_reg;
				n_next = n_reg - 1;
			end
		end
		done:
		begin
			done_tick = 1;
			//next_state = idle;
		end
		default: next_state = idle;
	endcase
end
assign f=t1_reg;

endmodule