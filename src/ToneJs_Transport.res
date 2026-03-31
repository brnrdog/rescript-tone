// Bindings for Tone.js Transport - master timing and scheduling
open ToneJs_Types

type t

// Lifecycle
@send external start: t => t = "start"
@send external startAt: (t, ~time: time=?) => t = "start"
@send external startAtWithOffset: (t, ~time: time=?, ~offset: transportTime=?) => t = "start"
@send external stop: t => t = "stop"
@send external stopAt: (t, ~time: time=?) => t = "stop"
@send external pause: t => t = "pause"
@send external pauseAt: (t, ~time: time=?) => t = "pause"
@send external toggle: t => t = "toggle"
@send external toggleAt: (t, ~time: time=?) => t = "toggle"
@send external cancel: t => t = "cancel"
@send external cancelAfter: (t, ~after: transportTime=?) => t = "cancel"
@send external dispose: t => t = "dispose"

// Scheduling
@send external schedule: (t, seconds => unit, transportTime) => int = "schedule"
@send external scheduleRepeat: (t, seconds => unit, time) => int = "scheduleRepeat"
@send external scheduleRepeatFrom: (t, seconds => unit, time, ~startTime: transportTime=?) => int = "scheduleRepeat"
@send external scheduleRepeatFromFor: (t, seconds => unit, time, ~startTime: transportTime=?, ~duration: time=?) => int = "scheduleRepeat"
@send external scheduleOnce: (t, seconds => unit, transportTime) => int = "scheduleOnce"
@send external clear: (t, int) => t = "clear"

// BPM
@get external bpm: t => ToneJs_Param.t = "bpm"

// Position
@get external position: t => string = "position"
@set external setPosition: (t, string) => unit = "position"
@get external seconds: t => seconds = "seconds"
@set external setSeconds: (t, seconds) => unit = "seconds"
@get external progress: t => normalRange = "progress"
@get external ticks: t => ticks = "ticks"
@set external setTicks: (t, ticks) => unit = "ticks"

// Loop
@get external loop: t => bool = "loop"
@set external setLoop: (t, bool) => unit = "loop"
@get external loopStart: t => time = "loopStart"
@set external setLoopStart: (t, time) => unit = "loopStart"
@get external loopEnd: t => time = "loopEnd"
@set external setLoopEnd: (t, time) => unit = "loopEnd"
@send external setLoopPoints: (t, transportTime, transportTime) => t = "setLoopPoints"

// Swing
@get external swing: t => normalRange = "swing"
@set external setSwing: (t, normalRange) => unit = "swing"

// Time signature
@get external timeSignature: t => int = "timeSignature"
@set external setTimeSignature: (t, int) => unit = "timeSignature"

// State
@get external state: t => playbackState = "state"

// PPQ
@get external ppq: t => int = "PPQ"
@set external setPPQ: (t, int) => unit = "PPQ"

// Timing
@send external getTicksAtTime: (t, time) => ticks = "getTicksAtTime"
@send external getSecondsAtTime: (t, time) => seconds = "getSecondsAtTime"
@send external nextSubdivision: (t, time) => seconds = "nextSubdivision"
