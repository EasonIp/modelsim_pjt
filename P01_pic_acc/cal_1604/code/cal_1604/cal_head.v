

///////////////////数据多路器/////////////////
`define DMUX_MEM 2'b00
`define DMUX_CPU 2'b01
`define DMUX_ACC 2'b10

//////////////////地址多路器//////////////////
`define AMUX_CPU 1'b0
`define AMUX_ACC 1'b1

//////////////////控制多路器//////////////////
`define WMUX_CPU 1'b0
`define WMUX_ACC 1'b1

/////////////////仲裁器//////////////////////
`define ARB_CPU 1'b0
`define ARB_ACC 1'b1

/////////////////加速器地址//////////////////
`define ASSH 16'h8000
`define ASSL 16'h8001

`define ASTH 16'h8010
`define ASTL 16'h8011

`define S_REG 16'h8020

////////////////ACC地址范围////////////////////////`
`define ACC_MASK 16'hffc0
`define ACC_BASE 16'h8000

/////////////////验证地址//////////////////////////、
`define TARGET_ADDR 16'h0110
`define TARGET_H 8'h01
`define TARGET_L 8'h10

`define SOURCE_ADDR 16'h0100
`define SOURCE_H 8'b01
`define SOURCE_L 8'b00

