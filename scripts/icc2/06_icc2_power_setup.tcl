# Power setup propio. Requiere el checkpoint de placement.
# Ejecutar desde ~/jose_alu: icc2_shell -f scripts/06_icc2_power_setup.tcl

set ROOT [file normalize [pwd]]
set DESIGN_LIB "$ROOT/icc2/ALU_Jose_GF150.nlib"
set INPUT_BLOCK alu_sync_wrapper_placement
set OUTPUT_BLOCK alu_sync_wrapper_power_setup

if {![file exists $DESIGN_LIB]} { error "No existe la biblioteca: $DESIGN_LIB" }
file mkdir "$ROOT/reports"
open_lib $DESIGN_LIB
open_block $INPUT_BLOCK

puts "===== CREANDO NETS DE ALIMENTACION ====="
if {[sizeof_collection [get_nets -quiet VCCK]] == 0} { create_net -power VCCK }
if {[sizeof_collection [get_nets -quiet GNDK]] == 0} { create_net -ground GNDK }

puts "===== CONECTANDO PINES DE CELDAS ====="
set pwr_pins [get_pins -physical_context -quiet */VCCK]
set gnd_pins [get_pins -physical_context -quiet */GNDK]
if {[sizeof_collection $pwr_pins] == 0} { error "No se encontraron pines fisicos */VCCK" }
if {[sizeof_collection $gnd_pins] == 0} { error "No se encontraron pines fisicos */GNDK" }
connect_pg_net -net VCCK $pwr_pins
connect_pg_net -net GNDK $gnd_pins

puts "===== COLOCANDO PINES EXTERIORES ====="
place_pins -self

redirect -file "$ROOT/reports/icc2_power_setup_pg.rpt" { check_pg_connectivity }
save_block -as $OUTPUT_BLOCK
save_lib
puts "POWER SETUP COMPLETADO: $OUTPUT_BLOCK"
exit
