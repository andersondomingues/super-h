module cpu #(
    parameter int REG_WIDTH = 32
)(
    input logic clk,
    input logic n_reset,
    dual_port_ram_port_if.CPU instr_mem,
    dual_port_ram_port_if.CPU data_mem,
    regbank_if.CPU regbank,
    input logic stall
);
    typedef logic[REG_WIDTH-1:0] REG_T;

    // control registers
    REG_T SR;  // Status Register
    REG_T GBR; // Global Base Register
    REG_T VBR; // Vector Base Register

    // status register fields
    logic T;  // T flag
    logic S;  // S flag
    logic[3:0] I;  // Interrupt mask
    logic Q;  // Q flag
    logic M;  // M flag

    // status register assignments; others fixed in zero
    assign SR = {12'b0, M, Q, I, 2'b00, S, T};
    
    // system registers
    REG_T PC; // Program Counter
    REG_T PR; // Procedure register (link register)
    REG_T MACH; // Multiply-Accumulate High
    REG_T MACL; // Multiply-Accumulate Low 

    // pipeline stages
    typedef enum logic[4:0] {
        IFETCH  = 5'b00001,
        DECODE  = 5'b00010,
        EXECUTE = 5'b00100,
        MEMORY  = 5'b01000,
        WRITEBACK = 5'b10000
    } state_t;

    // fetch stage
    typedef struct packed {
        logic [31:0] instr;
        logic [31:0] pc;
    } fetch_to_decode1_s;

    typedef struct packed {
        logic [31:0] instr;
        logic [31:0] pc;
    } decode1_to_decode2_s;

    //decode
    always_ff @(posedge clk or negedge n_reset) begin
        if (!n_reset) begin
            PC <= 32'h00000000; // Reset PC to 0
        end else if (!stall) begin
            PC <= PC + 4; // Increment PC by 4 (assuming 32-bit instructions)
        end
    end


    // Control signals default
    always_ff @(posedge clk or negedge reset) begin
        if (~reset) begin
            PC  <= 32'h00000000;
            I   <= 4'h1111;
            VBR <= 32'h00000000;
            
        end else begin
            mem_rd <= 1'b0;
            mem_wr <= 1'b0;
            halt   <= 1'b0;

            // Example: MOV.L Rm,@(disp,Rn)
            if (opcode[15:12] == 4'b0100 && opcode[3:0] == 4'b0011) begin
                addr   <= R[dst_reg] + (imm4 << 2);
                dout   <= R[src_reg];
                mem_wr <= 1'b1;
                PC     <= PC + 2;
            end
            // Example: MOV.L @(disp,Rm),Rn
            else if (opcode[15:12] == 4'b0100 && opcode[3:0] == 4'b0010) begin
                addr   <= R[src_reg] + (imm4 << 2);
                mem_rd <= 1'b1;
                R[dst_reg] <= din;
                PC     <= PC + 2;
            end
            // Example: ADD Rm,Rn
            else if (opcode[15:12] == 4'b0011 && opcode[3:0] == 4'b1100) begin
                R[dst_reg] <= R[dst_reg] + R[src_reg];
                PC     <= PC + 2;
            end
            // Example: MOV #imm,Rn
            else if (opcode[15:8] == 8'b11100000) begin
                R[dst_reg] <= {24'b0, imm8};
                PC     <= PC + 2;
            end
            // Example: NOP
            else if (opcode == 16'h0009) begin
                PC     <= PC + 2;
            end
            // Example: RTS
            else if (opcode == 16'h000B) begin
                PC     <= R[15];
            end
            // Example: HALT
            else if (opcode == 16'h000A) begin
                halt   <= 1'b1;
            end
            // ... Add more instructions as needed ...
            else begin
                // Unrecognized instruction: NOP
                PC <= PC + 2;
            end
        end
    end
endmodule
