# Clock Tree Synthesis para la ALU propia.
# Ejecutar desde ~/jose_alu: icc2_shell -f scripts/08_icc2_cts.tcl

set ROOT [file normalize [pwd]]
set DESIGN_LIB "$ROOT/icc2/ALU_Jose_GF150.nlib"
set INPUT_BLOCK alu_sync_wrapper_power_grid
set OUTPUT_BLOCK alu_sync_wrapper_cts

if {![file exists $DESIGN_LIB]} { error "No existe la biblioteca: $DESIGN_LIB" }
file mkdir "$ROOT/reports"
open_lib $DESIGN_LIB
open_block $INPUT_BLOCK
set_host_options -max_cores 4

redirect -file "$ROOT/reports/icc2_cts_clock_settings.rpt" { report_clock_settings }
clock_opt -from build_clock -to route_clock

redirect -file "$ROOT/reports/icc2_cts_clock_qor.rpt" { report_clock_qor -type summary }
redirect -file "$ROOT/reports/icc2_cts_setup.rpt" { report_timing -delay_type max -max_paths 10 }
redirect -file "$ROOT/reports/icc2_cts_hold.rpt" { report_timing -delay_type min -max_paths 10 }
redirect -file "$ROOT/reports/icc2_cts_qor.rpt" { report_qor }
redirect -file "$ROOT/reports/icc2_cts_legality.rpt" { check_legality }
redirect -file "$ROOT/reports/icc2_cts_pg.rpt" { check_pg_connectivity }

save_block -as $OUTPUT_BLOCK
save_lib
puts "CTS COMPLETADO: $OUTPUT_BLOCK"
exit
