// Bindings for Tone.BitCrusher
open ToneJs_Types

type t

type options = {
  bits?: positive,
  wet?: normalRange,
}

@module("tone") @new external make: unit => t = "BitCrusher"
@module("tone") @new external makeWithBits: positive => t = "BitCrusher"
@module("tone") @new external makeWithOptions: options => t = "BitCrusher"

@get external bits: t => ToneJs_Param.t = "bits"
@get external wet: t => ToneJs_Param.t = "wet"

@send external dispose: t => t = "dispose"

external asAudioNode: t => ToneJs_AudioNode.t = "%identity"
