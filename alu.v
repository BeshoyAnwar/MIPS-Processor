module alu (input signed [31:0] in1, input signed [31:0] in2, input [3:0] opCode, input [4:0] shiftAmt, output signed [31:0] result, output overflow, output zero);

	assign result = opCode == 0 ? in1 + in2 :
			        opCode == 1 ? in1 - in2 :
	        		opCode == 2 ? in1 & in2 :
			        opCode == 3 ? in1 | in2 :
        			opCode == 4 ? in1 << shiftAmt :
		        	opCode == 5 ? in1 >> shiftAmt :
		        	opCode == 6 ? in1 >>> shiftAmt :
        			opCode == 7 ? in1 > in2 ? 1 : 0 :
		        	opCode == 8 ? in1 < in2 ? 1 : 0 : 0;

    assign overflow = (in1[31] == in2[31] && result[31] != in1[31]) ? 1 : 0;

    assign zero = result == 0 ? 1 : 0;

endmodule

module alu_tb;

	reg signed [31:0] in1;
	reg signed [31:0] in2;
	reg [3:0] opCode;
	reg [4:0] shiftAmt;
	wire signed [31:0] result;
    wire overflow;
    wire zero;

	initial begin

		// $monitor ("in1:%d in2:%d opCode:%d shiftAmt:%d result:%d", in1, in2, opCode, shiftAmt, result);
		$monitor ("result = %d!", zero);

		shiftAmt = 0;
		#10 opCode = 0; in1 = 5; in2 = 7; #2 $display ("%d + %d = %d with overflow = %d", in1, in2, result, overflow);
		#10 in1 = -5; in2 = -7; #2 $display ("%d + %d = %d with overflow = %d", in1, in2, result, overflow);
		#10 in1 = -5; in2 = 7; #2 $display ("%d + %d = %d with overflow = %d", in1, in2, result, overflow);
		#10 in1 = 5; in2 = -7; #2 $display ("%d + %d = %d with overflow = %d", in1, in2, result, overflow);
		#10 in1 = 2147483648; in2 = 2147483648; #2 $display ("%d + %d = %d with overflow = %d", in1, in2, result, overflow);

		#10 opCode = 1; in1 = 5; in2 = 7; #2 $display ("%d - %d = %d with overflow = %d", in1, in2, result, overflow);
		#10 in1 = -5; in2 = -7; #2 $display ("%d - %d = %d with overflow = %d", in1, in2, result, overflow);
		#10 in1 = -5; in2 = 7; #2 $display ("%d - %d = %d with overflow = %d", in1, in2, result, overflow);
		#10 in1 = 5; in2 = -7; #2 $display ("%d - %d = %d with overflow = %d", in1, in2, result, overflow);

		#10	opCode = 2;	in1 = 1; in2 = 1; #2 $display ("%d & %d = %d", in1, in2, result);
		#10 in2 = 0; #2 $display ("%d & %d = %d", in1, in2, result);
		#10 in1 = 0; #2 $display ("%d & %d = %d", in1, in2, result);
		#10 in2 = 1; #2 $display ("%d & %d = %d", in1, in2, result);

		#10 opCode = 3; in1 = 1; #2 $display ("%d | %d = %d", in1, in2, result);
		#10 in2 = 0; #2 $display ("%d | %d = %d", in1, in2, result);
		#10 in1 = 0; #2 $display ("%d | %d = %d", in1, in2, result);
		#10 in2 = 1; #2 $display ("%d | %d = %d", in1, in2, result);

		#10 opCode = 4; in1 = 1; shiftAmt = 1; #2 $display ("%b << %d = %b", in1, shiftAmt, result);
		#10 in1 = 2; shiftAmt = 2; #2 $display ("%b << %d = %b", in1, shiftAmt, result);
		#10 in1 = 4; shiftAmt = 3; #2 $display ("%b << %d = %b", in1, shiftAmt, result);
		#10 in1 = 8; shiftAmt = 4; #2 $display ("%b << %d = %b", in1, shiftAmt, result);

		#10 opCode = 5; in1 = 16; shiftAmt = 1; #2 $display ("%b >> %d = %b", in1, shiftAmt, result);
		#10 in1 = 2; #2 $display ("%b >> %d = %b", in1, shiftAmt, result);
		#10 in1 = 4; shiftAmt = 3; #2 $display ("%b >> %d = %b", in1, shiftAmt, result);
		#10 in1 = 8; shiftAmt = 4; #2 $display ("%b >> %d = %b", in1, shiftAmt, result);
		#10 in1 = -16; shiftAmt = 1; #2 $display ("%b >> %d = %b", in1, shiftAmt, result);
		#10 in1 = -2; #2 $display ("%b >> %d = %b", in1, shiftAmt, result);
		#10 in1 = -4; shiftAmt = 3; #2 $display ("%b >> %d = %b", in1, shiftAmt, result);
		#10 in1 = -8; shiftAmt = 4; #2 $display ("%b >> %d = %b", in1, shiftAmt, result);

		#10 opCode = 6; in1 = 16; shiftAmt = 1; #2 $display ("%b >>> %d = %b", in1, shiftAmt, result);
		#10 in1 = 2; #2 $display ("%b >>> %d = %b", in1, shiftAmt, result);
		#10 in1 = 4; shiftAmt = 3; #2 $display ("%b >>> %d = %b", in1, shiftAmt, result);
		#10 in1 = 8; shiftAmt = 4; #2 $display ("%b >>> %d = %b", in1, shiftAmt, result);
		#10 in1 = -16; shiftAmt = 1; #2 $display ("%b >>> %d = %b", in1, shiftAmt, result);
		#10 in1 = -2; #2 $display ("%b >>> %d = %b", in1, shiftAmt, result);
		#10 in1 = -4; shiftAmt = 3; #2 $display ("%b >>> %d = %b", in1, shiftAmt, result);
		#10 in1 = -8; shiftAmt = 4; #2 $display ("%b >>> %d = %b", in1, shiftAmt, result);

		#10 opCode = 7; in1 = 16; in2 = 7; #2 $display ("%d > %d = %d", in1, in2, result);
		#10 in1 = -16; in2 = -7; #2 $display ("%d > %d = %d", in1, in2, result);
		#10 in1 = -16; in2 = 7; #2 $display ("%d > %d = %d", in1, in2, result);
		#10 in1 = 16; in2 = -7; #2 $display ("%d > %d = %d", in1, in2, result);

		#10 opCode = 8; in1 = 16; in2 = 7; #2 $display ("%d < %d = %d", in1, in2, result);
		#10 in1 = -16; in2 = -7; #2 $display ("%d < %d = %d", in1, in2, result);
		#10 in1 = -16; in2 = 7; #2 $display ("%d < %d = %d", in1, in2, result);
		#10 in1 = 16; in2 = -7; #2 $display ("%d < %d = %d", in1, in2, result);

	end

	alu alu1 (in1, in2, opCode, shiftAmt, result, overflow, zero);

endmodule
