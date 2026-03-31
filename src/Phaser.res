// Bindings for Tone.Phaser
open Types

type t

type options = {
  frequency?: frequency,
  octaves?: positive,
  stages?: int,
  q?: positive,
  baseFrequency?: frequency,
  wet?: normalRange,
}

@module("tone") @new external make: unit => t = "Phaser"
@module("tone") @new external makeWithOptions: options => t = "Phaser"

@get external frequency: t => Param.t = "frequency"
@get external octaves: t => positive = "octaves"
@set external setOctaves: (t, positive) => unit = "octaves"
@get external q: t => Param.t = "Q"
@get external baseFrequency: t => frequency = "baseFrequency"
@set external setBaseFrequency: (t, frequency) => unit = "baseFrequency"
@get external wet: t => Param.t = "wet"

@send external dispose: t => t = "dispose"

external asAudioNode: t => AudioNode.t = "%identity"
