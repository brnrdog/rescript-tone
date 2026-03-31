// Bindings for Tone.js Destination - the master output

type t

@get external volume: t => ToneJs_Param.t = "volume"
@get external mute: t => bool = "mute"
@set external setMute: (t, bool) => unit = "mute"
@get external maxChannelCount: t => int = "maxChannelCount"
@send external dispose: t => t = "dispose"

// Destination is also an AudioNode, so it can be connected to
external asAudioNode: t => ToneJs_AudioNode.t = "%identity"
