// Bindings for Tone.Panner
open ToneJs_Types

type t

type options = {
  pan?: audioRange,
  channelCount?: int,
}

@module("tone") @new external make: unit => t = "Panner"
@module("tone") @new external makeWithPan: audioRange => t = "Panner"
@module("tone") @new external makeWithOptions: options => t = "Panner"

@get external pan: t => ToneJs_Param.t = "pan"

@send external dispose: t => t = "dispose"

external asAudioNode: t => ToneJs_AudioNode.t = "%identity"
