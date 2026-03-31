// Bindings for Tone.js Context
open Types

type t

@send external now: t => seconds = "now"
@send external immediate: t => seconds = "immediate"
@send external resume: t => promise<unit> = "resume"
@send external close: t => promise<unit> = "close"
@send external dispose: t => t = "dispose"

@get external currentTime: t => seconds = "currentTime"
@get external state: t => string = "state"
@get external sampleRate: t => float = "sampleRate"
@get external lookAhead: t => seconds = "lookAhead"
@set external setLookAhead: (t, seconds) => unit = "lookAhead"

@send external setTimeout: (t, unit => unit, seconds) => int = "setTimeout"
@send external clearTimeout: (t, int) => t = "clearTimeout"
@send external setInterval: (t, unit => unit, seconds) => int = "setInterval"
@send external clearInterval: (t, int) => t = "clearInterval"
