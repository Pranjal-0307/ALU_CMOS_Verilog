module ALU_testbench;
    reg [3:0] addr1, addr2, rd;
    reg [2:0] func;
    reg [7:0] memaddr;
    reg clk1, clk2, write;
    wire [7:0] Zout;
    wire carry_borrow;
    integer i;// used for loop 

    //Instantiate the ALU module
    bit8ALU alu_inst (.addr1(addr1), .addr2(addr2), .rd(rd), .func(func), .memaddr(memaddr), .clk1(clk1), .clk2(clk2), .write(write), .Zout(Zout), .carry_borrow(carry_borrow));
    initial begin
        repeat (20)begin
           clk1 = 0; clk2 = 0;
        #5 clk1 = 1; #5 clk1 = 0;
        #5 clk2 = 1; #5 clk2 = 0;// Two phase clock generation
    end
    end
    
    initial begin // Dumping The Waveforms
        $dumpfile("ALU.vcd");
        $dumpvars(0, ALU_testbench);
        $display("---------------------------------------------------");
        $display("-------------Simulation of ALU---------------------");
        $display("---------------------------------------------------");
        $monitor("Time: %3d, Zout = %3d, Carry/Borrow = ", $time, Zout, carry_borrow);
        #350 $finish; // To end simulation After 300 time units 
    end
    initial begin
      // Initializing The Register Bank
    for (i=0; i<16; i=i+1) begin
        alu_inst.regbank[i] = i; // Initializing register bank with values 0 to 15
    end
    end
    initial begin//test cases 
         #5 addr1 = 3; addr2 = 5; rd = 10; func = 0; memaddr = 225; write = 1; //Add
        #20 addr1 = 5; addr2 = 10; rd = 14; func = 1; memaddr = 226; write = 1; //Sub
        #20 addr1 = 3; addr2 = 8; rd = 12; func = 2; memaddr = 227; write = 1; //And
        #20 addr1 = 7; addr2 = 3; rd = 13; func = 3; memaddr = 228; write = 1; //OR
        #20 addr1 = 10; addr2 = 5; rd = 15; func = 4; memaddr = 229; write = 1; //XOR  //here we updated the reg[10] to 8 from 1st test case 
        #20 addr1 = 12; addr2 = 13; rd = 9; func = 5; memaddr = 230; write = 1; //NOT A
        #20 addr1 = 12; addr2 = 13; rd = 7; func = 6; memaddr = 231; write = 1; //NOT B    
        #20 addr1 = 11; addr2 = 15; rd = 8; func = 7; memaddr = 232; write = 1; //INC A

        #60 $display("---- Memory Contents ----");
        for (i=225; i<233; i=i+1) begin
            $display("Mem[%3d] = %3d", i, alu_inst.mem[i]); // Displaying memory contents
        end
    end
    initial begin
  #300;
  $display("---- Register Bank ----");
  for (i = 0; i < 16; i = i + 1) begin
    $display("regbank[%0d] = %0d", i, alu_inst.regbank[i]);
  end
end
endmodule
