module forward(input [4:0] RegLw,input[4:0] RegSw,input WriteEnable,input MemToRegWrite,input memWrite,output forwardF);

	assign forwardF=((WriteEnable==1'b1)&&(MemToRegWrite==1'b1)&&(RegLw==RegSw)&&(RegLw!=5'b00000)&&(RegSw!=5'b00000)&&(memWrite==1'b1))?1'b1:1'b0;
always @(forwardF)
$display("forward");
endmodule

module forwardtb;
reg[4:0] RegLw;reg[4:0] RegSw ;reg WriteEnable;reg MemToRegWrite;reg memWrite;wire forwardF;
initial
begin
$monitor($time,"RegLw %b RegSw %b WriteEnable %b MemToRegWrite %b memWrite %b forwardF %b",RegLw,RegSw ,WriteEnable,MemToRegWrite,memWrite, forwardF);
#10
RegLw=5'b10101;
RegSw =5'b10101;
WriteEnable=1'b1;
MemToRegWrite=1'b1;
memWrite=1'b1;
#10
RegLw=5'b10100;
RegSw =5'b10101;
WriteEnable=1'b1;
MemToRegWrite=1'b1;
memWrite=1'b1;
#10
RegLw=5'b10101;
RegSw =5'b10101;
WriteEnable=1'b0;
MemToRegWrite=1'b1;
memWrite=1'b0;
#10
RegLw=5'b10101;
RegSw =5'b10101;
WriteEnable=1'b1;
MemToRegWrite=1'b0;
memWrite=1'b1;
end
forward f1(RegLw,RegSw,WriteEnable,MemToRegWrite,memWrite,forwardF);
endmodule
