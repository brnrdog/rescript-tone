// Bindings for Tone.Gate - noise gate
open ToneJs_Types

type t

type options = {
  threshold?: decibels,
  smoothing?: time,
}

@module("tone") @new external make: unit => t = "Gate"
@module("tone") @new external makeWithThreshold: decibels => t = "Gate"
@module("tone") @new external makeWithOptions: options => t = "Gate"

@get external threshold: t => ToneJs_Param.t = "threshold"
@get external smoothing: t => time = "smoothing"
@set external setSmoothing: (t, time) => unit = "smoothing"

@send external dispose: t => t = "dispose"

external asAudioNode: t => ToneJs_AudioNode.t = "%identity"
