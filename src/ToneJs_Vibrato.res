// Bindings for Tone.Vibrato
open ToneJs_Types

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

@get external frequency: t => ToneJs_Param.t = "frequency"
@get external depth: t => ToneJs_Param.t = "depth"
@get external getType: t => oscillatorType = "type"
@set external setType: (t, oscillatorType) => unit = "type"
@get external wet: t => ToneJs_Param.t = "wet"

@send external dispose: t => t = "dispose"

external asAudioNode: t => ToneJs_AudioNode.t = "%identity"
