# Sintesis DC de la ALU propia.
# Ejecutar desde /home/chuletax/jose_alu:
#   dc_shell -f scripts/01_sintesis_dc.tcl

set ROOT [file normalize [pwd]]
set PDK_ROOT /home/chuletax/ALU_Plus_Chuleta/pdk
set TOP alu_sync_wrapper
set LIB "$PDK_ROOT/m31/M31LLSC733GL150MS_25CTT3P3_ctyp_nldm.db"

foreach f [list $LIB \
    "$ROOT/src/adder_cla.sv" \
    "$ROOT/src/multiplier.sv" \
    "$ROOT/src/divider.sv" \
    "$ROOT/src/logic_tristate.sv" \
    "$ROOT/src/alu_top.sv" \
    "$ROOT/src/alu_sync_wrapper.sv"] {
    if {![file exists $f]} { error "Falta archivo requerido: $f" }
}

file mkdir "$ROOT/results"
file mkdir "$ROOT/reports"

set target_library $LIB
set link_library "* $target_library"

analyze -format sverilog [list \
    "$ROOT/src/adder_cla.sv" \
    "$ROOT/src/multiplier.sv" \
    "$ROOT/src/divider.sv" \
    "$ROOT/src/logic_tristate.sv" \
    "$ROOT/src/alu_top.sv" \
    "$ROOT/src/alu_sync_wrapper.sv"]
elaborate $TOP
current_design $TOP
link

create_clock -name clk -period 10.0 [get_ports clk]
set_input_delay -max 2.0 -clock clk [remove_from_collection [all_inputs] [get_ports clk]]
set_output_delay -max 2.0 -clock clk [all_outputs]

# Primero integra los submódulos RTL dentro del top.
current_design $TOP
ungroup -all -flatten
link

# Ahora optimiza y mapea el diseño ya aplanado.
compile_ultra

redirect -file "$ROOT/reports/dc_qor.rpt" { report_qor }
redirect -file "$ROOT/reports/dc_timing.rpt" { report_timing -path full -delay max -max_paths 10 }
redirect -file "$ROOT/reports/dc_area.rpt" { report_area }
redirect -file "$ROOT/reports/dc_power.rpt" { report_power }
redirect -file "$ROOT/reports/dc_constraints.rpt" { report_constraint -all_violators }

write -format verilog -hierarchy -output "$ROOT/results/alu_sintetizada.v"
write_sdc "$ROOT/results/restricciones_alu.sdc"

puts "SINTESIS COMPLETADA: $ROOT/results/alu_sintetizada.v"
exit
