# Código Fuente (SystemVerilog)

Esta carpeta contiene el diseño RTL (Register-Transfer Level) de la ALU parametrizada, aplicando un modelado estrictamente estructural. Los módulos están diseñados en SystemVerilog y optimizados para su síntesis en hardware físico.

## 📂 Archivos de Diseño
* **`alu_sync_wrapper.sv`**: Módulo de máxima jerarquía (Top-Level) para la síntesis. Actúa como un "envolvente" que agrega registros (Flip-Flops) a las entradas y salidas de la ALU para aislarla y permitir un análisis de timing síncrono preciso.
* **`alu_top.sv`**: El núcleo de la ALU. Instancia todos los submódulos matemáticos y lógicos, contiene el bus tri-estado y utiliza un multiplexor parametrizado para seleccionar el resultado final (bus y banderas NZCV).
* **`adder_cla.sv`**: Sumador Carry Look-Ahead (CLA). Implementado a nivel de compuertas lógicas (Generación y Propagación) para calcular acarreos en paralelo y minimizar el retardo crítico.
* **`multiplier.sv`**: Módulo multiplicador parametrizado (utilizando el operador nativo `*`) para permitir una inferencia de hardware óptima y escalable durante la síntesis.
* **`divider.sv`**: Módulo divisor para operaciones aritméticas complementarias.
* **`logic_tristate.sv`**: Búferes de alta impedancia (Tri-estado). Aísla físicamente las operaciones AND y OR del bus de datos, evitando colisiones de voltaje ("cortocircuitos" lógicos) cuando no están activas.

## 🧪 Archivos de Verificación
* **`tb_alu_sync.sv`**: Testbench del sistema. Inyecta los vectores de prueba y el reloj para verificar el correcto funcionamiento del diseño RTL en simulación antes de pasarlo al flujo de Synopsys.