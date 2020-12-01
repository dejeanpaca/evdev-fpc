(*
 * Copyright © 2013 Red Hat, Inc.
 *
 * Permission to use, copy, modify, distribute, and sell this software and its
 * documentation for any purpose is hereby granted without fee, provided that
 * the above copyright notice appear in all copies and that both that copyright
 * notice and this permission notice appear in supporting documentation, and
 * that the name of the copyright holders not be used in advertising or
 * publicity pertaining to distribution of the software without specific,
 * written prior permission.  The copyright holders make no representations
 * about the suitability of this software for any purpose.  It is provided "as
 * is" without express or implied warranty.
 *
 * THE COPYRIGHT HOLDERS DISCLAIM ALL WARRANTIES WITH REGARD TO THIS SOFTWARE,
 * INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS, IN NO
 * EVENT SHALL THE COPYRIGHT HOLDERS BE LIABLE FOR ANY SPECIAL, INDIRECT OR
 * CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE,
 * DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER
 * TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE
 * OF THIS SOFTWARE.
 *)

{
   Adapted from https://gitlab.freedesktop.org/libevdev/libevdev/-/blob/master/libevdev/
   Commit: 4226c7801b4ea1b0c7d1eaac47ca24ece8f24809
}

UNIT libevdev;

INTERFACE

   USES
      BaseUnix, linux_input;

CONST
   evdevlibname = 'libevdev.so.2';

TYPE
   Plibevdev = ^Tlibevdev;
   Tlibevdev = packed record
   end;

   libevdev_read_flag = (
	   LIBEVDEV_READ_FLAG_SYNC = 1, {Process data in sync mode}
	   LIBEVDEV_READ_FLAG_NORMAL	= 2, {Process data in normal mode}
	   LIBEVDEV_READ_FLAG_FORCE_SYNC	= 4, {Pretend the next event is a SYN_DROPPED and
					             require the caller to sync}
	   LIBEVDEV_READ_FLAG_BLOCKING	= 8  {The fd is not in O_NONBLOCK and a read may block}
   );

   libevdev_log_priority  = (
   	LIBEVDEV_LOG_ERROR = 10, {critical errors and application bugs}
   	LIBEVDEV_LOG_INFO  = 20, {informational messages}
   	LIBEVDEV_LOG_DEBUG = 30	{debug information}
   );

   libevdev_log_func_t = procedure(priority: libevdev_log_priority;
      data: Pointer;
      f: pchar; line: cint;
      func: pchar;
      format: pchar; var args {va_list}); cdecl;

   libevdev_device_log_func_t = procedure(dev: Plibevdev; priority: libevdev_log_priority;
      data: pointer;
      f: pchar; line: cint;
      func: pchar;
      format: pchar; var args {va_list}); cdecl;

   libevdev_grab_mode = (
   	LIBEVDEV_MODE_GRAB = 3, {Grab the device if not currently grabbed}
   	LIBEVDEV_MODE_UNGRAB = 4{Ungrab the device if currently grabbed}
   );

   libevdev_read_status = (
   	LIBEVDEV_READ_STATUS_SUCCESS = 0,
   	LIBEVDEV_READ_STATUS_SYNC = 1
   );

   libevdev_led_value = (
   	LIBEVDEV_LED_ON = 3, {Turn the LED on}
   	LIBEVDEV_LED_OFF = 4 {Turn the LED off}
   );

function libevdev_new(): plibevdev; cdecl; external {$IFDEF DYNLINK}evdevlibname{$ENDIF};
function libevdev_new_from_fd(fd: cint; var dev: plibevdev): cint; cdecl; external {$IFDEF DYNLINK}evdevlibname{$ENDIF};
procedure libevdev_free(dev: plibevdev); cdecl; external {$IFDEF DYNLINK}evdevlibname{$ENDIF};

