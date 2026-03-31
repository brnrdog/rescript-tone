// Bindings for Tone.Gain
open Types

type t

type options = {
  gain?: gainFactor,
  units?: string,
}

@module("tone") @new external make: unit => t = "Gain"
@module("tone") @new external makeWithGain: gainFactor => t = "Gain"
@module("tone") @new external makeWithOptions: options => t = "Gain"

@get external gain: t => Param.t = "gain"

@send external dispose: t => t = "dispose"

external asAudioNode: t => AudioNode.t = "%identity"
