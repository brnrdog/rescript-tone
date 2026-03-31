// Bindings for Tone.AutoWah
open Types

type t

type options = {
  baseFrequency?: frequency,
  octaves?: positive,
  sensitivity?: decibels,
  q?: positive,
  gain?: float,
  follower?: float,
  wet?: normalRange,
}

@module("tone") @new external make: unit => t = "AutoWah"
@module("tone") @new external makeWithOptions: options => t = "AutoWah"

@get external gain: t => Param.t = "gain"
@get external q: t => Param.t = "Q"
@get external wet: t => Param.t = "wet"
@get external octaves: t => positive = "octaves"
@set external setOctaves: (t, positive) => unit = "octaves"
@get external baseFrequency: t => frequency = "baseFrequency"
@set external setBaseFrequency: (t, frequency) => unit = "baseFrequency"
@get external sensitivity: t => decibels = "sensitivity"
@set external setSensitivity: (t, decibels) => unit = "sensitivity"

@send external dispose: t => t = "dispose"

external asAudioNode: t => AudioNode.t = "%identity"
