// Bindings for Tone.BitCrusher
open Types

type t

type options = {
  bits?: positive,
  wet?: normalRange,
}

@module("tone") @new external make: unit => t = "BitCrusher"
@module("tone") @new external makeWithBits: positive => t = "BitCrusher"
@module("tone") @new external makeWithOptions: options => t = "BitCrusher"

@get external bits: t => Param.t = "bits"
@get external wet: t => Param.t = "wet"

@send external dispose: t => t = "dispose"

external asAudioNode: t => AudioNode.t = "%identity"
