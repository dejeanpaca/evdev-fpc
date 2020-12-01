{
   Adapted from: https://github.com/torvalds/linux/blob/master/include/uapi/linux/input.h
   Commit: f729a1b0f8df7091cea3729fc0e414f5326e1163
}

UNIT linux_input;

{$PackRecords C}

INTERFACE

   USES
      BaseUnix;

// #include "input-event-codes.h"

CONST
   EV_VERSION = $010001;

TYPE
   pinput_event = ^input_event;
   input_event = packed record
      time: timeval;

      {NOTE: This may not be correct}

   	typ: uint16;
   	code: uint16;
   	value: uint32;
   end;

   pinput_id = ^input_id;
   input_id = packed record
	   bustype: uint16;
	   vendor: uint16;
	   product: uint16;
	   version: uint16;
   end;

   pinput_absinfo = ^input_absinfo;
   input_absinfo = packed record
	   value,
	   minimum,
	   maximum,
	   fuzz,
	   flat,
	   resolution: uint32;
   end;

   pinput_keymap_entry = ^input_keymap_entry;
   input_keymap_entry = packed record
	   flags,
	   len: uint8;
	   index: uint32;
	   keycode: uint32;
	   scancode: array[0..31] of uint8;
   end;

   pinput_mask = ^input_mask;
   input_mask = packed record
	   typ,
	   codes_size: uint32;
	   codes_ptr: uint64;
   end;


CONST
   ID_BUS = 0;
   ID_VENDOR = 1;
   ID_PRODUCT = 2;
   ID_VERSION = 3;

   BUS_PCI = $01;
   BUS_ISAPNP = $02;
   BUS_USB = $03;
   BUS_HIL = $04;
   BUS_BLUETOOTH = $05;
   BUS_VIRTUAL = $06;

   BUS_ISA = $10;
   BUS_I8042 = $11;
   BUS_XTKBD = $12;
   BUS_RS232 = $13;
   BUS_GAMEPORT = $14;
   BUS_PARPORT = $15;
   BUS_AMIGA = $16;
   BUS_ADB = $17;
   BUS_I2C = $18;
   BUS_HOST = $19;
   BUS_GSC = $1A;
   BUS_ATARI = $1B;
   BUS_SPI = $1C;
   BUS_RMI = $1D;
   BUS_CEC = $1E;
   BUS_INTEL_ISHTP = $1F;

   (* MT_TOOL types *)

   MT_TOOL_FINGER = $00;
   MT_TOOL_PEN = $01;
   MT_TOOL_PALM = $02;
   MT_TOOL_DIAL = $0a;
   MT_TOOL_MAX	= $0f;

CONST
   FF_STATUS_STOPPED = $00;
   FF_STATUS_PLAYING = $01;
   FF_STATUS_MAX     = $01;

TYPE
   ff_replay = record
      length,
	   delay: uint16;
   end;

   ff_trigger = record
	   button,
   	interval: uint16;
   end;

   ff_envelope = record
	   attack_length,
	   attack_level,
	   fade_length,
	   fade_level: uint16;
   end;

   ff_constant_effect = record
	   level: uint16;
	   envelope: ff_envelope;
   end;

   ff_ramp_effect = record
	   start_level,
   	end_level: int16;
	   envelope: ff_envelope;
   end;

   ff_condition_effect = record
	   right_saturation,
	   left_saturation: uint16;

	   right_coeff,
	   left_coeff: int16;

	   deadband: uint16;
	   center: int16;
   end;

   ff_periodic_effect = record
	   waveform,
	   period: uint16;
	   magnitude,
	   offset: int16;
	   phase: uint16;

	   envelope: ff_envelope;

	   custom_len: uint32;
	   custom_data: pint16;
   end;

   ff_rumble_effect = record
	   strong_magnitude,
	   weak_magnitude: uint16;
   end;

CONST
   ffi_constant_effect = 0;
   ffi_ramp_effect = 1;
   ffi_periodic_effect = 2;
   ffi_condition_effect = 3;
   ffi_rumble_effect = 4;

TYPE
   ff_effect = record
   	typ: uint16;
	   id: int16;
   	direction: uint16;
	   trigger: ff_trigger;
   	replay: ff_replay;

	   case cint of
         0: (
   		   constant: ff_constant_effect;
         );
         1: (
            ramp: ff_ramp_effect;
         );
         2: (
            periodic: ff_periodic_effect;
         );
         3: (
            condition: array[0..1] of ff_condition_effect;
         );
   		4: (
            rumble: ff_rumble_effect;
         );
   end;

CONST
   FF_RUMBLE = $50;
   FF_PERIODIC = $51;
   FF_CONSTANT	= $52;
   FF_SPRING = $53;
   FF_FRICTION = $54;
   FF_DAMPER = $55;
   FF_INERTIA = $56;
   FF_RAMP = $57;

   FF_EFFECT_MIN = FF_RUMBLE;
   FF_EFFECT_MAX = FF_RAMP;

   { Force feedback periodic effect types }

   FF_SQUARE = $58;
   FF_TRIANGLE = $59;
   FF_SINE = $5a;
   FF_SAW_UP = $5b;
   FF_SAW_DOWN = $5c;
   FF_CUSTOM = $5d;

   FF_WAVEFORM_MIN = FF_SQUARE;
   FF_WAVEFORM_MAX = FF_CUSTOM;

   FF_GAIN = $60;
   FF_AUTOCENTER = $61;

   FF_MAX_EFFECTS	= FF_GAIN;

   FF_MAX = $7f;
   FF_CNT = FF_MAX + 1;

IMPLEMENTATION

END.
