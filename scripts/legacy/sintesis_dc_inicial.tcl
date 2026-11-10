# 1. Configuración de Librerías y Rutas
set BASE_PATH "/home/Alax"
set target_library "$BASE_PATH/m31-downloads-20261104T040136Z-1-001/m31-downloads/M31LLSC733GL150MS_00.03.000/nldm_db/M31LLSC733GL150MS_25CTT3P3_ctyp_nldm.db"
set link_library "* $target_library"

# 2. Lectura de Archivos RTL
analyze -format sverilog {adder_cla.sv multiplier.sv divider.sv logic_tristate.sv alu_top.sv alu_sync_wrapper.sv tb_alu_sync.sv}
elaborate alu_sync_wrapper
current_design alu_sync_wrapper
link

# 3. Restricciones SDC (100MHz de frecuencia objetivo)
create_clock -name "clk" -period 10.0 [get_ports clk]
set_input_delay -max 2.0 -clock clk [remove_from_collection [all_inputs] [get_ports clk]]
set_output_delay -max 2.0 -clock clk [all_outputs]

# 4. Compilación y Optimización
compile_ultra

# 5. Generación de Reportes
report_qor > reporte_dc_qor.txt
report_timing > reporte_dc_timing.txt
report_area > reporte_dc_area.txt
report_power > reporte_dc_power.txt
report_constraint -all_violators > reporte_dc_violators.txt

# 6. Exportar base para ICC2
write -format verilog -hierarchy -output alu_sintetizada.v
write_sdc restricciones_alu.sdc