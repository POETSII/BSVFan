package Temp;

import I2C::*;
import I2CUtil::*;
import StmtFSM::*;

interface Temp;
    interface I2C_Pins i2c;

    method Stmt init();
    
    method Stmt read_val(Reg#(Bit#(8)) result);
endinterface

module mkTemp #(parameter Bit#(7) slave_addr) (Temp);
    I2C temp <- mkI2C(125);
    
    method Stmt init() = seq
            i2c_write_byte(temp, slave_addr, 8'h0A, 8'b00010100);
        endseq;

    method Stmt read_val(Reg#(Bit#(8)) result);
        seq
            i2c_read_byte(temp, slave_addr, 8'h01);
            action
                let data <- i2c_get_byte(temp);
                result <= data;
            endaction
        endseq;
    endmethod
    
    interface I2C_Pins i2c = temp.i2c;
endmodule: mkTemp
endpackage: Temp
