# Síntesis Lógica y Análisis de Timing (ALU Síncrona)

Este repositorio documenta la primera fase del diseño físico (Physical Design) de una ALU síncrona parametrizada, utilizando **Design Compiler (DC Shell)** de Synopsys. 

Debido a una caída documentada en el servidor central que impidió la ejecución de IC Compiler II (Place & Route), este repositorio se enfoca en el análisis exhaustivo de la **Síntesis Lógica** (Gate-Level Netlist) utilizando la tecnología de **150nm de GlobalFoundries** y las librerías estándar de **M31**.

## Análisis de Resultados de Síntesis (Design Compiler)

A partir de los reportes generados (`/reports`), se extrajeron las siguientes métricas y diagnósticos del hardware sintetizado:

### 1. Área y Conteo de Celdas
* **Área total del diseño:** `59786.497 µm²`
* **Cantidad de celdas lógicas:** `4891 celdas` utilizadas de la librería M31.

### 2. Reloj y Frecuencia Objetivo
* **Período del reloj configurado (SDC):** `10.00 ns`
* **Frecuencia de operación equivalente:** `100 MHz`

### 3. Análisis de Tiempos (Timing Analysis)
El diseño fue evaluado bajo las restricciones del reloj para verificar si las señales logran propagarse antes del siguiente flanco de subida.
* **WNS (Worst Negative Slack):** `-0.99 ns`
* **TNS (Total Negative Slack):** `-11.06 ns`
* **Veredicto:** El diseño **NO cumple con el timing actual**. El valor negativo en el WNS indica que la ruta más lenta del circuito se retrasa casi 1 nanosegundo respecto a la meta de 10 ns.

### 4. Diagnóstico de la Ruta Crítica (Critical Path)
Al inspeccionar el reporte de timing (`report_timing.txt`), se identificó la ruta exacta que está causando la violación de tiempo:
* **Startpoint:** Flip-Flop de entrada `b_reg_reg[5]` (activado por el flanco del reloj).
* **Endpoint:** Flip-Flop de bandera `zero_out_reg` (activado por el flanco del reloj).
* **Path Group:** `clk`
* **Elementos causantes del retraso:** El mayor tiempo de propagación ocurre al atravesar el **árbol del multiplexor** de salida y, finalmente, la **compuerta XNOR** gigante que funciona como comparador para determinar si todos los bits del resultado son ceros (Bandera Z).

### 5. Propuesta de Optimización
Para solucionar el WNS negativo y lograr que el diseño cierre el timing a 100 MHz sin cambiar la tecnología, la solución arquitectónica recomendada es implementar **Segmentación (Pipelining)**. 
* **Justificación:** Insertar una etapa extra de registros (Flip-Flops) justo después del multiplexor principal y antes del cálculo de las banderas dividirá el camino combinacional largo en dos caminos más cortos. Esto reducirá drásticamente el retraso máximo entre registros, permitiendo que el *slack* se vuelva positivo a costa de agregar un ciclo de reloj de latencia al sistema.

---
*Nota: Los scripts de ejecución y los archivos fuente de SystemVerilog se encuentran en sus respectivas carpetas para auditoría.*