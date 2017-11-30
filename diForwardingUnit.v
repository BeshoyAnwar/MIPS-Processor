module diForwardingUnit (input [63:0] IFIDReg, input [74:0] EXMEReg, input [70:0] MEWBReg, output reg[1:0] regFileRead1MuxSignal, output reg[1:0] regFileRead2MuxSignal);

	parameter beqOperation = 6'b000100,
			  frwrdFromEXMEM = 1'b0,
			  frwrdFromMEMWB = 1'b1;

	wire readReg1;
	wire readReg2;
	wire operation;
	reg frwrdReg1;
	reg frwrdReg1Data;
	reg frwrdReg2;
	reg frwrdReg2Data;

	assign readReg1 = IFIDReg [25:21];
	assign readReg2 = IFIDReg [20:16];
	assign operation = IFIDReg [31:26];

	initial begin frwrdReg1 = 0; frwrdReg1Data = 0; frwrdReg2Data = 0; frwrdReg2 = 0; end

	always begin

		if (readReg1 == EXMEReg [68:64] && operation == beqOperation) begin
			frwrdReg1 <= 1;
			frwrdReg1Data <= frwrdFromEXMEM;
		end
		else if (readReg1 == MEWBReg [36:32] && operation == beqOperation) begin
			frwrdReg1 <= 1;
			frwrdReg1Data <= frwrdFromMEMWB;
		end
		else frwrdReg1 <= 0;
		if (readReg2 == EXMEReg [68:64] && operation == beqOperation) begin
			frwrdReg2 <= 1;
			frwrdReg2Data <= frwrdFromEXMEM;
		end
		else if (readReg2 == MEWBReg [36:32] && operation == beqOperation) begin
			frwrdReg2 <= 1;
			frwrdReg2Data <= frwrdFromMEMWB;
		end
		else frwrdReg2 <= 0;

		regFileRead1MuxSignal <= {frwrdReg1, frwrdReg1Data};
		regFileRead1MuxSignal <= {frwrdReg2, frwrdReg2Data};

	end

endmodule

module diForwardingUnit_tb ();

endmodule