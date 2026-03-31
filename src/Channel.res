// Bindings for Tone.Channel - routing and mixing
open Types

type t

type options = {
  pan?: audioRange,
  volume?: decibels,
  solo?: bool,
  mute?: bool,
  channelCount?: int,
}

@module("tone") @new external make: unit => t = "Channel"
@module("tone") @new external makeWithVolume: decibels => t = "Channel"
@module("tone") @new external makeWithVolumePan: (decibels, audioRange) => t = "Channel"
@module("tone") @new external makeWithOptions: options => t = "Channel"

@get external pan: t => Param.t = "pan"
@get external volume: t => Param.t = "volume"
@get external solo: t => bool = "solo"
@set external setSolo: (t, bool) => unit = "solo"
@get external mute: t => bool = "mute"
@set external setMute: (t, bool) => unit = "mute"
@get external muted: t => bool = "muted"

@send external send: (t, string) => Gain.t = "send"
@send external sendWithVolume: (t, string, ~volume: decibels=?) => Gain.t = "send"
@send external receive: (t, string) => t = "receive"

@send external dispose: t => t = "dispose"

external asAudioNode: t => AudioNode.t = "%identity"
