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
    // PC has 30 bits to avoid unaligned accesses
    logic[REG_WIDTH-1:2] PC; 

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

    assign instr_mem.en = 1'b1;  // Keep memory port enabled
    assign instr_mem.we = 1'b0;  // Always in read mode

    // Instruction fetch logic
    always_ff @(posedge clk) begin
        if (!stall) begin
            instr_mem.addr <= PC[ADDR_WIDTH+1:2]; // Assuming word-aligned addresses
            instr_out = instr_mem.rdata;
        end
    end
    assign 