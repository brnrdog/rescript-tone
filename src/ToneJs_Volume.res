// Bindings for Tone.Volume
open ToneJs_Types

type t

type options = {
  volume?: decibels,
  mute?: bool,
}

@module("tone") @new external make: unit => t = "Volume"
@module("tone") @new external makeWithVolume: decibels => t = "Volume"
@module("tone") @new external makeWithOptions: options => t = "Volume"

@get external volume: t => ToneJs_Param.t = "volume"
@get external mute: t => bool = "mute"
@set external setMute: (t, bool) => unit = "mute"

@send external dispose: t => t = "dispose"

external asAudioNode: t => ToneJs_AudioNode.t = "%identity"
