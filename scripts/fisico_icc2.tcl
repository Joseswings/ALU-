# 1. Rutas de Tecnología
set BASE_PATH /home/Alax
set TECH_FILE $BASE_PATHGF-20261104T041436Z-1-001GFPDK_2026-05-13T04_12_41_469pdk-150MCU-V1.0_0.0_PlaceRoute_ICC2PlaceRouteICC2Techfiles1p5m_1tm_9k_sp_sm_OPTBgf150mcu_1p5m_1tm_9k_sp_sm_OPTB_7t_M31_ndm.tf
set NDM_LIB $BASE_PATHm31-downloads-20261104T040136Z-1-001m31-downloadsM31LLSC733GL150MS_00.03.000ndmM31_Libreria_Fisica.ndm

# 2. Inicialización del Workspace
create_workspace -technology $TECH_FILE alu_chip_workspace
set_app_options -name design.link_library -value  m31_logic_tt.db

# 3. Lectura de Datos de Design Compiler
read_verilog alu_sintetizada.v
read_sdc restricciones_alu.sdc

# 4. Etapas de Diseño Físico
initialize_floorplan -core_utilization 0.65 -core_aspect_ratio 1.0
place_opt
report_qor  reporte_icc2_qor_place.txt

clock_opt
report_timing  reporte_icc2_timing_clock.txt

route_auto
route_opt
report_qor  reporte_icc2_qor_final.txt
report_timing  reporte_icc2_timing_final.txt

# 5. Exportación GDSII
save_block -as alu_final
write_gds alu_layout.gds