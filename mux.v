module mux (input selCh, input [31:0] inCh0, input [31:0] inCh1, output [31:0] selData);

	assign selData = selCh == 0 ? inCh0 : 
                     selCh == 1 ? inCh1 : 0;

endmodule

module mux_tb;

	reg selCh;
	reg [31:0] inCh0;
	reg [31:0] inCh1;
	wire [31:0] selData;

	initial begin

		$monitor ("selCh:%d inCh0:%d inCh1:%d selData:%d", selCh, inCh0, inCh1, selData);

		#10 selCh = 0; inCh0 = 102; inCh1 = 15;
		#10 selCh = 1;
		#10 inCh0 = 53;
		#10 inCh1 = 77;
		#10 selCh = 0;

	end

	mux m1 (selCh, inCh0, inCh1, selData);

endmodule
