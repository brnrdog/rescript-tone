// Bindings for Tone.Vibrato
open Types

type t

type options = {
  frequency?: frequency,
  \"type"?: oscillatorType,
  depth?: normalRange,
  maxDelay?: seconds,
  wet?: normalRange,
}

@module("tone") @new external make: unit => t = "Vibrato"
@module("tone") @new external makeWithOptions: options => t = "Vibrato"

@get external frequency: t => Param.t = "frequency"
@get external depth: t => Param.t = "depth"
@get external getType: t => oscillatorType = "type"
@set external setType: (t, oscillatorType) => unit = "type"
@get external wet: t => Param.t = "wet"

@send external dispose: t => t = "dispose"

external asAudioNode: t => AudioNode.t = "%identity"
