// Bindings for Tone.Limiter
open Types

type t

type options = {
  threshold?: decibels,
}

@module("tone") @new external make: unit => t = "Limiter"
@module("tone") @new external makeWithThreshold: decibels => t = "Limiter"
@module("tone") @new external makeWithOptions: options => t = "Limiter"

@get external threshold: t => Param.t = "threshold"
@get external reduction: t => decibels = "reduction"

@send external dispose: t => t = "dispose"

external asAudioNode: t => AudioNode.t = "%identity"
