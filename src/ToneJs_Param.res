// Bindings for Tone.js Param - used for automatable parameters
open ToneJs_Types

type t

@get external getValue: t => float = "value"
@set external setValue: (t, float) => unit = "value"

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
