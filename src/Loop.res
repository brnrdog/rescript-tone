// Bindings for Tone.Loop - looping callback
open Types

type t

type options = {
  callback?: seconds => unit,
  interval?: time,
  playbackRate?: positive,
  iterations?: int,
  probability?: normalRange,
  mute?: bool,
  humanize?: bool,
}

@module("tone") @new external make: (seconds => unit, time) => t = "Loop"
@module("tone") @new external makeWithOptions: options => t = "Loop"

@send external start: (t, ~time: transportTime=?) => t = "start"
@send external stop: (t, ~time: transportTime=?) => t = "stop"
@send external cancel: (t, ~time: transportTime=?) => t = "cancel"
@send external dispose: t => t = "dispose"

@get external state: t => basicPlaybackState = "state"
@get external progress: t => normalRange = "progress"
@get external interval: t => time = "interval"
@set external setInterval: (t, time) => unit = "interval"
@get external playbackRate: t => positive = "playbackRate"
@set external setPlaybackRate: (t, positive) => unit = "playbackRate"
@get external humanize: t => bool = "humanize"
@set external setHumanize: (t, bool) => unit = "humanize"
@get external probability: t => normalRange = "probability"
@set external setProbability: (t, normalRange) => unit = "probability"
@get external mute: t => bool = "mute"
@set external setMute: (t, bool) => unit = "mute"
@get external iterations: t => int = "iterations"
@set external setIterations: (t, int) => unit = "iterations"
@get external callback: t => seconds => unit = "callback"
@set external setCallback: (t, seconds => unit) => unit = "callback"
