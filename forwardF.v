
module forward(input [4:0] RegLw,input[4:0] RegSw,input WriteEnable,input memToReg, output [1:0]forwardF);
assign forwardF=((WriteEnable==1'b1)&&(RegLw==RegSw)&&(RegLw!=5'b00000)&&(memToReg==1'b1))?2'b01:
((WriteEnable==1'b1)&&(RegLw==RegSw)&&(RegLw!=5'b00000)&&(memToReg==1'b0))?2'b10:2'b00;
always @(forwardF)
$display("forward:%d",forwardF);
endmodule

module forwardtb;
reg[4:0] RegLw;reg[4:0] RegSw ;reg WriteEnable;reg memWrite;wire [1:0] forwardF;reg clk;reg memToReg;
always 
#5 clk=!clk;
initial
begin
clk=0;
$monitor($time,"RegLw %b RegSw %b WriteEnable %b memWrite %b forwardF %b",RegLw,RegSw ,WriteEnable,memWrite, forwardF);
#10
RegLw=5'b10101;
RegSw =5'b10101;
WriteEnable=1'b1;
memWrite=1'b1;
memToReg=1'b1;
#10
RegLw=5'b10100;
RegSw =5'b10101;
WriteEnable=1'b1;
memWrite=1'b1;
memToReg=1'b0;
#10
RegLw=5'b10101;
RegSw =5'b10101;
WriteEnable=1'b0;
memWrite=1'b0;
memToReg=1'b1;
#10
RegLw=5'b10101;
RegSw =5'b10101;
WriteEnable=1'b1;
memWrite=1'b1;
memToReg=1'b0;
end
forward f1(RegLw,RegSw,WriteEnable,memToReg,forwardF);
endmodule
