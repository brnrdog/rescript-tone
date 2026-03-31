// Bindings for Tone.Freeverb
open ToneJs_Types

type t

type options = {
  roomSize?: normalRange,
  dampening?: frequency,
  wet?: normalRange,
}

@module("tone") @new external make: unit => t = "Freeverb"
@module("tone") @new external makeWithOptions: options => t = "Freeverb"

@get external roomSize: t => ToneJs_Param.t = "roomSize"
@get external dampening: t => ToneJs_Param.t = "dampening"
@get external wet: t => ToneJs_Param.t = "wet"

@send external dispose: t => t = "dispose"

external asAudioNode: t => ToneJs_AudioNode.t = "%identity"
