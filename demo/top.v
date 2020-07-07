module top(
  input CLK_100_B3I,
  input CLK_50_B2C,
  input CLK_50_B2L,
  input CLK_50_B3C,
  input CLK_50_B3I,
  input CLK_50_B3L,

  input CPU_RESET_n,
  input [1:0] BUTTON,

  input [1:0] SW,

  output [3:0] LED,

  output FLASH_CLK,
  output [27:1] FLASH_A,
  inout [15:0] FLASH_D,
  output FLASH_CE_n,
  output FLASH_WE_n,
  output FLASH_OE_n,
  output FLASH_ADV_n,
  output FLASH_RESET_n,
  input FLASH_RDY_BSY_n,

  input DDR4A_REFCLK_p,
  input DDR4B_REFCLK_p,
  input DDR4C_REFCLK_p,
  input DDR4D_REFCLK_p,

  inout SI5340A0_I2C_SCL,
  inout SI5340A0_I2C_SDA,
  input SI5340A0_INTR,
  output SI5340A0_OE_n,
  output SI5340A0_RST_n,

  inout SI5340A1_I2C_SCL,
  inout SI5340A1_I2C_SDA,
  input SI5340A1_INTR,
  output SI5340A1_OE_n,
  output SI5340A1_RST_n,

  inout FAN_I2C_SCL,
  inout FAN_I2C_SDA,
  input FAN_ALERT_n,
  inout POWER_MONITOR_I2C_SCL,
  inout POWER_MONITOR_I2C_SDA,
  input POWER_MONITOR_ALERT_n,
  inout TEMP_I2C_SCL,
  inout TEMP_I2C_SDA,

  inout [1:0] GPIO_CLK,
  inout [3:0] GPIO_P,

  input QSFP28A_REFCLK_p,
  input QSFP28B_REFCLK_p,
  input QSFP28C_REFCLK_p,
  input QSFP28D_REFCLK_p,

  input EXP_EN,

  inout UFL_CLKIN_p,
  inout UFL_CLKIN_n
);

	wire [3:0] LED_OUT;

	assign LED = ~LED_OUT;
	
	soc u0 (
        .clk_clk                 (CLK_50_B2C),   //   input,  width = 1,                 clk.clk
        .reset_reset             (~CPU_RESET_n), //   input,  width = 1,               reset.reset
        .de10_fan_0_fan_i2c_sda  (FAN_I2C_SDA),  //   inout,  width = 1,  de10_fan_0_fan_i2c.sda
        .de10_fan_0_fan_i2c_scl  (FAN_I2C_SCL),  //   inout,  width = 1,                    .scl
        .de10_fan_0_temp_i2c_sda (TEMP_I2C_SDA), //   inout,  width = 1, de10_fan_0_temp_i2c.sda
        .de10_fan_0_temp_i2c_scl (TEMP_I2C_SCL), //   inout,  width = 1,                    .scl
        .de10_fan_0_led_led      (LED_OUT)       //  output,  width = 4,      de10_fan_0_led.led
    );
	 
	/* mkRand u1(
		.CLK(CLK_50_B2C),
	   .RST_N(~CPU_RESET_n),
		.get_bit(GPIO_P[0])
	);*/

endmodule 
