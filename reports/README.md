# Análisis de Reportes de Síntesis (Design Compiler)

Este directorio contiene los reportes fundamentales extraídos de **Synopsys Design Compiler (DC Shell)** tras la síntesis de la ALU Síncrona Parametrizada. 

El diseño fue mapeado desde código RTL (SystemVerilog) hacia celdas físicas estándar utilizando el **PDK de GlobalFoundries para el nodo de 150nm**, específicamente utilizando la librería lógica **M31 (`M31LLSC733GL150MS`)** bajo condiciones de operación típicas ($25^\circ\text{C}$, $3.3\text{V}$). 

A continuación, se presenta un desglose exhaustivo de las métricas obtenidas, su significado físico y las implicaciones microarquitectónicas.

---

## 1. Análisis de Área y Estructura Física (`reporte_dc_area.txt` y `reporte_dc_qor.txt`)

La herramienta mapeó las ecuaciones booleanas y operadores matemáticos a $4891$ celdas físicas reales. El reporte de área nos permite entender cómo se distribuye el silicio:

*   **Área Total del Diseño:** $59786.497\ \mu m^2$
*   **Área Combinacional:** $57010.868\ \mu m^2$ ($\approx 95.3\%$ del total)
    *   *Interpretación:* La abrumadora mayoría del área se destina a lógica pura. Esto es consecuencia directa de la instanciación de un Multiplicador y un Sumador CLA (Carry Look-Ahead) de 16 bits. El multiplicador, al estar desenrollado en hardware, genera un arreglo masivo de sumadores parciales.
*   **Área No Combinacional (Secuencial):** $2775.629\ \mu m^2$ ($\approx 4.7\%$ del total)
    *   *Interpretación:* Representa los $55$ elementos de memoria (Flip-Flops) instanciados en el módulo `alu_sync_wrapper` (registros de entrada $A, B$, control, y salida).
*   **Área de Búferes e Inversores:** $7270.502\ \mu m^2$
    *   *Interpretación:* DC Shell instanció $1098$ búferes e inversores. Gran parte de esto se debe a la necesidad de fortalecer las señales eléctricas (fan-out) para manejar la alta capacitancia de las rutas que van hacia el multiplexor principal.

---

## 2. Análisis de Tiempos y Ruta Crítica (`reporte_dc_timing.txt`)

El análisis estático de tiempos (STA) evalúa si los datos logran atravesar todas las compuertas antes del siguiente flanco de reloj, respetando los tiempos de *Setup* y *Hold* de los Flip-Flops.

### Restricciones (Constraints)
*   **Período de Reloj ($T_{clk}$):** $10.00\text{ ns}$
*   **Frecuencia Objetivo ($f$):** $f = \frac{1}{T_{clk}} = 100\text{ MHz}$

### Diagnóstico del Critical Path (La ruta más lenta)
El *Critical Path* define la máxima velocidad a la que puede operar el procesador entero.
*   **Startpoint:** `b_reg_reg[5]` (Registro de entrada, operando B, bit 5).
*   **Endpoint:** `zero_out_reg` (Registro de la bandera de cero).
*   **Niveles de Lógica:** $69$ niveles (Extremadamente profundo para un solo ciclo de reloj).

**Ecuación de Slack (Margen de tiempo):**
El *Slack* determina si el diseño cumple o falla. Matemáticamente se define como:
$$\text{Slack} = \text{Data Required Time} - \text{Data Arrival Time}$$
Según nuestro reporte:
*   $\text{Data Required Time} = T_{clk} - t_{setup} = 10.00\text{ ns} - 0.16\text{ ns} = 9.84\text{ ns}$
*   $\text{Data Arrival Time} = 10.82\text{ ns}$
*   $$\text{Slack} = 9.84\text{ ns} - 10.82\text{ ns} = -0.99\text{ ns}$$

**Conclusión del Path:** El dato tarda $10.82\text{ ns}$ en llegar, pero debía estar listo en $9.84\text{ ns}$. El retraso está dominado por las densas compuertas `NAND4`, `OAI12` y la pesada compuerta final `XNOR2X1AS7` (que añade $0.41\text{ ns}$ de retardo por sí sola) encargada de comparar si todo el resultado es cero.

---

## 3. Calidad de Resultados - QoR (`reporte_dc_qor.txt`)

El reporte QoR resume la viabilidad global del diseño.
*   **WNS (Worst Negative Slack):** $-0.99\text{ ns}$ (Violación crítica de Setup).
*   **TNS (Total Negative Slack):** $-11.06\text{ ns}$. 
    *   *Significado:* Existen $18$ rutas distintas (*Violating Paths*) que no cumplen con el timing. No es solo un cable fallando, es todo el bus que alimenta la bandera `Zero` y partes del multiplexor.
*   **Violaciones de Hold:** $0.00\text{ ns}$.
    *   *Significado:* Ninguna señal viaja *demasiado rápido*. No hay riesgo de que un dato pise al anterior antes de que el Flip-Flop cierre su ventana de captura.

---

## 4. Estrategias de Mitigación y Optimización Arquitectónica

Para llevar este diseño a un WNS positivo ($\text{Slack} \ge 0$) antes de la fabricación física, se proponen las siguientes soluciones a nivel de microarquitectura (RTL):

1.  **Pipelining (Segmentación):** 
    Dado que el camino crítico actual tiene $69$ niveles lógicos (sumador $\rightarrow$ multiplexor $\rightarrow$ bandera zero), la solución más robusta es insertar una etapa de registros intermedia. Al dividir el procesamiento en dos ciclos de $10\text{ ns}$, el *Data Arrival Time* se partiría por la mitad ($\approx 5.5\text{ ns}$), logrando un Slack holgadamente positivo.
2.  **Relajar Restricciones (Clock Derating):** 
    Si el sistema global lo permite, recalibrar el archivo `.sdc` a un reloj de $T_{clk} = 11.50\text{ ns}$ ($\approx 86.9\text{ MHz}$) eliminaría todas las violaciones actuales sin modificar el código de hardware.
3.  **Optimización del Árbol de Comparación (Bandera Zero):**
    El cálculo `assign zero = (result == 0);` genera un embudo de compuertas XNOR en cascada. Reescribir este operador como un árbol balanceado OR-NOR en SystemVerilog forzaría al sintetizador a crear una estructura más plana y rápida.