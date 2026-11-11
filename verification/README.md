# Verificación funcional con VCS y visualización en Verdi

El testbench `../src/tb_alu_sync.sv` valida cuatro operaciones del wrapper síncrono de 16 bits. Cada estímulo se aplica en un flanco negativo, se esperan dos flancos positivos por la latencia de los registros y se compara el resultado mediante `!==`; un fallo ejecuta `$fatal`.

| Operación | Entradas | Esperado |
|---|---:|---:|
| Suma (`010`) | 50 + 25 | 75 (`16'h004b`) |
| Multiplicación (`100`) | 10 × 5 | 50 (`16'h0032`) |
| Cociente (`101`) | 100 / 3 | 33 (`16'h0021`) |
| Residuo (`110`) | 100 % 3 | 1 (`16'h0001`) |

Los logs `vcs_functional_compile.log` y `vcs_functional_run.log` documentan la corrida con comprobaciones. Se usó VCS X-2025.06-SP2-6. El log de ejecución informa cuatro PASS (suma, multiplicación, cociente y residuo) y termina en `$finish` a 106 ns. También se conservaron `vcs_initial_compile.log` y `vcs_initial_run.log` como registro de la corrida preliminar. La forma de onda VCD se convirtió a FSDB y se visualizó en Verdi Y-2026.03-SP2.

Capturas: [`verdi_waveform_overview.png`](../docs/images/simulation/verdi_waveform_overview.png) y [`verdi_waveform_detail.png`](../docs/images/simulation/verdi_waveform_detail.png). En las ondas, valores como `4b`, `32`, `21`, `1` son hexadecimales y corresponden a los resultados decimales 75, 50, 33 y 1.

Esta verificación cubre esos cuatro vectores y la latencia usada por el testbench; no es exhaustiva y no comprueba todas las banderas NZCV ni todos los códigos/valores. No se versionan los binarios `simv`, VCD ni FSDB; los logs, RTL y capturas son la evidencia liviana.
