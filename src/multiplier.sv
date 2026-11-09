`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.10.2026 22:02:28
// Design Name: 
// Module Name: multiplier
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


module multiplier #(parameter WIDTH = 8) (
    input  logic [WIDTH-1:0] a,
    input  logic [WIDTH-1:0] b,
    output logic [WIDTH-1:0] p
);
    
    // El operador * infiere el hardware multiplicador óptimo.
    // Dado que el resultado matemático de N * N bits es de 2N bits,
    // extraemos solo los bits menos significativos (WIDTH-1:0)
    // para acoplarnos al bus estándar de la ALU.
    assign p = (a * b);

endmodule
