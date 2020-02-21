package Fan;

import I2C::*;
import I2CUtil::*;
import StmtFSM::*;

interface Fan;
    interface I2C_Pins i2c;

    method Stmt init(FanMode mode, FanScaler scaler);
    method Action set_speed(Bit#(8) kTach);
endinterface

typedef enum {
    FullOn = 2'b00,
    FullOff = 2'b01,
    ClosedLoop = 2'b10,
    OpenLoop = 2'b11
} FanMode deriving (Eq, Bits);

typedef enum {
    Div1 = 3'b000,
    Div2 = 3'b001,
    Div4 = 3'b010,
    Div8 = 3'b011,
    Div16 = 3'b100
} FanScaler deriving (Eq, Bits);

module mkFan #(parameter Bit#(7) slave_addr) (Fan);
    I2C fan <- mkI2C(125);
    
    method Stmt init(FanMode mode, FanScaler scaler);
        Bit#(8) cfgr = {2'b00,
                        pack(mode), // Operating Mode
                        1'b1, // 12V Fan
                        pack(scaler) // Prescaler Value
                        };
        return seq
            i2c_write_byte(fan, slave_addr, 8'h00, 8'h80);
            i2c_write_byte(fan, slave_addr, 8'h02, cfgr);
            i2c_write_byte(fan, slave_addr, 8'h04, 8'hf5);
            i2c_write_byte(fan, slave_addr, 8'h08, 8'h0f);
            i2c_write_byte(fan, slave_addr, 8'h16, 8'h02);
        endseq;
    endmethod: init
    
    method Action set_speed(Bit#(8) kTach) =
        i2c_write_byte(fan, slave_addr, 8'h00, kTach);

    interface I2C_Pins i2c = fan.i2c;
endmodule: mkFan
endpackage: Fan
