`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.08.2024 21:22:03
// Design Name: 
// Module Name: CPU_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////






module CPU_tb;
  reg clk_sig;
  reg rst;
  reg [18:0] instr;
  wire [18:0] res_out;

  // Instantiate the CPU under test (UUT)
  CPU uut (
    .clk(clk_sig),
    
    .rst(rst),
    .instruction(instr),
    
    .result(res_out)
  );

  initial begin
    // Initial conditions
    clk_sig = 0;
    rst = 1;
    instr = 0;

    // Pulse reset signal
      #12 rst = 0;
     #15 rst = 1;
     #8 rst = 0;

    // ADD instruction test case
    instr = {5'b00000, 4'd0, 4'd1, 4'd2}; // ADD r0, r1, r2
     uut.gen_pur_register[1] = 19'd5;
    uut.gen_pur_register[2] = 19'd10;
    #11;

    // SUB instruction test case
    instr = {5'b00001, 4'd3, 4'd4, 4'd5}; // SUB r3, r4, r5
    uut.gen_pur_register[4] =19'd15;
    
    uut.gen_pur_register[5] =19'd7;
    #11;

    // MUL instruction test case
    instr = {5'b00010, 4'd6, 4'd7, 4'd8}; // MUL r6, r7, r8
     uut.gen_pur_register[7] = 19'd3;
    uut.gen_pur_register[8] = 19'd4;
    #11;

    // DIV instruction test case
    instr = {5'b00011, 4'd9, 4'd10, 4'd11}; // DIV r9, r10, r11
     uut.gen_pur_register[10] = 19'd20;
    uut.gen_pur_register[11] = 19'd4;
    #11;

    // INC instruction test case
    instr = {5'b00100, 4'd12, 4'd0, 4'd0}; // INC r12
     uut.gen_pur_register[12] = 19'd10;
    #11;

    // DEC instruction test case
    instr = {5'b00101, 4'd13, 4'd0, 4'd0}; // DEC r13
     uut.gen_pur_register[13] = 19'd10;
    #11;

    // AND instruction test case
   instr = {5'b00110, 4'd14, 4'd15, 4'd1}; // AND r14, r15, r1
    uut.gen_pur_register[15] = 19'b1010101010101010101;
     uut.gen_pur_register[1] = 19'b0101010101010101010;
    #11;

    // OR instruction test case
    instr = {5'b00111, 4'd14, 4'd15, 4'd1}; // OR r14, r15, r1
     uut.gen_pur_register[15] = 19'b1010101010101010101;
    uut.gen_pur_register[1] = 19'b0101010101010101010;
    #11;

    // XOR instruction test case
    instr = {5'b01000, 4'd14, 4'd15, 4'd1}; // XOR r14, r15, r1
     uut.gen_pur_register[15] = 19'b1010101010101010101;
    uut.gen_pur_register[1] = 19'b0101010101010101010;
    #11;

    // NOT instruction test case
    instr = {5'b01001, 4'd14, 4'd0, 4'd0}; // NOT r14, r0
    uut.gen_pur_register[0] = 19'b1010101010101010101;
    #11;

    // JMP instruction test case
    instr = {5'b01010, 4'd0, 4'd0, 14'd20}; // JMP 20
    #11;

    // BEQ instruction test case
    instr = {5'b01011, 4'd1, 4'd1, 14'd30}; // BEQ r1, r1, 30
    uut.gen_pur_register[1] = 19'd10;
    #11;

    // BNE instruction test case
    instr = {5'b01100, 4'd1, 4'd2, 14'd40}; // BNE r1, r2, 40
   uut.gen_pur_register[1] = 19'd10;
    uut.gen_pur_register[2] = 19'd20;
    #11;

    // CALL instruction test case
    instr = {5'b01101, 4'd0, 4'd0, 14'd50}; // CALL 50
    #11;

    // RET instruction test case
    instr = {5'b01110, 4'd0, 4'd0, 14'd0}; // RET
    #11;

    // LD instruction test case
    instr = {5'b01111, 4'd1, 4'd0, 14'd60}; // LD r1, 60
    uut.memory[60] = 19'd1234;
    #11;

    // ST instruction test case
    instr = {5'b10000, 4'd2, 4'd0, 14'd70}; // ST 70, r2
    uut.gen_pur_register[2] = 19'd5678;
    #11;

    // Custom instruction tests can be added here

    // End of simulation
    #100 $stop;
  end

  // Clock generation
  always #6 clk_sig = ~clk_sig;

endmodule
