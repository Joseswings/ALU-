module alu_sync_wrapper #(parameter WIDTH = 16) (
    input  logic             clk,
    input  logic             rst,
    input  logic [WIDTH-1:0] a_in,
    input  logic [WIDTH-1:0] b_in,
    input  logic [2:0]       alu_control_in,
    output logic [WIDTH-1:0] result_out,
    output logic             negative_out, zero_out, carry_out, overflow_out
);

    // Registros internos para capturar las entradas
    logic [WIDTH-1:0] a_reg, b_reg;
    logic [2:0]       alu_control_reg;

    // Cables para conectar la salida combinacional de la ALU hacia los registros de salida
    logic [WIDTH-1:0] alu_result;
    logic             alu_negative, alu_zero, alu_carry, alu_overflow;

    // Instancia de la ALU configurada a 16 bits
    alu_top #(.WIDTH(WIDTH)) alu_inst (
        .a(a_reg),
        .b(b_reg),
        .alu_control(alu_control_reg),
        .result(alu_result),
        .negative(alu_negative),
        .zero(alu_zero),
        .carry(alu_carry),
        .overflow(alu_overflow)
    );

    // Lógica secuencial: Flip-Flops controlados por el flanco de subida del reloj
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            a_reg           <= {WIDTH{1'b0}};
            b_reg           <= {WIDTH{1'b0}};
            alu_control_reg <= 3'b000;
            result_out      <= {WIDTH{1'b0}};
            negative_out    <= 1'b0;
            zero_out        <= 1'b0;
            carry_out       <= 1'b0;
            overflow_out    <= 1'b0;
        end else begin
            // Captura de datos en el primer ciclo de reloj
            a_reg           <= a_in;
            b_reg           <= b_in;
            alu_control_reg <= alu_control_in;
            
            // Captura de resultados en el segundo ciclo de reloj
            result_out      <= alu_result;
            negative_out    <= alu_negative;
            zero_out        <= alu_zero;
            carry_out       <= alu_carry;
            overflow_out    <= alu_overflow;
        end
    end
endmodule