// Bindings for Tone.StereoWidener
open ToneJs_Types

type t

type options = {
  width?: normalRange,
  wet?: normalRange,
}

@module("tone") @new external make: unit => t = "StereoWidener"
@module("tone") @new external makeWithOptions: options => t = "StereoWidener"

@get external width: t => ToneJs_Param.t = "width"
@get external wet: t => ToneJs_Param.t = "wet"

@send external dispose: t => t = "dispose"

external asAudioNode: t => ToneJs_AudioNode.t = "%identity"
