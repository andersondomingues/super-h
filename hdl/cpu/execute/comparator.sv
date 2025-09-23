module comparator (
    input logic [15:0] a,
    input logic [15:0] b,
    input logic [4:0] cmp_1hot,
    output logic        eq,   // a == b
    output logic        lt,   // a < b (signed)
    output logic        ltu,  // a < b (unsigned)
    output logic        gt,   // a > b (signed)
    output logic        gtu   // a > b (unsigned)
);

    // Equality
    assign eq  = (a == b);

    // Signed comparisons
    assign lt  = ($signed(a) < $signed(b));
    assign gt  = ($signed(a) > $signed(b));

    // Unsigned comparisons
    assign ltu = (a < b);
    assign gtu = (a > b);

endmodule