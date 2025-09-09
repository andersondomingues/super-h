module divisor #(
    parameter WIDTH = 32
)(
    input  logic                   clk,
    input  logic                   rst_n,
    input  logic                   start,
    input  logic [WIDTH-1:0]       dividend,
    input  logic [WIDTH-1:0]       divisor,
    output logic [WIDTH-1:0]       quotient,
    output logic [WIDTH-1:0]       remainder,
    output logic                   done
);

    typedef enum logic [1:0] {
        IDLE = 2'd0,
        BUSY = 2'd1,
        DONE = 2'd2
    } state_e;

    state_e current_state, next_state;
    logic [WIDTH-1:0] dividend_reg, divisor_reg, quotient_reg, remainder_reg;
    logic [5:0] count; // Enough to count up to WIDTH

    // State transition
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            current_state <= IDLE;
        else
            current_state <= next_state;
    end

    // Next state logic
    always_comb begin
        next_state = current_state;
        case (current_state)
            IDLE: if (start) next_state = BUSY;
            BUSY: if (count == WIDTH) next_state = DONE;
            DONE: next_state = IDLE;
        endcase
    end

    // Output and internal registers
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            dividend_reg <= '0;
            divisor_reg  <= '0;
            quotient_reg <= '0;
            remainder_reg<= '0;
            count        <= '0;
            done         <= 1'b0;
        end else begin
            case (current_state)
                IDLE: begin
                    done <= 1'b0;
                    if (start) begin
                        dividend_reg <= dividend;
                        divisor_reg  <= divisor;
                        quotient_reg <= '0;
                        remainder_reg<= '0;
                        count        <= '0;
                    end
                end
                BUSY: begin
                    if (dividend_reg[WIDTH-1]) begin
                        dividend_reg = {dividend_reg[WIDTH-2:0], 1'b0};
                        quotient_reg = {quotient_reg[WIDTH-2:0], 1'b0};
                    end else begin
                        dividend_reg = {dividend_reg[WIDTH-2:0], 1'b0};
                        dividend_reg = dividend_reg - divisor_reg;
                        if (dividend_reg[WIDTH-1]) begin
                            dividend_reg = dividend_reg + divisor_reg; // Restore
                            quotient_reg = {quotient_reg[WIDTH-2:0], 1'b0};
                        end else begin
                            quotient_reg = {quotient_reg[WIDTH-2:0], 1'b1};
                        end
                    end
                    count <= count + 1;
                end
                DONE: begin
                    done <= 1'b1;
                    remainder_reg <= dividend_reg;
                end
            endcase
        end
    end
    assign quotient  = quotient_reg;
    assign remainder = remainder_reg;
endmodule