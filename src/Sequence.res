// Bindings for Tone.Sequence - a series of events in order
open Types

type t

@module("tone") @new external make: ((seconds, 'a) => unit, array<'a>) => t = "Sequence"
@module("tone") @new external makeWithSubdivision: ((seconds, 'a) => unit, array<'a>, time) => t = "Sequence"

@send external start: (t, ~time: transportTime=?) => t = "start"
@send external startWithOffset: (t, ~time: transportTime=?, ~offset: int=?) => t = "start"
@send external stop: (t, ~time: transportTime=?) => t = "stop"
@send external clear: t => t = "clear"
@send external dispose: t => t = "dispose"

@get external events: t => array<'a> = "events"
@set external setEvents: (t, array<'a>) => unit = "events"
@get external subdivision: t => seconds = "subdivision"
@get external state: t => basicPlaybackState = "state"
@get external progress: t => normalRange = "progress"
@get external length: t => int = "length"
@get external loop: t => bool = "loop"
@set external setLoop: (t, bool) => unit = "loop"
@set external setLoopCount: (t, int) => unit = "loop"
@get external loopEnd: t => int = "loopEnd"
@set external setLoopEnd: (t, int) => unit = "loopEnd"
@get external loopStart: t => int = "loopStart"
@set external setLoopStart: (t, int) => unit = "loopStart"
@get external playbackRate: t => positive = "playbackRate"
@set external setPlaybackRate: (t, positive) => unit = "playbackRate"
@get external probability: t => normalRange = "probability"
@set external setProbability: (t, normalRange) => unit = "probability"
@get external mute: t => bool = "mute"
@set external setMute: (t, bool) => unit = "mute"
@get external humanize: t => bool = "humanize"
@set external setHumanize: (t, bool) => unit = "humanize"
