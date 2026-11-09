# Reportes de Síntesis Lógica

Esta carpeta almacena los resultados de la extracción de métricas generados por **Synopsys Design Compiler** tras compilar el código RTL con la tecnología GF 150nm.

## 📂 Archivos de Reporte
* **`reporte_dc_area.txt`**: Detalla el recuento total de celdas lógicas estandarizadas utilizadas de la librería M31 y el área total de silicio proyectada (en micrómetros cuadrados, µm²).
* **`reporte_dc_timing.txt`**: Muestra el desglose del *Critical Path* (la ruta más lenta del circuito). Identifica el *Startpoint* (Flip-Flop de origen), el *Endpoint* (Flip-Flop de destino) y el tiempo de propagación exacto a través de cada compuerta y multiplexor interno.
* **`reporte_dc_qor.txt`**: Resumen de Calidad de Resultados (Quality of Results). Proporciona la visión global del cumplimiento de tiempos, incluyendo el **WNS** (Worst Negative Slack) y el **TNS** (Total Negative Slack), confirmando el margen de tiempo restante respecto al reloj de 100 MHz.