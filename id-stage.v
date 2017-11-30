module DecodeandWBStages (input clk ,input [63:0]IFIDReg, input [70:0]MEMWBReg, input [74:0] EXMEReg, output reg [135:0]IDEXReg , output BranchControlSignal ,output [31:0] BranchTarget ,output pcHOLD );

	wire [31:0]PC = IFIDReg[31:0];
	wire [31:0]instruction = IFIDReg[63:32];
	wire [5:0] OPcode = instruction[31:26];
	wire [4:0] rs = instruction [25:21];
	wire [4:0] rt = instruction [20:16];
	wire [4:0] rd = instruction [15:11];
	wire [4:0] IDEXRegrt = IDEXReg[20:16];
	wire IDEXmemRead = IDEXReg [134];
	wire  RegDst, Jump, Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite;
	wire [1:0]ALUOp;

	wire [31:0] extendedSignal ;
	wire [31:0] BranchShiftedaddress;

	wire MEMWBRegWriteEnable = MEMWBReg[37];
	wire [4:0]MEMWBRegWriteReg = MEMWBReg [36:32];
	wire [31:0]MEMWBRegReadData = MEMWBReg [31:0];
	wire [31:0]MEMWBRegALUresult = MEMWBReg [69:38];
	wire MEMWBRegmemtoreg= MEMWBReg [70] ;
	wire [31:0] WriteData;
	wire [31:0] readData1;
	wire [31:0] readDate2;
	wire BranchEqual;

	wire [7:0] controlSignals = {RegDst, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite};
	wire [7:0] IDctrlSignalsNoHazard ;

Control DecodeStageControlUnit(OPcode, RegDst, Jump, Branch, MemRead, MemtoReg,ALUOp, MemWrite, ALUSrc, RegWrite);

//WBstage 
mux WriteDataMUX (MEMWBRegmemtoreg, MEMWBRegALUresult, MEMWBRegReadData , WriteData);

registerFile PipeliningRegisterFile( MEMWBRegWriteEnable , MEMWBRegWriteReg , WriteData , rs,readData1, rt ,readData2,  clk);

//branch
signextend1632 decodeStageSignExtend(instruction [15:0], extendedSignal);
ShiftLeftBranch ShiftedBranchAddress(extendedSignal ,BranchShiftedaddress);
adder BranchAdder (PC , BranchShiftedaddress , BranchTarget );
comparator BranchComarator (readData1 , readData2 , BranchEqual);
and Branch_selector ( BranchControlSignal , Branch , BranchEqual );


hazardDetectionUnit IDstageHazardDetect(rs ,rt , IDEXRegrt , IDEXmemRead , controlMUX , IFIDRegHOLD ,  pcHOLD );
mux ControlHazardSelection (controlMUX , controlSignals , 0 , IDctrlSignalsNoHazard);
 
	always @(posedge clk && IFIDRegHOLD ==0 )
	begin

		IDEXReg = {IDctrlSignalsNoHazard,extendedSignal,readData2,readData1,instruction};

	end
	
	wire [1:0] regFileRead1MuxSignal;
	wire [1:0] regFileRead2MuxSignal;
	diForwardingUnit diFU1(IFIDReg, EXMEReg, MEMWBReg, regFileRead1MuxSignal, regFileRead2MuxSignal);
	mux4to1 rsMux(regFileRead1MuxSignal, rs, rs, EXMEReg [68:64], MEMWBReg [36:32]);
	mux4to1 rdMux(regFileRead2MuxSignal, rd, rd, EXMEReg [68:64], MEMWBReg [36:32]);

endmodule



module DecodeStageTB;
reg clk=0 ;
reg [63:0]IFIDReg;
reg [70:0]MEMWBReg;
wire [135:0]IDEXReg ;
wire BranchControlSignal ;
wire[31:0] BranchTarget;
wire pcHOLD ;

always
#5 clk=!clk;

initial
begin
$monitor ($time , "IFIDReg=%h , MEMWBReg=%h, IDEXReg=%h , BranchControlSignal=%h , BranchTarget=%h , pcHOLD=%h " , IFIDReg, MEMWBReg, IDEXReg , BranchControlSignal , BranchTarget , pcHOLD );

//#10






end
DecodeandWBStages ( clk ,IFIDReg, MEMWBReg, IDEXReg , BranchControlSignal , BranchTarget , pcHOLD );

endmodule