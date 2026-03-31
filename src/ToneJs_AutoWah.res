// Bindings for Tone.AutoWah
open ToneJs_Types

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

@get external gain: t => ToneJs_Param.t = "gain"
@get external q: t => ToneJs_Param.t = "Q"
@get external wet: t => ToneJs_Param.t = "wet"
@get external octaves: t => positive = "octaves"
@set external setOctaves: (t, positive) => unit = "octaves"
@get external baseFrequency: t => frequency = "baseFrequency"
@set external setBaseFrequency: (t, frequency) => unit = "baseFrequency"
@get external sensitivity: t => decibels = "sensitivity"
@set external setSensitivity: (t, decibels) => unit = "sensitivity"

@send external dispose: t => t = "dispose"

external asAudioNode: t => ToneJs_AudioNode.t = "%identity"
