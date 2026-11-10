# Optimizacion final posterior a CTS.
# Ejecutar desde ~/jose_alu: icc2_shell -f scripts/09_icc2_post_cts.tcl

set ROOT [file normalize [pwd]]
set DESIGN_LIB "$ROOT/icc2/ALU_Jose_GF150.nlib"
set INPUT_BLOCK alu_sync_wrapper_cts
set OUTPUT_BLOCK alu_sync_wrapper_post_cts

if {![file exists $DESIGN_LIB]} { error "No existe la biblioteca: $DESIGN_LIB" }
file mkdir "$ROOT/reports"
open_lib $DESIGN_LIB
open_block $INPUT_BLOCK
set_host_options -max_cores 4

clock_opt -from final_opto
redirect -file "$ROOT/reports/icc2_post_cts_qor.rpt" { report_qor }
redirect -file "$ROOT/reports/icc2_post_cts_setup.rpt" { report_timing -delay_type max -max_paths 10 }
redirect -file "$ROOT/reports/icc2_post_cts_hold.rpt" { report_timing -delay_type min -max_paths 10 }
redirect -file "$ROOT/reports/icc2_post_cts_legality.rpt" { check_legality }
redirect -file "$ROOT/reports/icc2_post_cts_pg.rpt" { check_pg_connectivity }

save_block -as $OUTPUT_BLOCK
save_lib
puts "POST-CTS COMPLETADO: $OUTPUT_BLOCK"
exit
