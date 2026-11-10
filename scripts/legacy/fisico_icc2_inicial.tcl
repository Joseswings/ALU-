# Flujo ICC2 para la ALU sintetizada con Design Compiler.
#
# Ejecútalo DESDE el directorio de corrida en el servidor. Los cuatro
# argumentos de tecnología se pasan como variables Tcl, para que este archivo
# no dependa de rutas copiadas/concatenadas accidentalmente:
#
# icc2_shell -f fisico_icc2.tcl \
#   -x "set TECH_FILE /ruta/gf150...ndm.tf; \
#       set REF_NDM /ruta/M31_Libreria_Fisica.ndm; \
#       set NETLIST /ruta/alu_sintetizada.v; \
#       set SDC /ruta/restricciones_alu.sdc"
#
# Si las variables no se pasan, se usan los nombres de archivo del directorio
# de corrida. TECH_FILE y REF_NDM sí deben ser rutas absolutas reales.

if {![info exists TECH_FILE]} { set TECH_FILE "" }
if {![info exists REF_NDM]}   { set REF_NDM   "" }
if {![info exists NETLIST]}   { set NETLIST   "alu_sintetizada.v" }
if {![info exists SDC]}       { set SDC       "restricciones_alu.sdc" }
set TOP alu_sync_wrapper
set DESIGN_LIB alu_chip.dlib

proc require_file {label path} {
    if {$path eq "" || ![file isfile $path]} {
        error "CONFIGURACION: $label no existe o no es un archivo: '$path'"
    }
}

# No reutilices una dlib creada con otra tecnología o una corrida previa.
# No la borramos automáticamente: una corrida anterior puede ser valiosa.
if {[file exists $DESIGN_LIB]} {
    error "CONFIGURACION: ya existe '$DESIGN_LIB'. Usa un directorio de corrida limpio o cambia DESIGN_LIB."
}

require_file TECH_FILE $TECH_FILE
require_file REF_NDM   $REF_NDM
require_file NETLIST   $NETLIST
require_file SDC       $SDC

# En ICC2, la biblioteca física M31 debe ser una referencia NDM de la dlib;
# design.link_library por sí sola (con un .db) no proporciona geometría,
# sites ni abstracts para colocar celdas.
create_lib -technology $TECH_FILE -ref_libs [list $REF_NDM] $DESIGN_LIB
read_verilog -top $TOP $NETLIST
read_sdc $SDC

# Detecta el problema antes de que place_opt emita mensajes derivados y poco
# útiles. Cualquier instancia no enlazada normalmente indica una pareja
# netlist/NDM distinta o un NDM M31 equivocado.
if {[sizeof_collection [get_cells -quiet -filter "is_unlinked == true"]] > 0} {
    report_design_mismatch -verbose
    error "LINK: hay celdas sin enlazar. Verifica que REF_NDM sea la M31 usada por DC."
}

initialize_floorplan -core_utilization 0.65 -core_aspect_ratio 1.0

# Sin filas de placement no existe una ubicación legal para las standard cells.
if {[sizeof_collection [get_rows -quiet]] == 0} {
    error "FLOORPLAN: no se crearon placement rows. TECH_FILE/REF_NDM no definen un site compatible."
}

check_design -checks {dp_pre_floorplan dp_pre_place_opt} > check_design_pre_place_opt.rpt
place_opt
report_qor > reporte_icc2_qor_place.txt
report_timing > reporte_icc2_timing_place.txt

clock_opt
report_timing > reporte_icc2_timing_clock.txt

route_auto
route_opt
report_qor > reporte_icc2_qor_final.txt
report_timing > reporte_icc2_timing_final.txt

save_block -as alu_final
write_gds alu_layout.gds
