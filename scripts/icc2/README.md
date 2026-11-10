# ICC2: power, CTS, routing y GDS

Copiar estos seis Tcl a `~/jose_alu/scripts/`. Todos usan la biblioteca propia `icc2/ALU_Jose_GF150.nlib`, los nets `VCCK/GNDK` confirmados en el LEF y checkpoints `alu_sync_wrapper_*`.

Ejecutar una etapa a la vez y sólo continuar si la anterior termina con su mensaje `COMPLETADO`:

```bash
cd ~/jose_alu
icc2_shell -f scripts/06_icc2_power_setup.tcl
icc2_shell -f scripts/07_icc2_power_grid.tcl
icc2_shell -f scripts/08_icc2_cts.tcl
icc2_shell -f scripts/09_icc2_post_cts.tcl
icc2_shell -f scripts/10_icc2_routing.tcl
icc2_shell -f scripts/11_icc2_export_gds.tcl
```

`10_icc2_routing.tcl` guarda `alu_sync_wrapper_route_initial` justo después de `route_auto`, antes de empezar `route_opt`. Si `route_opt` tarda o falla, ese checkpoint preserva el routing inicial.

Si un script falla, no lances el siguiente. Guarda la salida desde el primer `Error:`. No elimines la NLIB: los checkpoints previos permiten recuperar la etapa anterior.
