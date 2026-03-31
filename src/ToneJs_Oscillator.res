// Bindings for Tone.Oscillator
open ToneJs_Types

type t

type options = {
  frequency?: frequency,
  \"type"?: oscillatorType,
  detune?: cents,
  phase?: degrees,
  volume?: decibels,
}

@module("tone") @new external make: unit => t = "Oscillator"
@module("tone") @new external makeWithOptions: options => t = "Oscillator"
@module("tone") @new external makeWithFreq: (frequency, oscillatorType) => t = "Oscillator"

// Source lifecycle
@send external start: (t, ~time: time=?) => t = "start"
@send external stop: (t, ~time: time=?) => t = "stop"
@send external restart: (t, ~time: time=?) => t = "restart"
@send external dispose: t => t = "dispose"

// Properties
@get external frequency: t => ToneJs_Param.t = "frequency"
@get external detune: t => ToneJs_Param.t = "detune"
@get external volume: t => ToneJs_Param.t = "volume"

@get external getType: t => oscillatorType = "type"
@set external setType: (t, oscillatorType) => unit = "type"
@get external phase: t => degrees = "phase"
@set external setPhase: (t, degrees) => unit = "phase"
@get external partialCount: t => int = "partialCount"
@set external setPartialCount: (t, int) => unit = "partialCount"
@get external partials: t => array<float> = "partials"
@set external setPartials: (t, array<float>) => unit = "partials"

// Sync
@send external syncFrequency: t => t = "syncFrequency"
@send external unsyncFrequency: t => t = "unsyncFrequency"
@send external sync: t => t = "sync"
@send external unsync: t => t = "unsync"

external asAudioNode: t => ToneJs_AudioNode.t = "%identity"
