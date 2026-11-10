# Red de potencia propia GF150/M31 1p4m OPTA.
# Ejecutar desde ~/jose_alu: icc2_shell -f scripts/07_icc2_power_grid.tcl

set ROOT [file normalize [pwd]]
set DESIGN_LIB "$ROOT/icc2/ALU_Jose_GF150.nlib"
set INPUT_BLOCK alu_sync_wrapper_power_setup
set OUTPUT_BLOCK alu_sync_wrapper_power_grid

if {![file exists $DESIGN_LIB]} { error "No existe la biblioteca: $DESIGN_LIB" }
file mkdir "$ROOT/reports"
open_lib $DESIGN_LIB
open_block $INPUT_BLOCK

create_pg_std_cell_conn_pattern PG_RAIL -layers {METAL1}
set_pg_strategy PG_RAIL_STRATEGY -core \
    -pattern {{pattern: PG_RAIL} {nets: {VCCK GNDK}}}

create_pg_mesh_pattern PG_MESH -layers {
    {{vertical_layer: METAL2} {width: 0.48} {spacing: interleaving} {pitch: 20}}
}
set_pg_strategy PG_MESH_STRATEGY -core \
    -pattern {{pattern: PG_MESH} {nets: {VCCK GNDK}}}

compile_pg -strategies {PG_MESH_STRATEGY PG_RAIL_STRATEGY}
redirect -file "$ROOT/reports/icc2_pg_connectivity.rpt" { check_pg_connectivity }
redirect -file "$ROOT/reports/icc2_pg_drc.rpt" { check_pg_drc }

save_block -as $OUTPUT_BLOCK
save_lib
puts "POWER GRID COMPLETADO: $OUTPUT_BLOCK"
exit
