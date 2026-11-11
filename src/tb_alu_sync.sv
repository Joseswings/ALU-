`timescale 1ns/1ps

module tb_alu_sync;
    localparam WIDTH = 16;

    logic clk = 0;
    logic rst;
    logic [WIDTH-1:0] a_in, b_in;
    logic [2:0] alu_control_in;
    logic [WIDTH-1:0] result_out;
    logic negative_out, zero_out, carry_out, overflow_out;
    integer tests_passed = 0;

    alu_sync_wrapper #(.WIDTH(WIDTH)) dut (.*);

    always #5 clk = ~clk;

    task automatic check_op(
        input logic [2:0] op,
        input logic [WIDTH-1:0] lhs,
        input logic [WIDTH-1:0] rhs,
        input logic [WIDTH-1:0] expected
    );
        begin
            @(negedge clk);
            a_in = lhs;
            b_in = rhs;
            alu_control_in = op;

            repeat (2) @(posedge clk);
            #1;

            if (result_out !== expected) begin
                $error("FAIL op=%b a=%0d b=%0d: esperado=%0d, obtenido=%0d",
                       op, lhs, rhs, expected, result_out);
                $fatal(1, "La prueba funcional fallo");
            end

            $display("PASS op=%b a=%0d b=%0d resultado=%0d",
                     op, lhs, rhs, result_out);
            tests_passed = tests_passed + 1;
        end
    endtask

    initial begin
        $dumpfile("waves/alu_sync.vcd");
        $dumpvars(0, tb_alu_sync);

        rst = 1;
        a_in = 0;
        b_in = 0;
        alu_control_in = 0;

        repeat (2) @(negedge clk);
        rst = 0;

        check_op(3'b010, 16'd50,  16'd25, 16'd75); // suma
        check_op(3'b100, 16'd10,  16'd5,  16'd50); // multiplicacion
        check_op(3'b101, 16'd100, 16'd3,  16'd33); // cociente
        check_op(3'b110, 16'd100, 16'd3,  16'd1);  // residuo

        $display("RESULTADO: %0d pruebas pasaron", tests_passed);
        $finish;
    end
endmodule
