`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.08.2024 12:49:59
// Design Name: 
// Module Name: CPU
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


module CPU (
 input clk,   // input clock signal - which toggles the clock every 5 times unit
  input rst,
  input [18:0] instruction,   // we are using seperate instruction and data memory following Harvard architecture
 output reg[18:0] result
);

   reg [18:0] gen_pur_register [0:15];   // here 16 registers are assigned each of which are 19 bit wide
  reg [18:0] memory [0:524287];      // 2^19 = 524288 memory addresses for storing instruction
   reg [18:0] pc;                // program counter  register - hold the address of current instruction          
   reg [18:0] stack [0:15];
  reg [3:0] sp;                 // stack pointer  register - to point top of stack


   wire [4:0] opcode;             // it has 5 bit opcode - which extract operation code from instruction
    wire [3:0] r1, r2, r3;         // each registers has 4 bits so in total 12 bit operand  and remaining 2 bits are for addresses
    wire [18:0] immediate;        // extract immidiate value
    
    
   assign opcode = instruction[18:14];  // from instruction extract operation code
   assign r1 = instruction[13:10];
     assign r2 = instruction[9:6];
    assign r3 = instruction[5:2];
     assign immediate = instruction[13:0];
    
    
  integer i;
  always @(posedge clk or posedge rst) begin
    if (rst) begin
      pc <= 0;
      sp <= 0;
      result <= 0;
      // Reset registers and memory for debugging purposes
      
      for (i = 0; i < 16; i = i + 1) begin
        gen_pur_register[i] <= 0;
      end
    end else begin
            case (opcode)
            //Arithmatic operations
              5'b00000: gen_pur_register[r1] <= gen_pur_register[r2] + gen_pur_register[r3]; // ADD r1 = r2 + r3 in 0
               5'b00001: gen_pur_register[r1] <= gen_pur_register[r2] - gen_pur_register[r3]; // SUB r1 = r2 - r3 in 1
               5'b00010: gen_pur_register[r1] <= gen_pur_register[r2] * gen_pur_register[r3]; // MUL r1 = r2 * r3 in 2
                5'b00011: gen_pur_register[r1] <= gen_pur_register[r2] / gen_pur_register[r3]; // DIV r1 = r2 / r3 in 3
            //Increment/ Decrement 
                5'b00100: gen_pur_register[r1] <= gen_pur_register[r1] + 1; // INC r1 = r1 + 1 in 4
               5'b00101: gen_pur_register[r1] <= gen_pur_register[r1] - 1; // DEC r1 = r1 - 1 in 5
            //Logical operations
                 5'b00110: gen_pur_register[r1] <= gen_pur_register[r2] & gen_pur_register[r3]; // AND r1 = r2 & r3 in 6
               5'b00111: gen_pur_register[r1] <= gen_pur_register[r2] | gen_pur_register[r3]; // OR r1 = r2 | r3 in 7
                  5'b01000: gen_pur_register[r1] <= gen_pur_register[r2] ^ gen_pur_register[r3]; // XOR r1 = r2 ^ r3 in 8
                 5'b01001: gen_pur_register[r1] <= ~gen_pur_register[r2]; // NOT r1 =~ r2 in 9
             //Control flow
                 5'b01010: pc <= immediate; // JMP program counter = immediate address/data in 10
                5'b01011: if (gen_pur_register[r1] == gen_pur_register[r2]) pc <= immediate; // BEQ if(r1 == r2) program counter = immediate address/data in 11
                5'b01100: if (gen_pur_register[r1] != gen_pur_register[r2]) pc <= immediate; // BNE if(r1 != r2) program counter = immediate address/data in 12
                
                5'b01101: begin // CALL in 13
                    stack[sp] <= pc + 1;    //save the return address - incrementing the PC(pointing to CALL instruction) by 1(to point to next instruction after CALL) and saved onto the stack at position indicated by SP
                    sp <= sp - 1;       // update the SP - SP is decremented to point to the new top of the stack where the return address was saved
                    pc <= immediate;       // jump to Subroutine - PC is updated to the address specified by the immidiate field of the CALL instruction causingCPU to jump to the subroutine and start executing instruction there
                  end
                5'b01110: begin // RET  (return from subroutine) in 14
                    sp <= sp + 1;      // update SP - SP is incremented to remove the return address from stack and point to previous position
                    pc <= stack[sp];   // Retrieve the return address - PC is updated with the return address stored on the stack at position indicated by SP
                 end
               //Memory access
               5'b01111: gen_pur_register[r1] <= memory[immediate]; // LD in 15 - immidiate field in the instruction contains the address from which data is to be loaded
                                                                   // CPU access the memory  from that address using (memory[immidiate]) 
                                                                   // value from the specified memory address is loaded into register r1
               
               5'b10000: memory[immediate] <= gen_pur_register[r1]; // ST in 16 - immidiate field in the instruction contains the address where data is to be stored
                                                                    //CPU access the value from the register r1
                                                                    // the value from register r1 is stored into specific memore address (memory[immediate])
               //Specialised operation
               5'b10001: fft(gen_pur_register[r1],gen_pur_register[r2]); // FFT
                 5'b10010: encrypt(gen_pur_register[r1] ,gen_pur_register[r2]); // ENC
                5'b10011: decrypt(gen_pur_register[r1],gen_pur_register[r2]); // DEC
                default: ;
            endcase
            pc <= pc + 1;
        end
    end

    //  for FFT function operation
    task fft;
        input [18:0] test;
        input [18:0] src;
        
        integer i;
        begin
            for (i = 0; i < 8; i = i + 1) begin
                  memory[ test + i] <= memory[src + i] + 1;
             end
        end
    endtask
    
    //  encryption task by (XOR with a key)
    task encrypt;
        input [18:0] test;
         input [18:0] src;
        reg [18:0] key;
         
         integer i;
        begin
            key = 19'b1010101010101010101; //  key
            for (i = 0; i < 8; i = i + 1) begin
                  memory[ test + i] <= memory[src + i] ^ key;
             end
        end
    endtask
    
    //  decryption task by (XOR with a key)
    task decrypt;
        input [18:0] test;
        input [18:0] src;
        reg [18:0] key;
        integer i;
        begin
            key = 19'b1010101010101010101; //  key
            for (i = 0; i < 8; i = i + 1) begin
                  memory[ test + i] <= memory[src + i] ^ key;
               end
        end
    endtask
    
    
    
  // Output result from register 0
  always @(posedge clk or posedge rst) begin
    if (rst) begin
      result <= 0;
     end
     else begin
      result <= gen_pur_register[0];  //  the values get stored into result register
       end
  end

endmodule





