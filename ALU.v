// ----------------------------------------------------------------------------------
// FILE NAME :-- 8 Bit ALU 
// TYPE :-- MODULE 
// ----------------------------------------------------------------------------------
// KEYWORDS :-- 8 Bit ALU, Pipelined ALU, CMOS Implementation, Memory, Register Bank
// ----------------------------------------------------------------------------------
// DESCRIPTION :-- This module implements an 8-bit pipelined ALU with a register bank and memory.
// ---------------------------------------------------------------------------------

module bit8ALU (Zout,carry_borrow, addr1, addr2, write, rd, func, memaddr, clk1, clk2);
      input [3:0] addr1, addr2, rd;//address inputs for the register bank
      input [2:0] func;  // function code for ALU operations
      input [7:0] memaddr;// memory address for storing results
      input clk1, clk2; // two phase clock to avoid clocking issues
      input write; // write signal for memory
      output [7:0] Zout; // output of the ALU
      output carry_borrow; // carry out or borrow out signal

      reg [7:0] regbank [15:0]; // 16x8 register bank
      reg [7:0] mem [0:255]; // 256 x 8 memory
      // Parameters 
      parameter ADD = 3'b000, SUB = 3'b001, AND = 3'b010, OR = 3'b011, XOR = 3'b100, NOT_A = 3'b101, NOT_B = 3'b110, INC_A = 3'b111;

      // internal registers for pipelining
     reg [7:0] L12_A, L12_B, L23_Z, L34_Z;
     reg [3:0] L12_rd, L23_rd;
     reg [2:0] L12_func;
     reg [7:0] L12_memaddr, L23_memaddr, L34_memaddr;
     reg L12_write, L23_write, L34_write, L23_carry_borrow, L34_carry_borrow;

     assign Zout = L34_Z;  // OUTPUT of the ALU
     assign carry_borrow = L34_carry_borrow; // Carry or borrow output
     // Wires for cmos implementation of ALU operations 
     wire [7:0] add_out, sub_out, and_out, or_out, xor_out, not_A_out, not_B_out, inc_A_out;
     // Wire for carry out of addition or borrow out of subtraction
     wire carry_out_add, carry_out_inc, borrow_temp;
     // instiate the modules used in ALU operations
        FA8bit ADD_inst(add_out, carry_out_add, L12_A, L12_B, 1'b0); // 8-bit adder
        sub8bit SUB_inst(sub_out, borrow_temp, L12_A, L12_B); // 8-bit subtractor
        FA8bit INC (inc_A_out, carry_out_inc, L12_A, 8'b00000001, 1'b0); // Increment A
        and_gate8bit and_gate_inst(and_out, L12_A, L12_B); // AND operation
        or_gate8bit or_gate_inst(or_out, L12_A, L12_B); // OR operation
        xor_gate8bit xor_gate_inst(xor_out, L12_A, L12_B); // XOR operation
        not_gate8bit not_A_inst(not_A_out, L12_A); // NOT A
        not_gate8bit not_B_inst(not_B_out, L12_B); // NOT B
     
     //stage 1 : Read A and B from Register Bank 
     always @(posedge clk1) begin  // <--- clk1 is used here 
        L12_A <= #2 regbank[addr1];
        L12_B <= #2 regbank[addr2];
        L12_rd <= #2 rd;
        L12_func <= #2 func;
        L12_memaddr <= #2 memaddr; 
        L12_write <= #2 write ; // stage 1
     end

     // Stage 2 : Performing ALU operation
     always @(posedge clk2) begin  // <--- clk2 is used here
            case (L12_func)
            ADD: begin
                L23_Z <= #2 add_out; // ADD
                L23_carry_borrow <= #2 carry_out_add; // Capture carry out
            end
            SUB: begin 
                L23_Z <= #2 sub_out; // SUBTRACT
                L23_carry_borrow <= #2 borrow_temp; // Capture borrow out
            end   
            AND:begin
                L23_Z <= #2 and_out; // AND
                L23_carry_borrow <= #2 1'b0; // No carry or borrow for AND
            end 
            OR: begin
                L23_Z <= #2 or_out; // OR
                L23_carry_borrow <= #2 1'b0; // No carry or borrow for OR
            end
            XOR: begin
                 L23_Z <= #2 xor_out; // XOR
                 L23_carry_borrow <= #2 1'b0; // No carry or borrow for XOR
            end
            NOT_A: begin
                 L23_Z <= #2 not_A_out; // NOT A
                    L23_carry_borrow <= #2 1'b0; // No carry or borrow for NOT A    
            end    
            NOT_B:  begin
                L23_Z <= #2 not_B_out; // NOT B
                L23_carry_borrow <= #2 1'b0; // No carry or borrow for NOT B
            end
            INC_A: begin
                 L23_Z <= #2 inc_A_out; // INC A
                L23_carry_borrow <= #2 carry_out_inc; // Capture carry out for INC A
            end
            default:  begin L23_Z <= #2 8'hxx; // Default case for undefined operations
                L23_carry_borrow <= #2 1'bx; // No carry or borrow for undefined operations
            end
            endcase
            L23_rd <= #2 L12_rd;
            L23_memaddr <= #2 L12_memaddr;
            L23_write <= #2 L12_write; // stage 2
     end

     // Stage 3 : Putting the result back in Register Bank 
     always @(posedge clk1) begin //<-- clk1 is used here 
        regbank[L23_rd] <= #2 L23_Z;
        L34_write <= #2 L23_write;
        L34_carry_borrow <= #2 L23_carry_borrow; // Carry or borrow from stage 2
        L34_Z <= #2 L23_Z;
        L34_memaddr <= #2 L23_memaddr; // stage 3
     end

     // Stage 4 : Writing result to Memory
     always @(posedge clk2) begin  //<-- clk2 is used here
        if (L34_write) begin
            mem[L34_memaddr] <= #2 L34_Z; // stage 4
        end
     end
endmodule
// ----------------------------------------------------------------------------------
//Other Modules used in ALU:--
// ----------------------------------------------------------------------------------
// 8 bit FullAdder 
// 1 bit Full Adder using CMOS
module fulladder_1 (sum, cout, a, b, cin);
    input a, b, cin;
    output sum, cout;
    fa_sum SUM (sum, a, b, cin);
    fa_carry CARRY (cout, a, b, cin);
endmodule
module fa_carry (cout, a, b, cin);//carry out logic
     input a, b, cin;
     output cout;

     wire t1, t2, t3;
    and_gate A1 (t1, a, b);
    xor_gate X1 (t2, a, b);
    and_gate A2 (t3, t2, cin);
    or_gate O1 (cout, t1, t3);  
endmodule
module fa_sum (sum, a, b, cin);// sum logic
   input a, b, cin;
   output sum;
   wire t1, t2;

   xor_gate X1 (t1, a, b);
   xor_gate X2 (sum, t1, cin);
endmodule
//8 bit Full Adder
module FA8bit(f, Cout, a, b, Cin);
    input [7:0] a, b;
    input Cin;
    output Cout;
    output [7:0] f;

    wire [6:0] C;  // Internal carries (C[6:0]) for bits 1 to 7
    fulladder_1 FA0(f[0], C[0], a[0], b[0], Cin); // First bit with Cin as 0
    genvar i;
    generate
        for (i = 1; i < 7; i = i + 1) begin
            fulladder_1 FA(f[i], C[i], a[i], b[i], C[i-1]);
        end
    endgenerate
    fulladder_1 FA7(f[7], Cout, a[7], b[7], C[6]);
endmodule
// 1bit subtractor using Full Adder
module substractor_1(diff, bout, a, b, bin);
    input a, b, bin;
    output diff, bout;

    wire b_not;
    cmosinv N1(b_not, b); // Invert b to use in subtraction
    fulladder_1 FA(diff, bout, a, b_not, bin); // Use full adder for subtraction
    
endmodule

// 8 bit Subtractor
module sub8bit(diff, bout, a, b);
    input [7:0] a, b;
    output [7:0] diff;
    output bout;

    wire [6:0] B;  // Borrow wires
    substractor_1 S0(diff[0], B[0], a[0], b[0], 1'b1); // Initial bin = 1 (for 2's comp)
    genvar i;
    generate
        for (i = 1; i < 7; i = i + 1) begin
            substractor_1 S(diff[i], B[i], a[i], b[i], B[i-1]); 
        end
    endgenerate
    substractor_1 S7(diff[7], bout, a[7], b[7], B[6]); 
endmodule
// Other Fundamental Gates used in the ALU:--
// 8-bit gates for ALU operations:--
//OR Gate for 8-bit inputs
module or_gate8bit(f, x, y);
    input [7:0] x, y;
    output[7:0] f;
    genvar i;

    generate
        for (i = 0; i < 8; i = i + 1) begin // generating 8 OR gates
            or_gate O1(f[i], x[i], y[i]);
        end
    endgenerate
endmodule 
//AND Gate for 8-bit inputs   
module and_gate8bit(f, x, y);
    input [7:0] x, y;
    output[7:0] f;
    genvar i;

    generate
        for (i = 0; i < 8; i = i + 1) begin  // generating 8 AND gates 
            and_gate A1(f[i], x[i], y[i]);
        end
    endgenerate
endmodule    
//NOT Gate for 8-bit inputs
module not_gate8bit(f, x);
    input [7:0] x;
    output[7:0] f;
    genvar i;

    generate
        for (i = 0; i < 8; i = i + 1) begin // generating 8 NOT gates
        cmosinv C1(f[i], x[i]);
        end
    endgenerate
endmodule    
//XOR Gate for 8-bit inputs
module xor_gate8bit(f, x, y);
    input [7:0] x, y;
    output[7:0] f;
    genvar i;

    generate
        for (i = 0; i < 8; i = i + 1) begin 
            xor_gate A1(f[i], x[i], y[i]);
        end
    endgenerate
endmodule    
// For 1-bit
// AND Gate
module and_gate(f, x, y);
    input x, y;
    output f;
    supply1 vdd;
    supply0 gnd;

    wire a;
    cmosnand N6 (a, x, y); //NAND Gate 
    cmosinv N7 (f, a); // Invert the output of NOR to get AND    
endmodule
// OR Gate 
module or_gate(f, x, y);
    input x, y;
    output f;
    supply1 vdd;
    supply0 gnd;

    wire a;
    cmosnor N8 (a, x, y); // NOR Gate
    cmosinv N9 (f, a); // Invert the output of NOR to get OR
endmodule
// XOR Gate
module xor_gate (f, A, B);
    input A, B;
    output f;
    supply1 vdd;
    supply0 gnd;

    wire not_A, not_B, c, d;
    cmosinv N1 (not_A, A); // Invert A
    cmosinv N2 (not_B, B); // Invert B
    and_gate N3 (c, B, not_A); // B AND NOT A
    and_gate N4 (d, A, not_B); // A AND NOT B
    or_gate N5  (f, c, d); // OR the results
endmodule
// CMOS Gate Implementation :---
// NAND Gate
module cmosnand (f, x, y);
    input x, y;
    output f;
    supply1 vdd;
    supply0 gnd;
    wire a;
    // Pull up Network
    pmos p1 (f, vdd, x);
    pmos p2 (f, vdd, y);
    // Pull down Network
    nmos n1 (f, a, x);
    nmos n2 (a, gnd, y);
endmodule

// NOR Gate 
module cmosnor (f,x, y);
     input x, y;
     output f;
     supply0 gnd;
     supply1 vdd;
     wire a;
      // Pull up Network 
     pmos p3 (a, vdd, x);
     pmos p4 (f, a, y); 
     // Pull down Network
     nmos n3 (f, gnd, x);
     nmos n4 (f, gnd, y);
endmodule

// NOT Gate
module cmosinv (f, x);
    input x;
    output f;
    supply1 vdd;
    supply0 gnd;

    pmos p5 (f, vdd, x); // Pull up Network
    nmos n5 (f, gnd, x); // Pull down Network
endmodule