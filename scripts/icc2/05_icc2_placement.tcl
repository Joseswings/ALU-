# Ejecuta place_opt sobre el floorplan con parasitarias ya cargadas.
# Ejecutar desde /home/chuletax/jose_alu:
#   icc2_shell -f scripts/05_icc2_placement.tcl

set ROOT [file normalize [pwd]]
set TOP alu_sync_wrapper
set DESIGN_LIB "$ROOT/icc2/ALU_Jose_GF150.nlib"

if {![file exists $DESIGN_LIB]} { error "Falta biblioteca de diseno: $DESIGN_LIB" }
file mkdir "$ROOT/reports"
open_lib $DESIGN_LIB
open_block ${TOP}_floorplan
set_host_options -max_cores 4

place_opt

redirect -file "$ROOT/reports/icc2_placement_legality.rpt" { check_legality }
redirect -file "$ROOT/reports/icc2_placement_timing.rpt" { report_timing -delay_type max -max_paths 10 }
redirect -file "$ROOT/reports/icc2_placement_qor.rpt" { report_qor }
save_block -as ${TOP}_placement
save_lib
puts "PLACEMENT COMPLETADO"
exit
