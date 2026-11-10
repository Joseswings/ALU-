# Guion de presentación ALU Plus y flujo Synopsys

Duración sugerida: 15 minutos. La evidencia de síntesis y diseño físico está en `reports/`; no afirmes que VCS/Verdi se ejecutaron si no tienes sus logs o capturas.

## 1. Apertura y objetivo (0:00–1:00)

> Presento una ALU síncrona de 16 bits implementada en SystemVerilog y sintetizada con Design Compiler. El flujo físico en IC Compiler II llegó hasta routing y exportación GDS. Voy a explicar la arquitectura, los resultados cuantitativos y las limitaciones que aún impiden considerar el layout listo para fabricación.

Mostrar el `README.md` y la estructura de `src/`, `scripts/`, `reports/` y `results/`.

## 2. Arquitectura RTL (1:00–4:00)

Mostrar `src/alu_sync_wrapper.sv` y describir los registros de entrada/salida y el comportamiento síncrono. Luego enseñar `src/alu_top.sv`: selección de operación, resultado y banderas NZCV. Explicar el sumador CLA, multiplicador, divisor y lógica triestado desde sus módulos respectivos. Aclarar que el testbench está en `src/tb_alu_sync.sv`; mostrar simulación VCS/Verdi únicamente si se cuenta con evidencia real.

## 3. Síntesis y discusión DC (4:00–7:00)

El SDC establece reloj de 10 ns (100 MHz). DC reporta en `reports/dc/dc_qor.rpt` área 59,786.50 µm², 4,891 celdas, WNS −0.99 ns, TNS −11.06 ns y 18 rutas setup violadas; hold tiene cero violaciones. La ruta crítica va de `b_reg_reg[5]` a `zero_out_reg` y contiene 69 niveles lógicos. La ruta combina operación de ALU, selección y cálculo de Zero. La potencia estimada por DC es 6.4688 mW dinámica y 11.9099 nW de fuga; es estimación pre-layout.

Hay una discrepancia que debe explicitarse: `dc_area.rpt` cuenta 87 secuenciales; `dc_qor.rpt`, 55. No elegir un valor arbitrariamente; aclarar que falta confirmar el contexto de generación de esos reportes.

## 4. Flujo físico ICC2 (7:00–11:00)

Mostrar, si se guardaron, capturas del floorplan, placement, CTS y layout routed en `docs/images/icc2/`. La tabla de `docs/informe_final.md` muestra área y timing por checkpoint. El flujo concluyó con la exportación de `results/gds/alu_jose_GF150_routed.gds`.

En routing, el WNS es −2.37 ns, TNS −36.33 ns y siguen 18 rutas setup violadas. CTS reporta skew global 0.22 ns y latencia 9.68 ns. El reporte de legalidad pasa y hay cero nets abiertas, pero el chequeo global reporta 528 DRC. Por tanto, GDS generado no equivale a signoff ni a un layout limpio.

El chequeo PG específico no encontró errores. VCCK/GNDK figuran conectados sin celdas flotantes; VDD/VSS no muestran wires ni vías en ese reporte, lo cual debe verificarse contra las redes que espera la biblioteca. No hay reglas de antena definidas, así que esa verificación no se completó.

## 5. Qué se aprendió y trabajo pendiente (11:00–13:30)

> El flujo permitió comparar síntesis y etapas físicas con evidencia real. El timing empeoró tras placement/CTS y mejoró parcialmente luego, pero continúa negativo. La legalidad de placement y la conectividad de nets de señal no sustituyen la revisión DRC. Lo pendiente es clasificar/corregir los 528 DRC, confirmar la conectividad de potencia, revisar antena y optimizar la ruta crítica; después hay que repetir los checks.

No atribuir todos los DRC a una causa sin inspeccionar categorías y geometría. Cualquier cambio RTL, constraints o floorplan debe volver a verificarse y sintetizarse.

## 6. Cierre y entrega (13:30–15:00)

> Entrego RTL, scripts, restricciones, reportes de síntesis e implementación y el GDS generado, sujeto a las reglas de distribución del PDK. El resultado físico llegó a GDS, pero mantiene DRC y violaciones setup; esos límites están declarados. La NLIB y las bibliotecas propietarias no se publican. Las capturas y videos por inciso se enlazan desde el README cuando estén preparados.

Antes de la presentación, colocar capturas legibles en `docs/images/` y enlaces a los videos no listados en `README.md`. Añadir evidencia de VCS/Verdi si está disponible.
