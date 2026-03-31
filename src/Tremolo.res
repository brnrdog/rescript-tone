// Bindings for Tone.Tremolo
open Types

type t

type options = {
  frequency?: frequency,
  \"type"?: oscillatorType,
  depth?: normalRange,
  spread?: degrees,
  wet?: normalRange,
}

@module("tone") @new external make: unit => t = "Tremolo"
@module("tone") @new external makeWithOptions: options => t = "Tremolo"

@get external frequency: t => Param.t = "frequency"
@get external depth: t => Param.t = "depth"
@get external getType: t => oscillatorType = "type"
@set external setType: (t, oscillatorType) => unit = "type"
@get external spread: t => degrees = "spread"
@set external setSpread: (t, degrees) => unit = "spread"
@get external wet: t => Param.t = "wet"

@send external start: (t, ~time: time=?) => t = "start"
@send external stop: (t, ~time: time=?) => t = "stop"
@send external sync: t => t = "sync"
@send external unsync: t => t = "unsync"
@send external dispose: t => t = "dispose"

external asAudioNode: t => AudioNode.t = "%identity"
