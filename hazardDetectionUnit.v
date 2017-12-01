module hazardDetectionUnit ( input [4:0]IFIDRegrs , input [4:0]IFIDRegrt , input [4:0]IDEXRegrt , input [5:0] opcode , output reg controlMUX , output reg IFIDRegHOLD , output reg pcHOLD ,output reg IFflush);

parameter beqOPcode = 6'b000100 , lwOPcode = 6'b100011 ;

initial
begin
controlMUX =0;
IFIDRegHOLD =0;
pcHOLD =0;
IFflush=0;
end

always@(*)
begin
if (opcode==lwOPcode && ((IDEXRegrt == IFIDRegrs) || (IDEXRegrt == IFIDRegrt)))
begin
controlMUX=1;
IFIDRegHOLD=1;
pcHOLD=1;
IFflush=1;
end
else if (opcode==beqOPcode && ((IDEXRegrt == IFIDRegrs) || (IDEXRegrt == IFIDRegrt)))
begin
controlMUX=1;
IFIDRegHOLD=0;
pcHOLD=0;
IFflush=1;
end

else
begin
controlMUX=0;
IFIDRegHOLD=0;
pcHOLD=0;
IFflush=0;
end

end


endmodule


module hazardUnitTB ;

reg [4:0]IFIDRegrs;
reg [4:0]IFIDRegrt;
reg [4:0]IDEXRegrt;
reg [5:0] OPcode ;
wire controlMUX ;
wire IFIDRegHOLD;
wire pcHOLD ;
wire IFflush ;

initial
begin

$monitor ("OPcode =%d ,IFIDRegrs=%d , IFIDRegrt=%d , IDEXRegrt=%d , controlMUX=%d , IFIDRegHOLD=%d ,  pcHOLD=%d , IFflush=%d" , OPcode,IFIDRegrs , IFIDRegrt , IDEXRegrt ,  controlMUX , IFIDRegHOLD ,  pcHOLD , IFflush );

#10
IFIDRegrs=0;
IFIDRegrt=5;
IDEXRegrt=1;
OPcode=0;


#10
IFIDRegrs=5;
IFIDRegrt=7;
IDEXRegrt=7;
OPcode=35;

#10
IFIDRegrs=5;
IFIDRegrt=7;
IDEXRegrt=7;
OPcode=4;


#10
IFIDRegrs=10;
IFIDRegrt=9;
IDEXRegrt=10;
OPcode=0;


#10
IFIDRegrs=10;
IFIDRegrt=9;
IDEXRegrt=10;
OPcode=4;
end

hazardDetectionUnit  hazardUnitTEST ( IFIDRegrs , IFIDRegrt , IDEXRegrt , OPcode , controlMUX ,IFIDRegHOLD , pcHOLD ,IFflush);

endmodule
