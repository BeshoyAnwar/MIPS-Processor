module ExeForwardingUnit(input Ex_MemRegWrite,input [4:0]Ex_MemRegisterRd,input [4:0]ID_ExRegisterRs,input [4:0]ID_ExRegisterRt,input Mem_WbRegWrite,input MEM_WBMemToReg,input [4:0]Mem_WbRegisterRd,output reg [1:0]forwardA,output reg [1:0]forwardB);
	parameter fowardfromEx_Mem=2'b10,
		  fowardMemResultfromMem_Wb=2'b01,
		  fowardALUResultfromMem_Wb=2'b11;
		
initial
begin
	forwardA=0;forwardB=0;
end
always@(*)
begin
if(Ex_MemRegWrite==1 && Ex_MemRegisterRd!=0 && Ex_MemRegisterRd==ID_ExRegisterRs )
	forwardA=fowardfromEx_Mem;
else if(Mem_WbRegWrite==1 && Mem_WbRegisterRd!=0 && Mem_WbRegisterRd==ID_ExRegisterRs )
begin
	if(MEM_WBMemToReg==1)
	forwardA=fowardMemResultfromMem_Wb;
	else if(MEM_WBMemToReg==0)
	forwardA=fowardALUResultfromMem_Wb;
end
else 
	forwardA=0;
if(Ex_MemRegWrite==1 && Ex_MemRegisterRd!=0 && Ex_MemRegisterRd==ID_ExRegisterRt )
	
else if(Mem_WbRegWrite==1 && Mem_WbRegisterRd!=0 && Mem_WbRegisterRd==ID_ExRegisterRt )
begin
	if(MEM_WBMemToReg==1)
	forwardB=fowardMemResultfromMem_Wb;
	else if(MEM_WBMemToReg==0)
	forwardB=fowardALUResultfromMem_Wb;
end
else 
	forwardB=0;

end



endmodule