procedure libevdev_set_log_function(logfunc: libevdev_log_func_t; data: pointer); cdecl; external {$IFDEF DYNLINK}evdevlibname{$ENDIF};
procedure libevdev_set_log_priority(priority: libevdev_log_priority); cdecl; external {$IFDEF DYNLINK}evdevlibname{$ENDIF};
function libevdev_get_log_priority(): libevdev_log_priority; cdecl; external {$IFDEF DYNLINK}evdevlibname{$ENDIF};

procedure libevdev_set_device_log_function(dev: Plibevdev;
				      logfunc: libevdev_device_log_func_t; priority: libevdev_log_priority;
				      data: pointer); cdecl; external {$IFDEF DYNLINK}evdevlibname{$ENDIF};

function libevdev_grab(dev: Plibevdev; grab: libevdev_grab_mode): cint; cdecl; external {$IFDEF DYNLINK}evdevlibname{$ENDIF};
function libevdev_set_fd(dev: Plibevdev; fd: cint): cint; cdecl; external {$IFDEF DYNLINK}evdevlibname{$ENDIF};
function libevdev_change_fd(dev: Plibevdev; fd: cint): cint; cdecl; external {$IFDEF DYNLINK}evdevlibname{$ENDIF};

function libevdev_get_fd(dev: Plibevdev): cint; cdecl; external {$IFDEF DYNLINK}evdevlibname{$ENDIF};

function libevdev_next_event(dev: PLibevdev; flags: cuint; ev: pinput_event): cint; cdecl; external {$IFDEF DYNLINK}evdevlibname{$ENDIF};
function libevdev_has_event_pending(dev: PLibevdev): cint; cdecl; external {$IFDEF DYNLINK}evdevlibname{$ENDIF};

function libevdev_get_name(dev: Plibevdev): pchar; cdecl; external {$IFDEF DYNLINK}evdevlibname{$ENDIF};
procedure libevdev_set_name(dev: Plibevdev; name: pchar); cdecl; external {$IFDEF DYNLINK}evdevlibname{$ENDIF};
function libevdev_get_phys(dev: Plibevdev): pchar; cdecl; external {$IFDEF DYNLINK}evdevlibname{$ENDIF};
procedure libevdev_set_phys(dev: Plibevdev; phys: pchar); cdecl; external {$IFDEF DYNLINK}evdevlibname{$ENDIF};
function libevdev_get_uniq(dev: Plibevdev): pchar; cdecl; external {$IFDEF DYNLINK}evdevlibname{$ENDIF};
procedure libevdev_set_uniq(dev: Plibevdev; uniq: pchar); cdecl; external {$IFDEF DYNLINK}evdevlibname{$ENDIF};
function libevdev_get_id_product(dev: Plibevdev): cint; cdecl; external {$IFDEF DYNLINK}evdevlibname{$ENDIF};
procedure libevdev_set_id_product(dev: Plibevdev; product_id: cint); cdecl; external {$IFDEF DYNLINK}evdevlibname{$ENDIF};
function libevdev_get_id_vendor(dev: Plibevdev): cint; cdecl; external {$IFDEF DYNLINK}evdevlibname{$ENDIF};
procedure libevdev_set_id_vendor(dev: Plibevdev; vendor_id: cint); cdecl; external {$IFDEF DYNLINK}evdevlibname{$ENDIF};
function libevdev_get_id_bustype(dev: Plibevdev): cint; cdecl; external {$IFDEF DYNLINK}evdevlibname{$ENDIF};
procedure libevdev_set_id_bustype(dev: Plibevdev; bustype: cint); cdecl; external {$IFDEF DYNLINK}evdevlibname{$ENDIF};
function libevdev_get_id_version(dev: Plibevdev): cint; cdecl; external {$IFDEF DYNLINK}evdevlibname{$ENDIF};
procedure libevdev_set_id_version(dev: Plibevdev; version: cint); cdecl; external {$IFDEF DYNLINK}evdevlibname{$ENDIF};
function libevdev_get_driver_version(dev: Plibevdev): cint; cdecl; external {$IFDEF DYNLINK}evdevlibname{$ENDIF};
function libevdev_has_property(dev: Plibevdev; prop: cint): cint; cdecl; external {$IFDEF DYNLINK}evdevlibname{$ENDIF};
function libevdev_enable_property(dev: Plibevdev; prop: cint): cint; cdecl; external {$IFDEF DYNLINK}evdevlibname{$ENDIF};
function libevdev_has_event_type(dev: Plibevdev; typ: cuint): cint; cdecl; external {$IFDEF DYNLINK}evdevlibname{$ENDIF};
function libevdev_has_event_code(dev: Plibevdev; typ: cuint; code: cuint): cint; cdecl; external {$IFDEF DYNLINK}evdevlibname{$ENDIF};
function libevdev_get_abs_minimum(dev: Plibevdev; code: cuint): cint; cdecl; external {$IFDEF DYNLINK}evdevlibname{$ENDIF};
function libevdev_get_abs_maximum(dev: Plibevdev; code: cuint): cint; cdecl; external {$IFDEF DYNLINK}evdevlibname{$ENDIF};
function libevdev_get_abs_fuzz(dev: Plibevdev; code: cuint): cint; cdecl; external {$IFDEF DYNLINK}evdevlibname{$ENDIF};
function libevdev_get_abs_flat(dev: Plibevdev; code: cuint): cint; cdecl; external {$IFDEF DYNLINK}evdevlibname{$ENDIF};
function libevdev_get_abs_resolution(dev: Plibevdev; code: cuint): cint; cdecl; external {$IFDEF DYNLINK}evdevlibname{$ENDIF};
function libevdev_get_abs_info(dev: Plibevdev; code: cuint): pinput_absinfo; cdecl; external {$IFDEF DYNLINK}evdevlibname{$ENDIF};

