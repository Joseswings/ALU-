# Scripts Tcl

## Organización

- `dc/01_sintesis_dc.tcl`: compila la ALU, genera reportes DC, netlist y SDC.
- `icc2/02_create_ndm.tcl` a `icc2/11_icc2_export_gds.tcl`: generación/importación de biblioteca propia y etapas físicas, hasta GDS. Ejecutar cada etapa en orden y revisar su reporte antes de seguir.
- `legacy/`: scripts iniciales del proyecto, preservados como referencia. No son el flujo final documentado.

Los scripts necesitan rutas locales al PDK y a las herramientas Synopsys. En el servidor se usaron archivos de `/home/chuletax/ALU_Plus_Chuleta/pdk`; son dependencias externas y no se distribuyen aquí. Ajusta rutas y comprueba permisos antes de ejecutar. No pongas credenciales en scripts.

Los logs y reportes de la corrida documentada están en `../reports/`. Los scripts no recrean automáticamente la corrida pasada.
