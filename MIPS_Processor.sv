// pipelined MIPS processor
module mips(input logic clk, reset,
	    output logic [31:0] pcF,
	    input logic [31:0] instrF, // Input for decoder phase
	    output logic memwriteM, sbM, // Wether to write byte, word in memory
	    output logic [31:0] aluoutM, writedataM,
	    input logic [31:0] readdataM); // Output of Data memory
		// Solve hazarad -> Mux choose out (ALUOutM,MemWriteW,RD2)

logic [5:0] opD, functD;
logic [1:0] regdstE;
logic alusrcE, pcsrcD, memtoregE, memtoregM, memtoregW, regwriteE, regwriteM, regwriteW;
logic [3:0] alucontrolE;
logic flushE, equalD, jrD, jalD;
logic [1:0] mfhlW;

controller c(clk, reset, opD, functD, flushE,
equalD,memtoregE, memtoregM,
memtoregW, memwriteM, pcsrcD,
branchD, bneD, alusrcE, regdstE, regwriteE,
regwriteM, regwriteW, jumpD, jalD, jalW, jrD, lbW, sbM,
multordivE, hlwriteE, hlwriteM, hlwriteW, mfhlW,
alucontrolE);

datapath dp(clk, reset, memtoregE, memtoregM, memtoregW, pcsrcD, branchD, bneD,
alusrcE, regdstE, regwriteE, regwriteM, regwriteW, jumpD, jalD, jalW, jrD, lbW,
multordivE, hlwriteE, hlwriteM, hlwriteW, mfhlW, alucontrolE, equalD, pcF, instrF,
aluoutM, writedataM, readdataM, opD, functD, flushE);
endmodule
