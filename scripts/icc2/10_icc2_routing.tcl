# Routing de señales y optimizacion para la ALU propia.
# Ejecutar desde ~/jose_alu: icc2_shell -f scripts/10_icc2_routing.tcl

set ROOT [file normalize [pwd]]
set DESIGN_LIB "$ROOT/icc2/ALU_Jose_GF150.nlib"
set INPUT_BLOCK alu_sync_wrapper_post_cts

if {![file exists $DESIGN_LIB]} { error "No existe la biblioteca: $DESIGN_LIB" }
file mkdir "$ROOT/reports"
open_lib $DESIGN_LIB
open_block $INPUT_BLOCK
set_host_options -max_cores 4

puts "===== ROUTE_AUTO ====="
route_auto
save_block -as alu_sync_wrapper_route_initial
save_lib

puts "===== ROUTE_OPT ====="
route_opt
redirect -file "$ROOT/reports/icc2_routing_check.rpt" { check_routes }
redirect -file "$ROOT/reports/icc2_routing_legality.rpt" { check_legality }
redirect -file "$ROOT/reports/icc2_routing_pg.rpt" { check_pg_connectivity }
redirect -file "$ROOT/reports/icc2_routing_setup.rpt" { report_timing -delay_type max -max_paths 10 }
redirect -file "$ROOT/reports/icc2_routing_hold.rpt" { report_timing -delay_type min -max_paths 10 }
redirect -file "$ROOT/reports/icc2_routing_qor.rpt" { report_qor }

save_block -as alu_sync_wrapper_routed
save_lib
puts "ROUTING COMPLETADO: alu_sync_wrapper_routed"
exit