function libevdev_get_event_value(dev: Plibevdev; typ: cuint; code: cuint): cint; cdecl; external {$IFDEF DYNLINK}evdevlibname{$ENDIF};
function libevdev_set_event_value(dev: Plibevdev; typ: cuint; code: cuint; value: cint): cint; cdecl; external {$IFDEF DYNLINK}evdevlibname{$ENDIF};
function libevdev_fetch_event_value(dev: Plibevdev; typ: cuint; code: cuint; value: pcint): cint; cdecl; external {$IFDEF DYNLINK}evdevlibname{$ENDIF};
function libevdev_get_slot_value(dev: Plibevdev; slot: cuint; code: cuint): cint; cdecl; external {$IFDEF DYNLINK}evdevlibname{$ENDIF};
function libevdev_set_slot_value(dev: Plibevdev; slot: cuint; code: cuint; value: cint): cint; cdecl; external {$IFDEF DYNLINK}evdevlibname{$ENDIF};
function libevdev_fetch_slot_value(dev: Plibevdev; slot: cuint; code: cuint; value: pcint): cint; cdecl; external {$IFDEF DYNLINK}evdevlibname{$ENDIF};
function libevdev_get_num_slots(dev: Plibevdev): cint; cdecl; external {$IFDEF DYNLINK}evdevlibname{$ENDIF};
function libevdev_get_current_slot(dev: Plibevdev): cint; cdecl; external {$IFDEF DYNLINK}evdevlibname{$ENDIF};

procedure libevdev_set_abs_minimum(dev: Plibevdev; code: cuint; min: cint); cdecl; external {$IFDEF DYNLINK}evdevlibname{$ENDIF};
procedure libevdev_set_abs_maximum(dev: Plibevdev; code: cuint; max: cint); cdecl; external {$IFDEF DYNLINK}evdevlibname{$ENDIF};
procedure libevdev_set_abs_fuzz(dev: Plibevdev; code: cuint; fuzz: cint); cdecl; external {$IFDEF DYNLINK}evdevlibname{$ENDIF};
procedure libevdev_set_abs_flat(dev: Plibevdev; code: cuint; flat: cint); cdecl; external {$IFDEF DYNLINK}evdevlibname{$ENDIF};
procedure libevdev_set_abs_resolution(dev: Plibevdev; code: cuint; resolution: cint); cdecl; external {$IFDEF DYNLINK}evdevlibname{$ENDIF};
procedure libevdev_set_abs_info(dev: Plibevdev; code: cuint; abs: pinput_absinfo); cdecl; external {$IFDEF DYNLINK}evdevlibname{$ENDIF};

