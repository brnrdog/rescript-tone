// Bindings for Tone.CrossFade
open ToneJs_Types

type t

type options = {
  fade?: normalRange,
}

@module("tone") @new external make: unit => t = "CrossFade"
@module("tone") @new external makeWithFade: normalRange => t = "CrossFade"
@module("tone") @new external makeWithOptions: options => t = "CrossFade"

@get external fade: t => ToneJs_Param.t = "fade"
@get external a: t => ToneJs_Gain.t = "a"
@get external b: t => ToneJs_Gain.t = "b"

@send external dispose: t => t = "dispose"

external asAudioNode: t => ToneJs_AudioNode.t = "%identity"
