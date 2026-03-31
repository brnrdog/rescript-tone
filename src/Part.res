// Bindings for Tone.Part - a collection of events on a timeline
open Types

type t

@module("tone") @new external make: ((seconds, 'a) => unit, array<'a>) => t = "Part"

@send external start: (t, ~time: transportTime=?) => t = "start"
@send external startWithOffset: (t, ~time: transportTime=?, ~offset: time=?) => t = "start"
@send external stop: (t, ~time: transportTime=?) => t = "stop"
@send external cancel: (t, ~time: transportTime=?) => t = "cancel"
@send external clear: t => t = "clear"
@send external dispose: t => t = "dispose"

@send external add: (t, time, 'a) => t = "add"
@send external remove: (t, time, 'a) => t = "remove"
@send external at: (t, time) => Null.t<Event.t> = "at"

@get external state: t => basicPlaybackState = "state"
@get external progress: t => normalRange = "progress"
@get external length: t => int = "length"
@get external loop: t => bool = "loop"
@set external setLoop: (t, bool) => unit = "loop"
@set external setLoopCount: (t, int) => unit = "loop"
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
