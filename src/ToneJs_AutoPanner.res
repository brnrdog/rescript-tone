// Bindings for Tone.AutoPanner
open ToneJs_Types

type t

type options = {
  frequency?: frequency,
  \"type"?: oscillatorType,
  depth?: normalRange,
  wet?: normalRange,
}

@module("tone") @new external make: unit => t = "AutoPanner"
@module("tone") @new external makeWithOptions: options => t = "AutoPanner"

@get external frequency: t => ToneJs_Param.t = "frequency"
@get external depth: t => ToneJs_Param.t = "depth"
@get external wet: t => ToneJs_Param.t = "wet"

@send external start: (t, ~time: time=?) => t = "start"
@send external stop: (t, ~time: time=?) => t = "stop"
@send external sync: t => t = "sync"
@send external unsync: t => t = "unsync"
@send external dispose: t => t = "dispose"

external asAudioNode: t => ToneJs_AudioNode.t = "%identity"
