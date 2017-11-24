module dataMemory (input wrEnable, input [4:0] wrAddress, input [31:0] wrData, input [4:0] rdAddress, output [31:0] rdData, input clk);

	reg [31:0] memFile [0:31];

	assign rdData = memFile[rdAddress];

	always @(posedge clk)
        if (wrEnable)
            memFile[wrAddress] <= wrData;

endmodule

module dataMemory_tb;

    reg wrEnable;
    reg [4:0] wrAddress;
    reg [31:0] wrData;
    reg [4:0] rdAddress;
    wire [31:0] rdData;
    reg clk;

    always begin #5 clk = ~clk; end

    integer index;
    
	initial begin

        $monitor ("rdAddress:%d rdData:%d", rdAddress, rdData);

        clk = 0;

		wrEnable = 1;
		for (index = 0; index < 32; index = index + 1) begin
            #5 wrAddress = index; wrData = index * 2;
            $display ("wrAddress:%d wrData:%d", wrAddress, wrData);
        end
		#10 wrEnable = 0; wrAddress = 31; wrData = 93;

        #10 rdAddress = 0;
        #10 rdAddress = 3;
        #10 rdAddress = 4;
        #10 rdAddress = 7;
        #10 rdAddress = 8;
        #10 rdAddress = 9;
        #10 rdAddress = 22;
        #10 rdAddress = 11;
        #10 rdAddress = 5;
        #10 rdAddress = 2;

	end

    dataMemory dm1 (wrEnable, wrAddress, wrData, rdAddress, rdData, clk);

endmodule