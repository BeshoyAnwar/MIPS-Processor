module diForwardingUnit (input [4:0] regFileReadReg1, input [4:0] regFileReadReg2, input [5:0] operation, input EXMEWriteSignal, input [4:0] EXMEWriteReg, input MEWBWriteSignal, input [4:0] MEWBWriteReg, output reg[1:0] regFileRead1MuxSignal, output reg[1:0] regFileRead2MuxSignal);

	parameter beqOperation = 6'b000100,
			  frwrdFromEXMEM = 1'b0,
			  frwrdFromMEMWB = 1'b1;

	reg frwrdReg1;
	reg frwrdReg1Data;
	reg frwrdReg2;
	reg frwrdReg2Data;

	initial begin frwrdReg1 = 0; frwrdReg1Data = 0; frwrdReg2Data = 0; frwrdReg2 = 0; end

	always @* begin

		if (regFileReadReg1 == EXMEWriteReg && operation == beqOperation && EXMEWriteSignal == 1'b1) begin
			frwrdReg1 <= 1;
			frwrdReg1Data <= frwrdFromEXMEM;
		end
		else if (regFileReadReg1 == MEWBWriteReg && operation == beqOperation && MEWBWriteSignal == 1'b1) begin
			frwrdReg1 <= 1;
			frwrdReg1Data <= frwrdFromMEMWB;
		end
		else frwrdReg1 <= 0;
		if (regFileReadReg2 == EXMEWriteReg && operation == beqOperation && EXMEWriteSignal == 1'b1) begin
			frwrdReg2 <= 1;
			frwrdReg2Data <= frwrdFromEXMEM;
		end
		else if (regFileReadReg2 == MEWBWriteReg && operation == beqOperation && MEWBWriteSignal == 1'b1) begin
			frwrdReg2 <= 1;
			frwrdReg2Data <= frwrdFromMEMWB;
		end
		else frwrdReg2 <= 0;

		regFileRead1MuxSignal <= {frwrdReg1, frwrdReg1Data};
		regFileRead2MuxSignal <= {frwrdReg2, frwrdReg2Data};

	end

endmodule

module diForwardingUnit_tb ();

	reg [4:0] regFileReadReg1;
	reg [4:0] regFileReadReg2;
	reg [5:0] operation;
	reg EXMEWriteSignal;
	reg [4:0] EXMEWriteReg;
	reg MEWBWriteSignal;
	reg [4:0] MEWBWriteReg;
	wire [1:0] regFileRead1MuxSignal;
	wire [1:0] regFileRead2MuxSignal;

	initial begin

		$monitor("regFileRead1MuxSignal: %b regFileRead2MuxSignal: %b when regFileReadReg1: %d regFileReadReg2: %d operation: %b EXMEWriteSignal: %b EXMEWriteReg: %d MEWBWriteSignal: %b MEWBWriteReg: %d", regFileRead1MuxSignal, regFileRead2MuxSignal, regFileReadReg1, regFileReadReg2, operation, EXMEWriteSignal, EXMEWriteReg, MEWBWriteSignal, MEWBWriteReg);

		regFileReadReg1 = 5'd0; regFileReadReg2 = 5'd1; operation = 6'b000100; EXMEWriteSignal = 1; EXMEWriteReg = 5'd0; MEWBWriteSignal = 1; MEWBWriteReg = 5'd1;

		#10 regFileReadReg1 = 5'd12; regFileReadReg2 = 5'd9;
		#10 EXMEWriteReg = 5'd9;
		#10 EXMEWriteSignal = 0;
		#10 MEWBWriteReg = 5'd12;
		#10 MEWBWriteSignal = 0;
		#10 EXMEWriteSignal = 1; MEWBWriteSignal = 1;
		#10 operation = 6'b000000;

	end

	diForwardingUnit diFU1 (regFileReadReg1, regFileReadReg2, operation, EXMEWriteSignal, EXMEWriteReg, MEWBWriteSignal, MEWBWriteReg, regFileRead1MuxSignal, regFileRead2MuxSignal);

endmodule
