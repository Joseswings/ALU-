# Scripts de Automatización (Tcl)

Esta carpeta contiene los scripts ejecutables desarrollados para automatizar el flujo de diseño ASIC utilizando las herramientas de **Synopsys** y el PDK de GlobalFoundries a 150nm con librerías M31.

## 📂 Archivos Tcl
* **`sintesis_dc.tcl`**: Script para **Design Compiler (DC Shell)**. Se encarga de cargar las librerías lógicas (`.db`), leer los archivos SystemVerilog, aplicar las restricciones temporales (reloj de 10 ns) y ejecutar la compilación (`compile -exact_map`). Fue el encargado de generar la Netlist y los reportes de área y tiempos.
* **`fisico_icc2.tcl`**: Script diseñado para **IC Compiler II**. Contiene los comandos para el flujo de diseño físico (Floorplanning, Placement, Clock Tree Synthesis y Routing). *(Nota: La ejecución de este script quedó en pausa debido a la interrupción documentada del servidor central).*