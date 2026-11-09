`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.10.2026 22:50:26
// Design Name: 
// Module Name: logic_tristate
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module logic_tristate #(parameter WIDTH = 8) (
    input  logic [WIDTH-1:0] a,
    input  logic [WIDTH-1:0] b,
    input  logic [2:0]       alu_control, // El bus de control nos dirá qué activar
    output logic [WIDTH-1:0] and_out,
    output logic [WIDTH-1:0] or_out
);

    // Búfer Tri-estado para la operación AND
    // Si alu_control es 000 (0 en decimal), deja pasar el resultado (a & b).
    // De lo contrario, desconecta el cable (1'bz - Alta impedancia).
    assign and_out = (alu_control == 3'b000) ? (a & b) : {WIDTH{1'bz}};

    // Búfer Tri-estado para la operación OR
    // Si alu_control es 001 (1 en decimal), deja pasar el resultado (a | b).
    // De lo contrario, desconecta el cable (1'bz).
    assign or_out = (alu_control == 3'b001) ? (a | b) : {WIDTH{1'bz}};

endmodule
