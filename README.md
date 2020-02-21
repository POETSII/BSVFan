# BSVFan

## Example use in Verilog

```
mkDE10FanControl u0(
    .CLK(CLK_50_B2C),
    .RST_N(CPU_RESET_n),
    .FAN_I2C_SDA(FAN_I2C_SDA),
    .FAN_I2C_SCL(FAN_I2C_SCL),
    .TEMP_I2C_SDA(TEMP_I2C_SDA),
    .TEMP_I2C_SCL(TEMP_I2C_SDA),
);
```
