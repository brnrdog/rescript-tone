// Bindings for Tone.AutoFilter
open Types

type t

type options = {
  frequency?: frequency,
  \"type"?: oscillatorType,
  depth?: normalRange,
  baseFrequency?: frequency,
  octaves?: positive,
  filter?: filterOptions,
  wet?: normalRange,
}

@module("tone") @new external make: unit => t = "AutoFilter"
@module("tone") @new external makeWithOptions: options => t = "AutoFilter"

@get external frequency: t => Param.t = "frequency"
@get external depth: t => Param.t = "depth"
@get external wet: t => Param.t = "wet"
@get external octaves: t => positive = "octaves"
@set external setOctaves: (t, positive) => unit = "octaves"
@get external baseFrequency: t => frequency = "baseFrequency"
@set external setBaseFrequency: (t, frequency) => unit = "baseFrequency"

@send external start: (t, ~time: time=?) => t = "start"
@send external stop: (t, ~time: time=?) => t = "stop"
@send external sync: t => t = "sync"
@send external unsync: t => t = "unsync"
@send external dispose: t => t = "dispose"

external asAudioNode: t => AudioNode.t = "%identity"
