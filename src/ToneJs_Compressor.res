// Bindings for Tone.Compressor
open ToneJs_Types

type t

type options = {
  threshold?: decibels,
  ratio?: positive,
  attack?: time,
  release?: time,
  knee?: decibels,
}

@module("tone") @new external make: unit => t = "Compressor"
@module("tone") @new external makeWithThreshold: decibels => t = "Compressor"
@module("tone") @new external makeWithThresholdRatio: (decibels, positive) => t = "Compressor"
@module("tone") @new external makeWithOptions: options => t = "Compressor"

@get external threshold: t => ToneJs_Param.t = "threshold"
@get external ratio: t => ToneJs_Param.t = "ratio"
@get external attack: t => ToneJs_Param.t = "attack"
@get external release: t => ToneJs_Param.t = "release"
@get external knee: t => ToneJs_Param.t = "knee"
@get external reduction: t => decibels = "reduction"

@send external dispose: t => t = "dispose"

external asAudioNode: t => ToneJs_AudioNode.t = "%identity"
