// Bindings for Tone.Player - audio file playback
open Types

type t

type options = {
  url?: string,
  loop?: bool,
  autostart?: bool,
  playbackRate?: positive,
  loopStart?: time,
  loopEnd?: time,
  reverse?: bool,
  fadeIn?: time,
  fadeOut?: time,
  volume?: decibels,
}

@module("tone") @new external make: string => t = "Player"
@module("tone") @new external makeWithOptions: options => t = "Player"

// Source lifecycle
@send external start: (t, ~time: time=?) => t = "start"
@send external startWithOffset: (t, ~time: time=?, ~offset: time=?) => t = "start"
@send external startWithOffsetDuration: (t, ~time: time=?, ~offset: time=?, ~duration: time=?) => t = "start"
@send external stop: (t, ~time: time=?) => t = "stop"
@send external restart: (t, ~time: time=?) => t = "restart"
@send external seek: (t, time) => t = "seek"
@send external seekAt: (t, time, ~when_: time=?) => t = "seek"
@send external dispose: t => t = "dispose"

// Loading
@send external load: (t, string) => promise<t> = "load"

// Properties
@get external volume: t => Param.t = "volume"
@get external loaded: t => bool = "loaded"
@get external loop: t => bool = "loop"
@set external setLoop: (t, bool) => unit = "loop"
@get external loopStart: t => time = "loopStart"
@set external setLoopStart: (t, time) => unit = "loopStart"
@get external loopEnd: t => time = "loopEnd"
@set external setLoopEnd: (t, time) => unit = "loopEnd"
@send external setLoopPoints: (t, time, time) => t = "setLoopPoints"
@get external playbackRate: t => positive = "playbackRate"
@set external setPlaybackRate: (t, positive) => unit = "playbackRate"
@get external reverse: t => bool = "reverse"
@set external setReverse: (t, bool) => unit = "reverse"
@get external autostart: t => bool = "autostart"
@set external setAutostart: (t, bool) => unit = "autostart"
@get external fadeIn: t => time = "fadeIn"
@set external setFadeIn: (t, time) => unit = "fadeIn"
@get external fadeOut: t => time = "fadeOut"
@set external setFadeOut: (t, time) => unit = "fadeOut"

// Sync
@send external sync: t => t = "sync"
@send external unsync: t => t = "unsync"

external asAudioNode: t => AudioNode.t = "%identity"
