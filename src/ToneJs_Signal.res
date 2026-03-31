// Bindings for Tone.Signal - a schedulable signal
open ToneJs_Types

type t

type options = {
  value?: float,
  units?: string,
}

@module("tone") @new external make: unit => t = "Signal"
@module("tone") @new external makeWithValue: float => t = "Signal"
@module("tone") @new external makeWithOptions: options => t = "Signal"

@get external getValue: t => float = "value"
@set external setValue: (t, float) => unit = "value"
@get external overridden: t => bool = "overridden"
@set external setOverridden: (t, bool) => unit = "overridden"
@get external maxValue: t => float = "maxValue"
@get external minValue: t => float = "minValue"
@get external units: t => string = "units"
@get external convert: t => bool = "convert"
@set external setConvert: (t, bool) => unit = "convert"

// Scheduling methods (same as Param)
@send external setValueAtTime: (t, float, time) => t = "setValueAtTime"
@send external getValueAtTime: (t, time) => float = "getValueAtTime"
@send external linearRampToValueAtTime: (t, float, time) => t = "linearRampToValueAtTime"
@send external exponentialRampToValueAtTime: (t, float, time) => t = "exponentialRampToValueAtTime"
@send external linearRampTo: (t, float, time) => t = "linearRampTo"
@send external linearRampToFrom: (t, float, time, ~startTime: time=?) => t = "linearRampTo"
@send external exponentialRampTo: (t, float, time) => t = "exponentialRampTo"
@send external exponentialRampToFrom: (t, float, time, ~startTime: time=?) => t = "exponentialRampTo"
@send external targetRampTo: (t, float, time) => t = "targetRampTo"
@send external targetRampToFrom: (t, float, time, ~startTime: time=?) => t = "targetRampTo"
@send external rampTo: (t, float, time) => t = "rampTo"
@send external rampToFrom: (t, float, time, ~startTime: time=?) => t = "rampTo"
@send external setRampPoint: (t, time) => t = "setRampPoint"
@send external setTargetAtTime: (t, float, time, float) => t = "setTargetAtTime"
@send external cancelScheduledValues: (t, time) => t = "cancelScheduledValues"
@send external cancelAndHoldAtTime: (t, time) => t = "cancelAndHoldAtTime"

@send external connect: (t, ToneJs_AudioNode.t) => t = "connect"
@send external dispose: t => t = "dispose"

external asAudioNode: t => ToneJs_AudioNode.t = "%identity"
external asParam: t => ToneJs_Param.t = "%identity"
