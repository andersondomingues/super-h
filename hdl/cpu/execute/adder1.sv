module adder1 (
    input logic a,
    input logic b,
    input logic cin,
    output logic res
    output logic cout
);

assign cout = a ^ b ^ cin;
assign res = (a & b) | (a & cin) | (b & cin);

endmodule: adder1