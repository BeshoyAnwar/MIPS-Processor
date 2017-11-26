module PC (output reg [31:0] nextPC , input [31:0] prevPC ,input Reset, input clk);

initial
//begin
nextPC=32'b0;
//prevPC=32'b0;
//end

always @(posedge clk or posedge Reset)
nextPC <= ((Reset == 1) ? 32'b0 : prevPC[31:0]) ;


endmodule

module PC_test;

reg [31:0]prevPC;
reg reset,clk;
wire [31:0]nextpc ;

always begin #5 clk = ~clk; end

initial 
begin
 $monitor ($time , ,"clk=%d , Reset=%d , PrevPC=%d , NextPC=%d",clk ,reset ,prevPC,nextpc);

clk =0;

#5 prevPC=7; reset=0;
#10 prevPC=56; reset=0;
#10 prevPC=9; reset=1;
#10 prevPC=657; reset=0;
end

PC PC_TEST( nextpc , prevPC , reset, clk);
endmodule
