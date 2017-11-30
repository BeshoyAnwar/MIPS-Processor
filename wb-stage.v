module writeBack (input [70:0]memWbReg, output [31:0] wbData);

	mux mux1(memWbReg[70], memWbReg[69:38], memWbReg[31:0], wbData);

endmodule

module writeBack_tb ();

	reg [70:0] memWbReg;
	wire [31:0] wbData;

	initial begin

		$monitor ("memWbReg:%h wbData: %h", memWbReg, wbData);
		
		memWbReg = { 71 {1'b0} };

		#10 memWbReg[31:0] = 32'h43242243; memWbReg[69:38] = 32'h34877329; memWbReg[70] = 1;
		#10 memWbReg[31:0] = 32'h12345678; memWbReg[69:38] = 32'h3277fa82; memWbReg[70] = 0;
		#10 memWbReg[31:0] = 32'h87654321; memWbReg[69:38] = 32'h12121212; memWbReg[70] = 1;
		#10 memWbReg[31:0] = 32'h748230a5; memWbReg[69:38] = 32'h87340923; memWbReg[70] = 0;
		#10 memWbReg[31:0] = 32'h84923221; memWbReg[69:38] = 32'h12883940; memWbReg[70] = 1;

	end

	writeBack wb1(memWbReg, wbData);

endmodule