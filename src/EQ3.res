// Bindings for Tone.EQ3 - 3-band equalizer
open Types

type t

type options = {
  low?: decibels,
  mid?: decibels,
  high?: decibels,
  lowFrequency?: frequency,
  highFrequency?: frequency,
}

@module("tone") @new external make: unit => t = "EQ3"
@module("tone") @new external makeWithOptions: options => t = "EQ3"

@get external low: t => Param.t = "low"
@get external mid: t => Param.t = "mid"
@get external high: t => Param.t = "high"
@get external lowFrequency: t => Param.t = "lowFrequency"
@get external highFrequency: t => Param.t = "highFrequency"

@send external dispose: t => t = "dispose"

external asAudioNode: t => AudioNode.t = "%identity"
