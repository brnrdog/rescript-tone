// Bindings for Tone.ToneEvent - schedulable event
open Types

type t

@module("tone") @new external make: ((seconds, 'a) => unit, 'a) => t = "ToneEvent"

@send external start: (t, ~time: transportTime=?) => t = "start"
@send external stop: (t, ~time: transportTime=?) => t = "stop"
@send external cancel: (t, ~time: transportTime=?) => t = "cancel"
@send external dispose: t => t = "dispose"

@get external state: t => basicPlaybackState = "state"
@get external progress: t => normalRange = "progress"
@get external loop: t => bool = "loop"
@set external setLoop: (t, bool) => unit = "loop"
@get external loopEnd: t => time = "loopEnd"
@set external setLoopEnd: (t, time) => unit = "loopEnd"
@get external loopStart: t => time = "loopStart"
@set external setLoopStart: (t, time) => unit = "loopStart"
@get external playbackRate: t => positive = "playbackRate"
@set external setPlaybackRate: (t, positive) => unit = "playbackRate"
@get external probability: t => normalRange = "probability"
@set external setProbability: (t, normalRange) => unit = "probability"
@get external mute: t => bool = "mute"
@set external setMute: (t, bool) => unit = "mute"
@get external humanize: t => bool = "humanize"
@set external setHumanize: (t, bool) => unit = "humanize"
