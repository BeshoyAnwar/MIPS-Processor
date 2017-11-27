module executionStage (input clk,input [135:0]IDEXReg,input [37:0]MEMWBReg, output reg [74:0]EXMEMReg);
	
	wire [31:0]instruction=IDEXReg[31:0];
	wire signed [31:0]readData1=IDEXReg[63:32];
 	wire signed [31:0]readData2=IDEXReg[95:64]; 
	wire signed [31:0]immediateExtendedField=IDEXReg[127:96];	
	wire [7:0]controlSignals=IDEXReg[135:128];
	
	wire [5:0]funct=instruction[5:0];
	wire [4:0]shiftAmt=instruction[10:6];
	wire [4:0]ID_EXRegisterRd=instruction[15:11];
	wire [4:0]ID_EXRegisterRt=instruction[20:16];
	wire [4:0]ID_EXRegisterRs=instruction[25:21];
	wire EX_MEMRegWrite=EXMEMReg[74];
	wire [4:0]EX_MEMRegisterRd=EXMEMReg[68:64];
	wire MEM_WBRegWrite=MEMWBReg[37];
	wire [4:0]MEM_WBRegisterRd=MEMWBReg[36:32];
	wire [31:0]MEM_WBResult=MEMWBReg[31:0];
	
	wire RegWrite=controlSignals[0];
	wire ALUSrc=controlSignals[1];
	wire MemRead=controlSignals[2];
	wire [1:0]ALUOp=controlSignals[4:3];
	wire MemToReg=controlSignals[5];
	wire MemWrite=controlSignals[6];
	wire RegDst=controlSignals[7];
	
	wire [3:0]ALUcontrolSignal;
	wire signed [31:0]ALUFirstOperand ;
	wire signed [31:0]ALUSecondOperand ;
	wire [4:0]writeRegister;
	wire signed [31:0]ALUResult;
	wire signed [31:0]ALUMuxFirstOperand;
	wire overflowFlag;
	wire ALUZeroflag;
	
	wire [1:0]forwardA;
	wire [1:0]forwardB;
	
	mux3To1 fowardingMuxA( forwardA, readData1, MEM_WBResult, EXMEMReg[31:0], ALUFirstOperand);
	mux3To1 fowardingMuxB( forwardB, readData2, MEM_WBResult, EXMEMReg[31:0], ALUMuxFirstOperand);
	mux ALUMux ( ALUSrc , ALUMuxFirstOperand , immediateExtendedField , ALUSecondOperand); 
	ALUcontrol alucontrol(funct, ALUOp ,ALUcontrolSignal);
	alu exeAlu ( ALUFirstOperand , ALUSecondOperand , ALUcontrolSignal, shiftAmt ,ALUResult, overflowFlag ,  ALUZeroflag );
	mux5bits WriteRegisterMux (RegDst , ID_EXRegisterRt , ID_EXRegisterRd , writeRegister);
	ExeForwardingUnit forwardunit( EX_MEMRegWrite, EX_MEMRegisterRd, ID_EXRegisterRs, ID_EXRegisterRt, MEM_WBRegWrite, MEM_WBRegisterRd, forwardA, forwardB);
	always @(posedge clk)begin
//#5
		EXMEMReg={RegWrite,MemWrite,MemToReg,MemRead,overflowFlag,ALUZeroflag,writeRegister,ALUResult,ALUResult};end
/* EXMEMReg[31:0]<=ALUResult;
EXMEMReg[63:32]<=readData2;
EXMEMReg[68:64]<=writeRegister;
EXMEMReg[69]<=ALUZeroflag;
EXMEMReg[70]<=overflowFlag;
EXMEMReg[71]<=MemRead;
EXMEMReg[72]<=MemToReg;
EXMEMReg[73]<=MemWrite;
EXMEMReg[74]<=RegWrite;
//{RegWrite,MemWrite,MemToReg,MemRead,overflowFlag,ALUZeroflag,writeRegister,ALUResult,ALUResult};*/
	/*initial
		$monitor("ALUResult=%d forwardA=%b forwardB=%b",ALUResult,forwardA,forwardB);*/


endmodule

module executionTest();
reg [135:0]IDEXReg;reg [37:0]MEMWBReg;
wire [74:0]EXMEMReg;reg clk=0;
always
#5clk=!clk;

initial
begin
$monitor($time,"result=%d data2=%d writeReg=%d zeroFlag=%d OVRFFlag=%d MemRead=%d MemToReg=%d MemWrite=%d RegWrite=%d rs=%d",EXMEMReg[31:0],EXMEMReg[63:32],EXMEMReg[68:64],EXMEMReg[69],EXMEMReg[70],EXMEMReg[71],EXMEMReg[72],EXMEMReg[73],EXMEMReg[74],IDEXReg[25:21]);
MEMWBReg[31:0]=165;
MEMWBReg[36:32]=18;
MEMWBReg[37]=1;
#10
IDEXReg[31:0]=32'h02538820;//instruction add $s1,$s2,$s3
IDEXReg[63:32]=5;//data1
IDEXReg[95:64]=5;//data2
IDEXReg[127:96]=10;//immediate extended
IDEXReg[135:128]=8'b10010001;//control for R-format

#10

IDEXReg[31:0]=32'h02329820;//instruction add $s3,$s1,$s2
IDEXReg[63:32]=5;//data1
IDEXReg[95:64]=7;//data2
IDEXReg[127:96]=10;//immediate extended
IDEXReg[135:128]=8'b10010001;//control for R-format
MEMWBReg[31:0]=165189;
MEMWBReg[36:32]=17;
MEMWBReg[37]=1;
#10
IDEXReg[31:0]=32'h02538820;//instruction add $s1 $s2 $s3
IDEXReg[63:32]=5;//data1
IDEXReg[95:64]=7;//data2
IDEXReg[127:96]=10;//immediate extended
IDEXReg[135:128]=8'b10010001;//control for R-format
/*MEMWBReg[31:0]=165189;
MEMWBReg[36:32]=17;
MEMWBReg[37]=1;*/



/*
#5
IDEXReg[31:0]=32'h02568820;//instruction add $s1 $s2 $s6
IDEXReg[63:32]=5;//data1
IDEXReg[95:64]=7;//data2
IDEXReg[127:96]=10;//immediate extended
IDEXReg[135:128]=8'b10010001;//control for R-format
MEMWBReg[31:0]=165189;
MEMWBReg[36:32]=17;
MEMWBReg[37]=1;*/
#10
// farwarding from mem to alu (rs)
IDEXReg[31:0]=32'h02CB6825;//instruction sub $s1,$s2,$s1
IDEXReg[63:32]=13;//data1
IDEXReg[95:64]=9;//data2
IDEXReg[127:96]=9;//immediate extended
IDEXReg[135:128]=8'b10010001;//control for R-format
MEMWBReg[31:0]=111;
MEMWBReg[36:32]=22;
MEMWBReg[37]=1;
/*#10
MEMWBReg[31:0]=111;
MEMWBReg[36:32]=22;
MEMWBReg[37]=1;

IDEXReg[31:0]=32'h02328820;//instruction sub $s1,$s2,$s3
IDEXReg[63:32]=13;//data1
IDEXReg[95:64]=9;//data2
IDEXReg[127:96]=9;//immediate extended
IDEXReg[135:128]=8'b10010001;//control for R-format*/

end





executionStage exe(clk,IDEXReg,MEMWBReg, EXMEMReg);
endmodule