function libevdev_enable_event_type(dev: Plibevdev; typ: cuint): cint; cdecl; external {$IFDEF DYNLINK}evdevlibname{$ENDIF};
function libevdev_disable_event_type(dev: Plibevdev; typ: cuint): cint; cdecl; external {$IFDEF DYNLINK}evdevlibname{$ENDIF};
function libevdev_disable_event_code(dev: Plibevdev; typ: cuint; code: cuint): cint; cdecl; external {$IFDEF DYNLINK}evdevlibname{$ENDIF};
function libevdev_enable_event_code(dev: Plibevdev; typ: cuint; code: cuint; data: pointer): cint; cdecl; external {$IFDEF DYNLINK}evdevlibname{$ENDIF};
function libevdev_kernel_set_abs_info(dev: Plibevdev; code: cuint; abs: pinput_absinfo): cint; cdecl; external {$IFDEF DYNLINK}evdevlibname{$ENDIF};

function libevdev_kernel_set_led_value(dev: Plibevdev; code: cuint; value: libevdev_led_value): cint; cdecl; external {$IFDEF DYNLINK}evdevlibname{$ENDIF};
function libevdev_kernel_set_led_values(dev: Plibevdev {, TODO: Convert C ... argument}): cint; cdecl; external {$IFDEF DYNLINK}evdevlibname{$ENDIF};

function libevdev_set_clock_id(dev: Plibevdev; clockid: cint): cint; cdecl; external {$IFDEF DYNLINK}evdevlibname{$ENDIF};
function libevdev_event_is_type(ev: pinput_event; typ: cuint): cint; cdecl; external {$IFDEF DYNLINK}evdevlibname{$ENDIF};

function libevdev_event_is_code(ev: pinput_event; typ: cuint; code: cuint): cint; cdecl; external {$IFDEF DYNLINK}evdevlibname{$ENDIF};
function libevdev_event_code_get_name(typ: cuint; code: cuint): pchar; cdecl; external {$IFDEF DYNLINK}evdevlibname{$ENDIF};
function libevdev_property_get_name(prop: cuint): pchar; cdecl; external {$IFDEF DYNLINK}evdevlibname{$ENDIF};
function libevdev_event_type_get_max(typ: cuint): cint; cdecl; external {$IFDEF DYNLINK}evdevlibname{$ENDIF};
function libevdev_event_type_from_name(name: pchar): cint; cdecl; external {$IFDEF DYNLINK}evdevlibname{$ENDIF};
function libevdev_event_type_from_name_n(name: pchar; len: size_t): cint; cdecl; external {$IFDEF DYNLINK}evdevlibname{$ENDIF};
function libevdev_event_code_from_name(typ: cuint; name: pchar): cint; cdecl; external {$IFDEF DYNLINK}evdevlibname{$ENDIF};
function libevdev_event_code_from_name_n(typ: cuint; name: pchar; len: size_t): cint; cdecl; external {$IFDEF DYNLINK}evdevlibname{$ENDIF};

function libevdev_property_from_name(name: pchar): cint; cdecl; external {$IFDEF DYNLINK}evdevlibname{$ENDIF};
function libevdev_property_from_name_n(name: pchar; len: size_t): cint; cdecl; external {$IFDEF DYNLINK}evdevlibname{$ENDIF};

function libevdev_get_repeat(dev: Plibevdev; delay: pcint; period: pcint): cint; cdecl; external {$IFDEF DYNLINK}evdevlibname{$ENDIF};

IMPLEMENTATION

END.
