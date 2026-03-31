// Bindings for Tone.JCReverb
open ToneJs_Types

type t

type options = {
  roomSize?: normalRange,
  wet?: normalRange,
}

@module("tone") @new external make: unit => t = "JCReverb"
@module("tone") @new external makeWithOptions: options => t = "JCReverb"

@get external roomSize: t => ToneJs_Param.t = "roomSize"
@get external wet: t => ToneJs_Param.t = "wet"

@send external dispose: t => t = "dispose"

external asAudioNode: t => ToneJs_AudioNode.t = "%identity"
