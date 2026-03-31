// Bindings for Tone.JCReverb
open Types

type t

type options = {
  roomSize?: normalRange,
  wet?: normalRange,
}

@module("tone") @new external make: unit => t = "JCReverb"
@module("tone") @new external makeWithOptions: options => t = "JCReverb"

@get external roomSize: t => Param.t = "roomSize"
@get external wet: t => Param.t = "wet"

@send external dispose: t => t = "dispose"

external asAudioNode: t => AudioNode.t = "%identity"
