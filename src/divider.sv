`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.10.2026 23:18:30
// Design Name: 
// Module Name: divider
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


module divider #(parameter WIDTH = 8) (
    input  logic [WIDTH-1:0] a,
    input  logic [WIDTH-1:0] b,
    output logic [WIDTH-1:0] quotient,
    output logic [WIDTH-1:0] remainder
);

    // Operadores nativos para inferencia óptima en síntesis
    assign quotient  = (b != 0) ? (a / b) : {WIDTH{1'b0}};
    assign remainder = (b != 0) ? (a % b) : {WIDTH{1'b0}};

endmodule
