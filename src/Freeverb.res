// Bindings for Tone.Freeverb
open Types

type t

type options = {
  roomSize?: normalRange,
  dampening?: frequency,
  wet?: normalRange,
}

@module("tone") @new external make: unit => t = "Freeverb"
@module("tone") @new external makeWithOptions: options => t = "Freeverb"

@get external roomSize: t => Param.t = "roomSize"
@get external dampening: t => Param.t = "dampening"
@get external wet: t => Param.t = "wet"

@send external dispose: t => t = "dispose"

external asAudioNode: t => AudioNode.t = "%identity"
