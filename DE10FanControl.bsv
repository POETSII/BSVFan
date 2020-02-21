package DE10FanControl;

import Fan::*;
import Temp::*;
import I2C::*;
import StmtFSM::*;
import Clocks::*;

interface FanControlIfc;
    (* prefix = "FAN_I2C" *)
    interface I2C_Pins fan_i2c;

    (* prefix = "TEMP_I2C" *)
    interface I2C_Pins temp_i2c;

    (* always_enabled, always_ready *)
    method Bit#(4) leds ();

    (* always_enabled, always_ready *)
    method Bit#(8) get_temp ();

    (* always_enabled, always_ready *)
    method Bit#(8) target_speed ();

    interface Reset inner_rst;
endinterface

(* synthesize *)
module mkDE10FanControl(FanControlIfc);
    Clock clk <- exposeCurrentClock;
    MakeResetIfc r <- mkReset(1, True, clk);

    FanControlInnerIfc inner <- mkDE10FanInner(reset_by r.new_rst);

    interface I2C_Pins fan_i2c = inner.fan_i2c;
    interface I2C_Pins temp_i2c = inner.temp_i2c;
    method Bit#(4) leds() = inner.leds;
    method Bit#(8) get_temp() = inner.get_temp;
    method Bit#(8) target_speed() = inner.target_speed();
    interface Reset inner_rst = r.new_rst;
endmodule


interface FanControlInnerIfc;
    (* prefix = "FAN_I2C" *)
    interface I2C_Pins fan_i2c;

    (* prefix = "TEMP_I2C" *)
    interface I2C_Pins temp_i2c;

    (* always_enabled, always_ready *)
    method Bit#(4) leds ();

    (* always_enabled, always_ready *)
    method Bit#(8) get_temp ();

    (* always_enabled, always_ready *)
    method Bit#(8) target_speed ();
endinterface


module mkDE10FanInner (FanControlInnerIfc);
    Reg#(Bit#(4)) led <- mkReg(4'hF);
    Reg#(Bit#(8)) cur_temp <- mkReg(0);
    Reg#(Bit#(8)) last_temp <- mkReg(0);
    Reg#(Bit#(8)) tSpeed <- mkReg(35);

    Bit#(8) target_ktach = truncate((12'd992 * 4) / extend(tSpeed)) - 1;

    Reg#(Bit#(32)) cnt <- mkReg(100000000);

    Fan fan <- mkFan(7'b1001000);
    Temp temp <- mkTemp(7'b0011100);

    PulseWire pw <- mkPulseWire;

    (* fire_when_enabled, no_implicit_conditions *)
    rule counter (cnt > 0);
        cnt <= cnt-1;
    endrule

    (* fire_when_enabled, no_implicit_conditions *)
    rule counter_rst (cnt == 0 && pw);
        cnt <= 250000000;
    endrule

    Stmt test =
    seq
        led <= 0;
        await(cnt == 0);
        led <= 1;
        fan.init(ClosedLoop, Div4);
        temp.init();
        fan.set_speed(target_ktach);
        led <= 2;
        while(True) seq
            led <= 4;
            last_temp <= cur_temp;
            temp.read_val(cur_temp);
            if( cur_temp < 40 && cur_temp <= last_temp) seq
                if( tSpeed > 35 ) seq
                    tSpeed <= tSpeed - 5;
                    fan.set_speed(target_ktach);
                endseq
            endseq
            if( cur_temp > 40 && cur_temp >= last_temp) seq
                if( tSpeed < 100 ) seq
                    tSpeed <= tSpeed + 5;
                    fan.set_speed(target_ktach);
                endseq
            endseq
            pw.send();
            led <= 8;
            await(cnt == 0);
        endseq
    endseq;

    FSM main <- mkFSM( test );

    rule run_main;
        main.start();
    endrule

    interface I2C_Pins fan_i2c = fan.i2c;

    interface I2C_Pins temp_i2c = temp.i2c;

    method Bit#(4) leds();
        return led;
    endmethod

    method Bit#(8) get_temp();
        return cur_temp;
    endmethod

    method Bit#(8) target_speed();
        return tSpeed;
    endmethod

endmodule

endpackage: DE10FanControl
