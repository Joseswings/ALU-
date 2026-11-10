# Crea una biblioteca NDM propia a partir del PDK autorizado de lectura.
# Ejecutar desde /home/chuletax/jose_alu:
#   icc2_lm_shell -f scripts/02_create_ndm.tcl

set ROOT [file normalize [pwd]]
set PDK_ROOT /home/chuletax/ALU_Plus_Chuleta/pdk
set TECH "$PDK_ROOT/gf150/extracted/PlaceRoute/ICC2/Techfiles/1p4m_1tm_11k_sp_sm_OPTA/gf150mcu_1p4m_1tm_11k_sp_sm_OPTA_7t_M31_ndm.tf"
set LIB "$PDK_ROOT/m31/M31LLSC733GL150MS_25CTT3P3_ctyp_nldm.db"
set LEF "$PDK_ROOT/m31/extracted/M31LLSC733GL150MS.00.03.000/lef/M31LLSC733GL150MS.lef"
set OUT "$ROOT/ndm/M31LLSC733_GF150_1p4m.ndm"

foreach f [list $TECH $LIB $LEF] {
    if {![file exists $f]} { error "Falta archivo requerido: $f" }
}
if {[file exists $OUT]} {
    error "Ya existe $OUT. No se sobrescribira. Eliminalo manualmente solo si deseas regenerarlo."
}

file mkdir "$ROOT/ndm"
create_workspace -technology $TECH -flow normal M31LLSC733_GF150_1p4m
read_db $LIB
read_lef $LEF
check_workspace
commit_workspace -output $OUT
puts "NDM CREADA: $OUT"
exit
