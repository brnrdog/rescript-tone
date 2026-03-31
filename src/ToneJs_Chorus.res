// Bindings for Tone.Chorus
open ToneJs_Types

type t

type options = {
  frequency?: frequency,
  delayTime?: milliseconds,
  depth?: normalRange,
  \"type"?: oscillatorType,
  spread?: degrees,
  feedback?: normalRange,
  wet?: normalRange,
}

@module("tone") @new external make: unit => t = "Chorus"
@module("tone") @new external makeWithArgs: (frequency, milliseconds, normalRange) => t = "Chorus"
@module("tone") @new external makeWithOptions: options => t = "Chorus"

@get external frequency: t => ToneJs_Param.t = "frequency"
@get external depth: t => normalRange = "depth"
@set external setDepth: (t, normalRange) => unit = "depth"
@get external delayTime: t => milliseconds = "delayTime"
@set external setDelayTime: (t, milliseconds) => unit = "delayTime"
@get external getType: t => oscillatorType = "type"
@set external setType: (t, oscillatorType) => unit = "type"
@get external spread: t => degrees = "spread"
@set external setSpread: (t, degrees) => unit = "spread"
@get external wet: t => ToneJs_Param.t = "wet"

@send external start: (t, ~time: time=?) => t = "start"
@send external stop: (t, ~time: time=?) => t = "stop"
@send external sync: t => t = "sync"
@send external unsync: t => t = "unsync"
@send external dispose: t => t = "dispose"

external asAudioNode: t => ToneJs_AudioNode.t = "%identity"
