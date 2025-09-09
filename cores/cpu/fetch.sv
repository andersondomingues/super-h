module fetch_stage #(
    parameter int REG_WIDTH = 32
)(
    input logic clk,
    input logic n_reset,
    ram_port_if.CPU instr_mem,
    input logic [REG_WIDTH-1:0] PC_in,
    output logic [REG_WIDTH-1:0] PC_out,
    output logic [31:0] instr_out,
    input logic stall
);
    typedef logic[REG_WIDTH-1:0] REG_T;

    // Fetch stage registers
    REG_T PC; // Program Counter

    // Output assignments
    assign PC_out = PC;
    
    // Fetch stage logic
    always_ff @(posedge clk or negedge n_reset) begin
        if (!n_reset) begin
            PC <= 32'h00000000; // Reset PC to 0
        end else if (!stall) begin
            PC <= PC_in; // Update PC from input
        end
    end

    // Instruction fetch logic
    always_ff @(posedge clk) begin
        if (!stall) begin
            instr_mem.en <= 1'b1;
            instr_mem.we <= 1'b0;
            instr_mem.addr <= PC[ADDR_WIDTH+1:2]; // Assuming word-aligned addresses
        end else begin
            instr_mem.en <= 1'b0;
        end
    end

    assign instr_out = instr_mem.rdata;