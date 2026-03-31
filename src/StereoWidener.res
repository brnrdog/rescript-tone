// Bindings for Tone.StereoWidener
open Types

type t

type options = {
  width?: normalRange,
  wet?: normalRange,
}

@module("tone") @new external make: unit => t = "StereoWidener"
@module("tone") @new external makeWithOptions: options => t = "StereoWidener"

@get external width: t => Param.t = "width"
@get external wet: t => Param.t = "wet"

@send external dispose: t => t = "dispose"

external asAudioNode: t => AudioNode.t = "%identity"
