module tb_alu_sync;
    parameter WIDTH = 16;
    
    logic             clk;
    logic             rst;
    logic [WIDTH-1:0] a_in, b_in;
    logic [2:0]       alu_control_in;
    logic [WIDTH-1:0] result_out;
    logic             negative_out, zero_out, carry_out, overflow_out;

    // Instancia del sistema síncrono
    alu_sync_wrapper #(.WIDTH(WIDTH)) dut (.*);

    // Generación del reloj (Periodo de 10ns)
    always #5 clk = ~clk;

    initial begin
        // Inicialización y Reset
        clk = 0; rst = 1;
        a_in = 0; b_in = 0; alu_control_in = 0;
        #15 rst = 0;

        // Estímulo 1: Suma (010) -> 50 + 25
        a_in = 16'd50; b_in = 16'd25; alu_control_in = 3'b010;
        #20; // Esperar 2 ciclos de reloj

        // Estímulo 2: Multiplicación (100) -> 10 * 5
        a_in = 16'd10; b_in = 16'd5; alu_control_in = 3'b100;
        #20;

        // Estímulo 3: División Cociente (101) -> 100 / 3
        a_in = 16'd100; b_in = 16'd3; alu_control_in = 3'b101;
        #20;

        $finish;
    end
endmodule