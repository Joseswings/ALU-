# Exporta GDS desde el checkpoint propio routed.
# Ejecutar desde ~/jose_alu: icc2_shell -f scripts/11_icc2_export_gds.tcl

set ROOT [file normalize [pwd]]
set PDK_ROOT /home/chuletax/ALU_Plus_Chuleta/pdk
set DESIGN_LIB "$ROOT/icc2/ALU_Jose_GF150.nlib"
set MAP "$PDK_ROOT/gf150/extracted/PlaceRoute/ICC2/Techfiles/1p4m_1tm_11k_sp_sm_OPTA/gf150mcu_1p4m_1tm_11k_sp_sm_OPTA_gds2OutLayer.map"
set GDS "$ROOT/gds/alu_jose_GF150_routed.gds"

foreach f [list $DESIGN_LIB $MAP] {
    if {![file exists $f]} { error "Falta archivo requerido: $f" }
}
file mkdir "$ROOT/gds"
open_lib $DESIGN_LIB
open_block alu_sync_wrapper_routed

write_gds -hierarchy all -layer_map $MAP -lib_cell_view frame $GDS
if {![file exists $GDS]} { error "No se genero GDS: $GDS" }
puts "GDS GENERADO: $GDS ([file size $GDS] bytes)"
exit
