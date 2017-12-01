module instructionFetch (input branchResult, input [31:0] branchAddrs, input stall, output reg [63:0] instructionFetchReg, input clk);

	wire [31:0] adderAddrs;
	wire [31:0] pcInput;
	wire [31:0] pcOutput;
	wire [31:0] instruction;
	wire [1:0] muxSelection;

	initial instructionFetchReg = { 64 {1'b0} };

	assign muxSelection = {stall, branchResult};

	mux4to1 addrsMux1(muxSelection, adderAddrs, branchAddrs, pcOutput, pcOutput, pcInput);
	PC pc1 (pcOutput, pcInput, clk);
	insMemory im1 (pcOutput >> 2, instruction); 
	adder adder1 (pcOutput, 32'd4, adderAddrs);

	always @(posedge clk)
	begin
		instructionFetchReg <= {instruction, pcOutput};
	end

endmodule

module instructionFetch_tb ();

	reg branchResult;
	reg [31:0] branchAddrs;
	reg stall;
	wire [63:0] instructionFetchReg;
	reg clk;
	
	always begin #5 clk = ~clk; end

	initial begin

		$monitor ("instructionFetchReg:%h branchResult: %b branchAddrs : %d stall: %b", instructionFetchReg, branchResult, branchAddrs, stall);

		branchResult = 0; branchAddrs = { 32 {1'b0} }; stall = 0; clk = 0;
		#28 branchResult = 0; branchAddrs = 32'd7; stall = 1;
		#5 branchResult = 1;
		#5 branchResult = 0;
		#90
		#22 stall = 0;
		#28 branchResult = 0; branchAddrs = 32'd3; stall = 1;
		#22 stall = 0;

	end

	instructionFetch if1(branchResult, branchAddrs, stall, instructionFetchReg, clk);

endmodule
