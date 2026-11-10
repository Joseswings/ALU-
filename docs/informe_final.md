# Informe de resultados y discusión

## Alcance y reproducibilidad

El diseño implementa una ALU síncrona de 16 bits con RTL en `../src/`, testbench en `../src/tb_alu_sync.sv`, síntesis DC y flujo ICC2. La corrida física llegó a exportar GDS. La carpeta `scripts/icc2/` documenta las etapas; las bibliotecas GF150/M31 y la tecnología son dependencias externas, no incluidas en este repositorio por confidencialidad/licencia. Ajusta las rutas en los Tcl al entorno autorizado. Reportes completos: [`../reports/`](../reports/README.md).

## Síntesis lógica (DC)

La restricción de reloj es de 10 ns, equivalente a 100 MHz. `dc_qor.rpt` reporta área de celda de 59,786.50 µm², 4,891 celdas, WNS −0.99 ns, TNS −11.06 ns y 18 rutas con setup violado; hold no tiene violaciones. `dc_power.rpt` estima 6.4688 mW dinámicos y 11.9099 nW de fuga. Es una estimación de síntesis bajo el modelo indicado en el reporte, no una medición física post-route.

La ruta crítica DC inicia en `b_reg_reg[5]` y termina en `zero_out_reg`, grupo `clk`, con 69 niveles lógicos. La combinación de lógica aritmética, selección de resultado y cálculo de la bandera Zero contribuye al camino largo. Esto identifica una oportunidad de optimización; cualquier pipeline o cambio de RTL debe volver a verificarse funcionalmente y sintetizarse para medir su efecto.

**Discrepancia pendiente:** `dc_area.rpt` reporta 87 celdas secuenciales y 4,804 combinacionales, mientras `dc_qor.rpt` reporta 55 secuenciales y 4,836 combinacionales. Ambos muestran 4,891 celdas totales y la misma área. Debe aclararse revisando el contexto exacto de generación de ambos reportes; no se debe ocultar ni escoger un valor sin explicación. Los reportes originales están en `../reports/dc/`.

## Evolución de timing y área en ICC2

Reloj objetivo: 10 ns. Los valores de área son área de celdas reportada por el QoR de cada checkpoint.

| Etapa | Área (µm²) | WNS (ns) | TNS (ns) | Rutas setup violadas | Hold |
|---|---:|---:|---:|---:|---:|
| DC | 59,786.50 | −0.99 | −11.06 | 18 | 0 |
| Placement | 59,213.95 | −2.56 | −37.38 | 18 | 0 |
| CTS | 59,434.91 | −2.71 | −40.99 | 18 | 0 |
| Post-CTS | 56,975.39 | −2.31 | −35.48 | 18 | 0 |
| Routing | 57,286.66 | −2.37 | −36.33 | 18 | 0 |

El timing empeora entre DC y placement/CTS y mejora parcialmente tras post-CTS y routing; aun así, el cierre de setup no se logra. El camino crítico post-route parte de `b_reg_reg[5]` y llega a `result_out_reg[1]`. El reporte de timing muestra propagación por múltiples celdas combinacionales; el reporte completo está en `../reports/icc2/routing/icc2_routing_setup.rpt`.

## CTS y reloj

`icc2_cts_clock_qor.rpt` informa 55 sinks, dos niveles de repetidores, área de repetidores de 9.68, latencia de reloj de 9.68 ns y skew global de 0.22 ns. `icc2_cts_clock_settings.rpt` informa skew objetivo 0 y latencia objetivo no especificada. El skew reportado no es cero, por lo que se registra como resultado medido. Consultar los reportes originales para contexto de unidades y escenario.

## Routing, legalidad, PG y DRC

- `icc2_routing_legality.rpt`: `check_legality` termina exitosamente.
- `icc2_routing_check.rpt`: 4,672 nets, cero nets abiertas y **528 DRC**. También indica que no hay reglas de antena definidas; por tanto, no se puede afirmar que antenna esté verificado. El mismo reporte señala que las vías aparecen no mapeadas en las capas de vía listadas, una limitación que debe mencionarse al presentar la interpretación física.
- `icc2_pg_connectivity.rpt`: 4,751 celdas estándar; VCCK y GNDK tienen cero celdas flotantes. VDD y VSS muestran cero wires/vías y cero flotantes; esto indica que esos nets no están conectados en ese reporte, no prueba que estén conectados. Confirmar los nombres esperados en la biblioteca/intent de potencia antes de concluir conectividad completa.
- `icc2_pg_drc.rpt`: el chequeo específico de DRC de PG dice “No errors found”. Esto no contradice los 528 DRC generales de routing: son verificaciones diferentes.
- `icc2_routing_qor.rpt`: WNS −2.37 ns, TNS −36.33 ns, 18 rutas con setup violado y cero violaciones hold.

El GDS se exportó y mide 3,711,106 bytes. Su existencia demuestra que el comando de exportación finalizó; no demuestra que se hayan corregido las violaciones de routing ni que el diseño haya pasado signoff. Los DRC no están corregidos en esta corrida y deben presentarse como limitación/pendiente, no como resultado limpio.

## Respuestas a la discusión

1. **¿Cumple el timing de 100 MHz?** No. En DC el WNS es −0.99 ns; post-route es −2.37 ns. El TNS post-route es −36.33 ns y hay 18 rutas de setup violadas.
2. **¿Cuál es la ruta crítica?** DC: `b_reg_reg[5]` → `zero_out_reg`. Post-route: `b_reg_reg[5]` → `result_out_reg[1]`, grupo `clk`.
3. **¿Qué explica el retardo?** DC muestra 69 niveles lógicos; post-route el camino atraviesa una cadena de lógica combinacional. El cálculo de la operación, selección del resultado y banderas contribuyen. La ruta debe analizarse completa en los informes STA antes de atribuir el retraso a una sola celda.
4. **¿Qué cambió de área?** El QoR de ICC2 pasa de 59,213.95 µm² en placement a 57,286.66 µm² en routing. Esto refleja las áreas reportadas en checkpoints distintos; no debe interpretarse como una comparación de áreas de die/core.
5. **¿CTS cerró el timing?** No. El skew global reportado es 0.22 ns y routing conserva setup negativo. Hold tiene cero violaciones en los QoR entregados.
6. **¿Está limpio el layout?** No: legality sí pasa, y el routing reporta cero nets abiertas, pero quedan 528 DRC generales y no hay reglas de antena definidas para verificarlas.
7. **¿Está completa la conectividad de potencia?** VCCK/GNDK aparecen conectados sin celdas flotantes; VDD/VSS no muestran wires ni vías. Hace falta confirmar si VDD/VSS son nets esperados para este flujo.
8. **¿Qué sigue para mejorar?** Aclarar la discrepancia de conteo DC; confirmar conectividad PG y layermap de vías; revisar y clasificar las 528 DRC; ajustar floorplan/reglas/constraints según el origen de cada violación; optimizar la ruta crítica (por ejemplo, arquitectura del cálculo Zero o segmentación) y repetir verificación funcional, síntesis y physical design. No se debe cambiar la frecuencia objetivo sólo para ocultar una violación sin justificar el requisito del sistema.

## Evidencia visual y entrega

Añadir capturas seleccionadas en [`images/`](images/README.md): RTL/testbench, simulación, reportes DC, floorplan, CTS y layout routed. Incluir enlaces a los videos por inciso en el README raíz cuando estén grabados. No se recibieron logs de VCS/Verdi ni checkpoints ICC2 en el paquete descargado, así que siguen pendientes para una entrega totalmente reproducible si la rúbrica los exige.
