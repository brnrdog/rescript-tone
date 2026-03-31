// Bindings for Tone.Reverb
open Types

type t

type options = {
  decay?: seconds,
  preDelay?: seconds,
  wet?: normalRange,
}

@module("tone") @new external make: unit => t = "Reverb"
@module("tone") @new external makeWithDecay: seconds => t = "Reverb"
@module("tone") @new external makeWithOptions: options => t = "Reverb"

@get external decay: t => time = "decay"
@set external setDecay: (t, time) => unit = "decay"
@get external preDelay: t => time = "preDelay"
@set external setPreDelay: (t, time) => unit = "preDelay"
@get external wet: t => Param.t = "wet"
@get external ready: t => promise<unit> = "ready"

@send external generate: t => promise<t> = "generate"
@send external dispose: t => t = "dispose"

external asAudioNode: t => AudioNode.t = "%identity"
