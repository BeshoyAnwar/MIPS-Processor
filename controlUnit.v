module Control(input [0:5]op,output RegDst,output Branch,output MemRead,output MemtoReg,output [0:1]ALUOp,output MemWrite,output ALUSrc,output RegWrite);
parameter R_format=0;
parameter Beq=4;
parameter Lw=35;
parameter Sw=43;
assign RegDst=(op==R_format)? 1'b1 : (op==Lw)? 1'b0 : 1'bx;
assign Branch=(op==Beq)? 1'b1 : 1'b0;
assign MemRead=(op==Lw)? 1'b1 : 1'b0;
assign MemtoReg=(op==R_format)? 1'b0:(op==Lw)? 1'b1 : 1'bx;
assign ALUOp=(op==Beq)? 2'b01 : (op==R_format)? 2'b10 : 2'b00;
assign MemWrite=(op==Sw)? 1'b1 : 1'b0;
assign ALUSrc=(op==Lw||op==Sw)? 1'b1 :  1'b0;
assign RegWrite=(op==R_format||op==Lw)? 1'b1 : 1'b0;
endmodule
module ControlTest;
reg [0:5]op;wire [0:1]ALUOp;wire RegDst, Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite;
initial
begin
$monitor("RegDst=%b ALUSrc=%b MemtoReg=%b RegWrite=%b MemRead=%b MemWrite=%b Branch=%b ALUOp=%b",RegDst,ALUSrc,MemtoReg,RegWrite,MemRead,MemWrite,Branch,ALUOp);
#10
op=0;
#10
op=35;
#10
op=43;
#10
op=4;
end
Control controlUnit(op, RegDst, Branch, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite);
endmodule
