module cpu_top #(
    parameter int DATA_WIDTH = 32
)(
    input logic clk,
    input logic n_reset,
    input logic stall,
    ram_port_if.CPU ram_if
);

    logic [DATA_WIDTH-1:0] PC;

    fetch_stage #(
        .REG_WIDTH(DATA_WIDTH)
    ) fetch (
        .clk(clk),
        .n_reset(n_reset),
        .instr_mem(ram_if),
        .instr_out(), // Not used in this top module
        .stall(stall)
    );

    

    @always_ff (posedge clk or negedge n_reset) begin
        if (~n_reset) begin
            fetch.PC_in <= 32'h00000000;
        end else begin
            // Main CPU operations if needed
        end
    end

endmodule