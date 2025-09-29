import sh1_defs::shifter_ops;

module shifter (
    input  logic T_in,
    input  logic[31:0] operand_a,
    input  logic[7:0]  operation,
    output logic[31:0] result_a,
    output logic T_out
)

always_comb begin
    unique case (operation)
        shifter_ops::ROTL: begin
            T_out = operand_a[31];
        end
        shifter_ops::ROTR: begin
            T_out = operand_a[0];
        end
        shifter_ops::ROTCL: begin
            T_out = operand_a[31];
        end
        shifter_ops::ROTCR: begin
            T_out = operand_a[0];
        end
        shifter_ops::SHAL: begin
            T_out = operand_a[31];
        end
        shifter_ops::SHAR: begin
            T_out = operand_a[31];
        end
        shifter_ops::SHLL: begin
            T_out = operand_a[31];
        end
        shifter_ops::SHLR: begin
            T_out = operand_a[0];
        end
        default: begin
            T_out = 1'b0;
        end
    endcase
end

always_comb begin
    unique case (operation)
        shifter_ops::ROTL: begin
            result_a = {operand_a[30:0], 1'b0} | {31{0}, T_in};    
        end
        shifter_ops::ROTR: begin
            result_a = {1'b0, operand_a[30:1]} | {T_in, 31{0}};
        end
        shifter_ops::ROTCL: begin
            result_a = {operand_a[30:0], 0} | {31{0}, T_in};
        end
        shifter_ops::ROTCR: begin
            result_a = {1'b0, operand_a[30:1]} | {T_in, 31{0}};
        end
        shifter_ops::SHAL: begin
            result_a = {operand_a[31], T_in[29:0], 1'b0};
        end
        shifter_ops::SHAR: begin
            result_a = {operand_a[31], 1'b0, T_in[31:1]};
        end
        shifter_ops::SHLL: begin
            result_a = {T_in[30:0], 1'b0};
        end
        shifter_ops::SHLR: begin
            result_a = {1'b0, T_in[31:1]};
        end
        shifter_ops::SHLL2: begin
            result_a = {T_in[29:0], 2'b00};
        end
        shifter_ops::SHLR2: begin
            result_a = {2'b00, T_in[31:2]};
        end
        shifter_ops::SHLL8: begin
            result_a = {T_in[23:0], 8'b00000000};
        end
        shifter_ops::SHLR8: begin
            result_a = {8'b00000000, T_in[31:8]};
        end
        shifter_ops::SHLL16: begin
            result_a = {T_in[15:0], 16'b0000000000000000};
        end
        shifter_ops::SHLR16: begin
            result_a = {16'b0000000000000000, T_in[31:16]};
        end  
        default: begin
            resulta_a = operand_a;
        end 
    endcase
end
endmodule: shifter