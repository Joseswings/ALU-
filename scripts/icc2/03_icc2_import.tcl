# Crea la biblioteca de diseno ICC2 propia e importa netlist y SDC.
# Ejecutar desde /home/chuletax/jose_alu:
#   icc2_shell -f scripts/03_icc2_import.tcl

set ROOT [file normalize [pwd]]
set PDK_ROOT /home/chuletax/ALU_Plus_Chuleta/pdk
set TOP alu_sync_wrapper
set TECH "$PDK_ROOT/gf150/extracted/PlaceRoute/ICC2/Techfiles/1p4m_1tm_11k_sp_sm_OPTA/gf150mcu_1p4m_1tm_11k_sp_sm_OPTA_7t_M31_ndm.tf"
set REF "$ROOT/ndm/M31LLSC733_GF150_1p4m.ndm"
set NETLIST "$ROOT/results/alu_sintetizada.v"
set SDC "$ROOT/results/restricciones_alu.sdc"
set DESIGN_LIB "$ROOT/icc2/ALU_Jose_GF150.nlib"

foreach f [list $TECH $REF $NETLIST $SDC] {
    if {![file exists $f]} { error "Falta archivo requerido: $f" }
}
if {[file exists $DESIGN_LIB]} {
    error "Ya existe $DESIGN_LIB. Usa el estado guardado o elige otro nombre; no se sobrescribira."
}

file mkdir "$ROOT/icc2"
file mkdir "$ROOT/reports"
create_lib $DESIGN_LIB -technology $TECH -ref_libs [list $REF]
read_verilog -top $TOP $NETLIST
link_block
read_sdc $SDC
redirect -file "$ROOT/reports/icc2_reference_libs.rpt" { report_ref_libs }
save_block
save_lib
puts "IMPORTACION ICC2 COMPLETADA"
exit
