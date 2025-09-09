module adderN #(REG_WIDTH=32)(
    input logic[REG_WIDTH-1:0] a,
    input logic[REG_WIDTH-1:0] b,
    input logic cin,
    output logic[REG_WIDTH-1:0] res,
    output logic cout
);

wire logic[REG_WIDTH-2:0] c;
genvar i;
generate
    for (i = 0; i < REG_WIDTH; i = i + 1) begin : gen_adder
        // cin for adder[0] comes from outside the module
        if (i == 0) begin
            adder1 adder (
                .a(a[i]),
                .b(b[i]),
                .cin(cin),
                .res(res[i]),
                .cout(c[i])
            );
        // cout from adder[REG_WIDTH-1] goes outside the module
        end else if (i == REG_WIDTH - 1) begin
            adder1 adder (
                .a(a[i]),
                .b(b[i]),
                .cin(c[i-1]),
                .res(res[i]),
                .cout(cout)
            );
        // cin for other adders comes from the previous adder
        end else begin
            adder1 adder (
                .a(a[i]),
                .b(b[i]),
                .cin(c[i-1]),
                .res(res[i]),
                .cout(c[i])
            );
        end
    end
endgenerate

endmodule