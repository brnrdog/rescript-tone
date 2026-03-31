// Bindings for Tone.CrossFade
open Types

type t

type options = {
  fade?: normalRange,
}

@module("tone") @new external make: unit => t = "CrossFade"
@module("tone") @new external makeWithFade: normalRange => t = "CrossFade"
@module("tone") @new external makeWithOptions: options => t = "CrossFade"

@get external fade: t => Param.t = "fade"
@get external a: t => Gain.t = "a"
@get external b: t => Gain.t = "b"

@send external dispose: t => t = "dispose"

external asAudioNode: t => AudioNode.t = "%identity"
