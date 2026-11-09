module alu_top #(parameter WIDTH = 8) (
    input  logic [WIDTH-1:0] a,
    input  logic [WIDTH-1:0] b,
    input  logic [2:0]       alu_control,
    output logic [WIDTH-1:0] result,
    output logic             negative, zero, carry, overflow
);

    // Cables internos de interconexión
    logic [WIDTH-1:0] sum_result, and_result, or_result, mult_result;
    logic [WIDTH-1:0] b_mux;
    logic [WIDTH/4:0] carry_chain;

    // Preparación para la resta (Complemento a 2)
    // Si alu_control es 011 (Resta), invierte 'b' y pone el Cin inicial en 1.
    assign b_mux = (alu_control == 3'b011) ? ~b : b;
    assign carry_chain[0] = (alu_control == 3'b011) ? 1'b1 : 1'b0;

    // Instanciación dinámica del Sumador CLA de 4 bits (Bloque Generate)
    genvar i;
    generate
        for (i = 0; i < WIDTH/4; i = i + 1) begin : cla_blocks
            adder_cla adder_inst (
                .a(a[(i*4)+3 : i*4]),
                .b(b_mux[(i*4)+3 : i*4]),
                .cin(carry_chain[i]),
                .s(sum_result[(i*4)+3 : i*4]),
                .cout(carry_chain[i+1])
            );
        end
    endgenerate

    // Instancia del Multiplicador Parametrizado
    multiplier #(.WIDTH(WIDTH)) mult_inst (
        .a(a),
        .b(b),
        .p(mult_result)
    );

    // Instancia de la Lógica Tri-estado (AND / OR)
    logic_tristate #(.WIDTH(WIDTH)) tristate_inst (
        .a(a),
        .b(b),
        .alu_control(alu_control),
        .and_out(and_result),
        .or_out(or_result)
    );

// Instancia del Divisor Parametrizado
    divider #(.WIDTH(WIDTH)) div_inst (
        .a(a),
        .b(b),
        .quotient(div_quotient),
        .remainder(div_remainder)
    );

    // Multiplexor principal (Operador Ternario nativo)
    assign result = (alu_control == 3'b000) ? and_result :
                    (alu_control == 3'b001) ? or_result  :
                    (alu_control == 3'b010) ? sum_result : // Suma
                    (alu_control == 3'b011) ? sum_result : // Resta
                    (alu_control == 3'b100) ? mult_result: // Multiplicador
                    (alu_control == 3'b101) ? div_quotient:// Divisor (Cociente)
                    (alu_control == 3'b110) ? div_remainder:// Divisor (Residuo)
                    (alu_control == 3'b111) ? {WIDTH{1'b0}} : 
                    {WIDTH{1'bx}}; // Optimizador de síntesis

    // Banderas (NZCV)
    assign negative = result[WIDTH-1];
    assign zero     = (result == {WIDTH{1'b0}});
    assign carry    = (alu_control == 3'b010 || alu_control == 3'b011) ? carry_chain[WIDTH/4] : 1'b0;
    assign overflow = (alu_control == 3'b010 || alu_control == 3'b011) ?
                      (~(a[WIDTH-1] ^ b_mux[WIDTH-1]) & (a[WIDTH-1] ^ sum_result[WIDTH-1])) : 1'b0;

endmodule