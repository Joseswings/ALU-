# Ejecución del flujo en el servidor

Este documento resume el flujo que produjo los artefactos archivados en el repositorio. El PDK se usa desde la ruta autorizada `/home/chuletax/ALU_Plus_Chuleta/pdk`; no se copia ni se publica aquí.

En la corrida reportada se ejecutaron Design Compiler y las etapas ICC2 hasta GDS. Para reproducir, sube `src/*.sv`, `constraints/restricciones_alu.sdc` y los Tcl de `scripts/` a una carpeta propia del servidor. Comprueba las rutas configuradas en los scripts antes de correrlos.

Orden documentado:

```bash
cd ~/jose_alu
dc_shell -f scripts/01_sintesis_dc.tcl
icc2_lm_shell -f scripts/02_create_ndm.tcl
icc2_shell -f scripts/03_icc2_import.tcl
icc2_shell -f scripts/04_icc2_floorplan.tcl
icc2_shell -f scripts/05_icc2_placement.tcl
icc2_shell -f scripts/06_icc2_power_setup.tcl
icc2_shell -f scripts/07_icc2_power_grid.tcl
icc2_shell -f scripts/08_icc2_cts.tcl
icc2_shell -f scripts/09_icc2_post_cts.tcl
icc2_shell -f scripts/10_icc2_routing.tcl
icc2_shell -f scripts/11_icc2_export_gds.tcl
```

Ejecuta y valida cada etapa antes de continuar. Las rutas, versiones de herramienta y nombres de checkpoint deben coincidir con la corrida. El flujo está completo hasta GDS, pero los reportes actuales conservan 528 DRC y timing setup negativo. Esta lista no garantiza que una nueva ejecución reproduzca idénticos resultados sin el mismo entorno, PDK y checkpoints.
