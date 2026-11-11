# ALU síncrona: síntesis y diseño físico

Proyecto académico de una ALU parametrizable en SystemVerilog, sintetizada con Synopsys Design Compiler e implementada hasta routing y exportación GDS con IC Compiler II (ICC2), usando el flujo GF150/M31 disponible en el servidor universitario.

## Estado de la implementación

El flujo llegó a la exportación de `results/gds/alu_jose_GF150_routed.gds`. El GDS es un resultado de implementación, pero **no es un signoff limpio**: el reporte final de routing registra 528 DRC y el timing conserva 18 rutas con setup negativo (WNS −2.37 ns, TNS −36.33 ns para un reloj de 10 ns). La legalidad de celdas y las nets abiertas no reportan errores. Detalles, limitaciones y discrepancias están documentados en [`docs/informe_final.md`](docs/informe_final.md).

## Navegación

- [`src/`](src/README.md): RTL y testbench SystemVerilog.
- [`constraints/`](constraints/restricciones_alu.sdc): restricciones temporales usadas por DC.
- [`scripts/`](scripts/README.md): scripts de síntesis e ICC2 y dependencias externas.
- [`reports/`](reports/README.md): reportes organizados por etapa.
- [`results/`](results/README.md): netlist sintetizada y GDS generado.
- [`verification/`](verification/README.md): testbench, logs VCS y evidencia visual Verdi de cuatro casos funcionales.
- [`docs/informe_final.md`](docs/informe_final.md): análisis de resultados y respuestas de discusión.
- [`docs/images/`](docs/images/README.md): galería comentada de capturas ICC2 y Verdi.
- [`GUION_PRESENTACION_ALU.md`](GUION_PRESENTACION_ALU.md): guion de exposición; requiere actualizarse con estos resultados físicos antes de grabar.

## Herramientas y archivos externos

Los scripts se ejecutan en un entorno autorizado con Synopsys DC/ICC2 y acceso al PDK GF150/M31. Las rutas del servidor se deben ajustar al entorno de quien ejecute el flujo. Las bibliotecas propietarias del PDK (`.db`, `.ndm`, LEF y archivos tecnológicos) **no se incluyen en este repositorio**. No publiques esos archivos ni derivados si la licencia del curso/PDK no lo permite.

Los videos de entrega deben enlazarse aquí cuando estén listos. Añade un enlace no listado por inciso y asegúrate de que la grabación cumpla las instrucciones de la clase.

## Estructura

```text
src/                         RTL y testbench
constraints/                 SDC
scripts/dc/                  síntesis
scripts/icc2/                importación, floorplan, place, PG, CTS, routing, GDS
scripts/legacy/              versiones iniciales conservadas para trazabilidad
reports/dc/                  reportes de Design Compiler
reports/icc2/<etapa>/        reportes físicos por etapa
results/netlist/             netlist DC
results/gds/                 GDS final exportado
docs/                        análisis, evidencia gráfica y presentación
```
