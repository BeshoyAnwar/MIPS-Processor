module hazardDetectionUnit ( input [4:0]IFIDRegrs , input [4:0]IFIDRegrt , input [4:0]IDEXRegrt , input memRead , output reg controlMUX , output reg IFIDRegHOLD , output reg pcHOLD );


initial
begin
controlMUX =0;
IFIDRegHOLD =0;
pcHOLD =0;
end

always@(*)
begin
if (memRead && ((IDEXRegrt == IFIDRegrs) || (IDEXRegrt == IFIDRegrt)))
begin
controlMUX=1;
IFIDRegHOLD=1;
pcHOLD=1;
end
else
begin
controlMUX=0;
IFIDRegHOLD=0;
pcHOLD=0;
end

end


endmodule


module hazardUnitTB ;

reg [4:0]IFIDRegrs;
reg [4:0]IFIDRegrt;
reg [4:0]IDEXRegrt;
reg memRead;
wire controlMUX ;
wire IFIDRegHOLD;
wire pcHOLD ;

initial
begin

$monitor ("IFIDRegrs=%d , IFIDRegrt=%d , IDEXRegrt=%d , memRead=%d , controlMUX=%d , IFIDRegHOLD=%d ,  pcHOLD=%d " , IFIDRegrs , IFIDRegrt , IDEXRegrt , memRead , controlMUX , IFIDRegHOLD ,  pcHOLD );

#10
IFIDRegrs=0;
IFIDRegrt=5;
IDEXRegrt=1;
memRead=1;


#10
IFIDRegrs=5;
IFIDRegrt=7;
IDEXRegrt=7;
memRead=0;

#10
IFIDRegrs=5;
IFIDRegrt=7;
IDEXRegrt=7;
memRead=1;


#10
IFIDRegrs=10;
IFIDRegrt=9;
IDEXRegrt=10;
memRead=0;


#10
IFIDRegrs=10;
IFIDRegrt=9;
IDEXRegrt=10;
memRead=1;
end

hazardDetectionUnit  hazardUnitTEST(IFIDRegrs , IFIDRegrt , IDEXRegrt , memRead , controlMUX , IFIDRegHOLD ,  pcHOLD );

endmodule
