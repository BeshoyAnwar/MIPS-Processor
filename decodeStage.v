module DecodeandWBStages (input clk ,input [63:0]IFIDReg, input [70:0]MEMWBReg, input [74:0] EXMEReg, output reg [135:0]IDEXReg , output BranchControlSignal ,output [31:0] BranchTarget ,output pcHOLD, output   IFIDRegHOLD  );

	wire [31:0]PC = IFIDReg[31:0];
	wire [31:0]instruction = IFIDReg[63:32];
	wire [5:0] OPcode = instruction[31:26];
	wire [4:0] rs = instruction [25:21];
	wire [4:0] rt = instruction [20:16];
	wire [4:0] rd = instruction [15:11];
	wire [4:0] IDEXRegrt = IDEXReg[20:16];
	wire [5:0] IDEXRegOPcode=IDEXReg [31:26];
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

// FORWARDING
	wire [4:0] newRs;
	wire [4:0] newRt;
	wire [1:0] regFileRead1MuxSignal;
	wire [1:0] regFileRead2MuxSignal;
	wire EXMEWriteSignal = EXMEReg [74] ;
	wire [4:0] EXMEMRegWrReg = EXMEReg [68:64] ;
	diForwardingUnit (rs, rt , rt, EXMEWriteSignal, EXMEMRegWrReg, MEMWBRegWriteEnable , MEMWBRegWriteReg, regFileRead1MuxSignal, regFileRead2MuxSignal);
	mux3To1_5bits rsMux(regFileRead1MuxSignal, rs,EXMEMRegWrReg,MEMWBRegWriteReg, newRs);
	mux3To1_5bits rdMux(regFileRead2MuxSignal, rt, EXMEMRegWrReg,MEMWBRegWriteReg, newRt);

	Control DecodeStageControlUnit(OPcode, RegDst, Jump, Branch, MemRead, MemtoReg,ALUOp, MemWrite, ALUSrc, RegWrite);

//WBstage mux
	mux WriteDataMUX (MEMWBRegmemtoreg, MEMWBRegALUresult, MEMWBRegReadData , WriteData);

	registerFile PipeliningRegisterFile( MEMWBRegWriteEnable , MEMWBRegWriteReg , WriteData , rs,readData1, rt ,readData2,  clk);

//branch
	signextend1632 decodeStageSignExtend(instruction [15:0], extendedSignal);
	ShiftLeftBranch ShiftedBranchAddress(extendedSignal ,BranchShiftedaddress);
	adder BranchAdder (PC , BranchShiftedaddress , BranchTarget );
	comparator BranchComarator (readData1 , readData2 , BranchEqual);
	and Branch_selector ( BranchControlSignal , Branch , BranchEqual );

	wire IFflush ;
	hazardDetectionUnit IDstageHazardDetect(rs ,rt , IDEXRegrt , IDEXRegOPcode , controlMUX , IFIDRegHOLD ,  pcHOLD , IFflush );
	mux8bits ControlHazardSelection (controlMUX , controlSignals , 0 , IDctrlSignalsNoHazard);
 
	always @(posedge clk )
	begin

		if(IFflush==1) IDEXReg = 136'b 0 ;
		else IDEXReg = {IDctrlSignalsNoHazard,extendedSignal,readData2,readData1,instruction};

	end
	
endmodule



module DecodeandWBStagesTB;
reg clk=0 ;
wire [63:0]IFIDReg; //input
wire [70:0]MEMWBReg; //input
wire [74:0] EXMEReg; //input
wire [135:0]IDEXReg ; //output
wire BranchControlSignal ;
wire[31:0] BranchTarget;
wire pcHOLD ;
wire IFIDRegHOLD ;
//IFIDReg
reg [31:0] IFIDRegpc ;
reg [31:0] IFIDReginstruction ; 
//MEMWBReg
reg [31:0] MEMWBRegmemreaddata ;
reg [31:0] MEMWBRegAlUresult ;
reg [4:0] MEMWBRegwrReg ; //forward test
reg MEMWBRegwrenable ;
reg MEMWBRegmemtoreg ;
//EXMEReg
reg [31:0] EXMERegALUesult =0;
reg [31:0] EXMERegReadData2=0;
reg [4:0] EXMERegwrReg; //forward test
reg EXMERegZero =0;
reg EXMERegOverflow=0;
reg EXMERegMemRead;
reg EXMERegmemtoreg;
reg EXMERegmemwrite;
reg EXMERegregWrite;

assign IFIDReg= { IFIDRegpc,IFIDReginstruction};
assign MEMWBReg= { MEMWBRegmemreaddata , MEMWBRegwrReg , MEMWBRegwrenable , MEMWBRegAlUresult,MEMWBRegmemtoreg } ;
assign EXMEReg = { EXMERegALUesult,EXMERegReadData2,EXMERegwrReg , EXMERegZero , EXMERegOverflow , EXMERegMemRead , EXMERegmemtoreg , EXMERegmemwrite , EXMERegregWrite};

//IDEXReg (output from the prev cycle )
wire [31:0] IDEXRegInst = IDEXReg[31:0];
wire [4:0] IDEXRegrt = IDEXRegInst[20:16]; //for Hazard test
wire IDEXRegMemRead = IDEXReg[134]; //for Hazaed Test

always
#5 clk=!clk;

initial
begin
$monitor ($time , "IFIDReg=%h , MEMWBReg=%h, IDEXReg=%h , BranchControlSignal=%h , BranchTarget=%h , pcHOLD=%h " , IFIDReg, MEMWBReg, IDEXReg , BranchControlSignal , BranchTarget , pcHOLD );

//#10






end
DecodeandWBStages ( clk ,IFIDReg, MEMWBReg, EXMEReg , IDEXReg , BranchControlSignal , BranchTarget , pcHOLD ,  IFIDRegHOLD);

endmodule
