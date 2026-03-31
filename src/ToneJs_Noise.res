// Bindings for Tone.Noise - noise generator
open ToneJs_Types

type t

type options = {
  \"type"?: noiseType,
  playbackRate?: positive,
  fadeIn?: time,
  fadeOut?: time,
  volume?: decibels,
}

@module("tone") @new external make: noiseType => t = "Noise"
@module("tone") @new external makeWithOptions: options => t = "Noise"

// Source lifecycle
@send external start: (t, ~time: time=?) => t = "start"
@send external stop: (t, ~time: time=?) => t = "stop"
@send external restart: (t, ~time: time=?) => t = "restart"
@send external dispose: t => t = "dispose"

// Properties
@get external volume: t => ToneJs_Param.t = "volume"
@get external getType: t => noiseType = "type"
@set external setType: (t, noiseType) => unit = "type"
@get external playbackRate: t => positive = "playbackRate"
@set external setPlaybackRate: (t, positive) => unit = "playbackRate"
@get external fadeIn: t => time = "fadeIn"
@set external setFadeIn: (t, time) => unit = "fadeIn"
@get external fadeOut: t => time = "fadeOut"
@set external setFadeOut: (t, time) => unit = "fadeOut"

// Sync
@send external sync: t => t = "sync"
@send external unsync: t => t = "unsync"

external asAudioNode: t => ToneJs_AudioNode.t = "%identity"
