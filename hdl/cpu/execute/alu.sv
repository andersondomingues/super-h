module alu #(REG_WIDTH=32)(
    input  logic        clock,
    input  logic        rst_n,
    input  logic [REG_WIDTH-1:0] op_a,
    input  logic [REG_WIDTH-1:0] op_b,
    input  logic [REG_WIDTH-1:0] operation,
    output logic [REG_WIDTH-1:0] result,
    input  logic        carry_in,
    output logic        carry_out
);
 
adderN adder (
    .a(op_a),
    .b(op_b),
    .cin(carry_in),
    .sum(result),
    .cout(carry_out),
    .overflow(overflow)
);

shifter shifter (
    .sin(carry_in),
    .op_a(op_a),
    .result(result),
    .sout(carry_out),
    .nbits(op_b[4:0]),
    .lr(operation[0]),  // left or right
    .ar(operation[1])   // arith and rotatory flags
);

always @posedge(clock or negedge rst_n) begin

    case (operation)
        ADD : begin
            
        end 
        default: 
    endcase
end

    "alu" ADD       Rm,Rn        0011 nnnn mmmm 1100     Rn + Rm ~ Rn
    U "alu" ADDC      Rm,Rn        0011 nnnn mmmm 1110     Rn + Rm + T ~ Rn, Carry ~ T
    S "alu" ADDV      Rm,Rn        0011 nnnn mmmm 1111     Rn + Rm ~ Rn,     Overflow ~ T
    "alu" SUB       Rm,Rn        0011 nnnn mmmm 1000     Rn - Rm ~ Rn
    "alu" SUBC      Rm,Rn        0011 nnnn mmmm 1010     Rn - Rm - T ~ Rn, Borrow ~ T
    "alu" SUBV      Rm,Rn        0011 nnnn mmmm 1011     Rn - Rm ~ Rn,     Underflow ~ T

    "alu" ADD       #imm,Rn      0111 nnnn iiii iiii     Rn + imm ~ Rn
    "alu" AND       #imm,R0      1100 1001 iiii iiii     R0 & imm-t RO
    "alu" OR        #imm,R0      1100 1011 iiii iiii     RO I imm-t RO
    "alu" XOR       #irrun,R0    1100 1010 iiii iiii     RO I\ imm --+ RO 1

    "alu" AND.B     #imm,@(RO, GBR)  1100 1101 iiii iiii     (RO + GBR) & imm -t 3 (RO+ GBR)
    "alu" OR.B      imm,@ (RO, GBR)  1100 1111 iiii iiii     (RO + GBR) I imm -t 3 (RO+ GBR)
    "alu" XOR.B     #irrun,@(RO,GBR) 1100 1110 iiii iiii     (RO + GBR) I\ imm --+ 3(RO+ GBR)


end

endmodule