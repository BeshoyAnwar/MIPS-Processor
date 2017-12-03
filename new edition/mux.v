module mux (input selCh, input [31:0] inCh0, input [31:0] inCh1, output [31:0] selData);

	assign selData = selCh == 0 ? inCh0 : 
                     selCh == 1 ? inCh1 : 0;

endmodule
module mux5bits (input selCh, input [4:0] inCh0, input [4:0] inCh1, output [4:0] selData);

	assign selData = selCh == 0 ? inCh0 : 
                     selCh == 1 ? inCh1 : 0;

endmodule
module mux4to1 (input [1:0] selCh, input [31:0] inCh0, input [31:0] inCh1, input [31:0] inCh2, input [31:0] inCh3, output [31:0] selData);

	assign selData = selCh == 2'b00 ? inCh0 : 
                     selCh == 2'b01 ? inCh1 :
                     selCh == 2'b10 ? inCh2 :
                     selCh == 2'b11 ? inCh3 : 32'bx;

endmodule