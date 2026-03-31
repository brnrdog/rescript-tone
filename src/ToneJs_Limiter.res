// Bindings for Tone.Limiter
open ToneJs_Types

type t

type options = {
  threshold?: decibels,
}

@module("tone") @new external make: unit => t = "Limiter"
@module("tone") @new external makeWithThreshold: decibels => t = "Limiter"
@module("tone") @new external makeWithOptions: options => t = "Limiter"

@get external threshold: t => ToneJs_Param.t = "threshold"
@get external reduction: t => decibels = "reduction"

@send external dispose: t => t = "dispose"

external asAudioNode: t => ToneJs_AudioNode.t = "%identity"
