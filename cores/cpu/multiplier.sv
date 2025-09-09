module multiplier #(
    parameter WIDTH = 32
)(
    input  logic                   clk,
    input  logic                   rst_n,
    input  logic                   start,
    input  logic [WIDTH-1:0]       a,
    input  logic [WIDTH-1:0]       b,
    output logic [2*WIDTH-1:0]     result,
    output logic                   done
);

    typedef enum logic [1:0] {
        IDLE = 2'd0,
        BUSY = 2'd1,
        DONE = 2'd2
    } state_e;

    state_e current_state, next_state;
    logic [2*WIDTH-1:0] multiplicand, multiplier, product;
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
            multiplicand <= '0;
            multiplier   <= '0;
            product      <= '0;
            count        <= '0;
            done         <= 1'b0;
        end else begin
            case (current_state)
                IDLE: begin
                    done <= 1'b0;
                    if (start) begin
                        multiplicand <= a;
                        multiplier   <= b;
                        product      <= '0;
                        count        <= '0;
                    end
                end
                BUSY: begin
                    if (multiplier[0]) 
                        product <= product + multiplicand;
                    multiplicand <= multiplicand << 1;
                    multiplier   <= multiplier >> 1;
                    count        <= count + 1;
                end
                DONE: begin
                    done <= 1'b1;
                end
            endcase
        end
    end

    assign result = product;
endmodule