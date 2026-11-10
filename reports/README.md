# Reportes de síntesis e implementación

- `dc/`: QoR, área, timing, potencia y violaciones de restricciones de Design Compiler.
- `icc2/floorplan/`: comprobación del floorplan.
- `icc2/placement/`: QoR, timing y legalidad posterior a placement.
- `icc2/cts/`: CTS, calidad de reloj, setup/hold, PG y legalidad.
- `icc2/post_cts/`: resultados después de CTS, PG y checks asociados.
- `icc2/routing/`: QoR, timing, legalidad y verificación de routing/GDS.

Los archivos corresponden a la corrida cuya netlist, SDC y GDS se guardan en `results/` y `constraints/`. Lee [`../docs/informe_final.md`](../docs/informe_final.md) antes de interpretar métricas. En particular, el routing tiene 528 DRC y conserva violaciones de setup; que el GDS exista no equivale a signoff.
