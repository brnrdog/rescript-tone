// Bindings for Tone.FrequencyShifter
open Types

type t

type options = {
  frequency?: frequency,
  wet?: normalRange,
}

@module("tone") @new external make: unit => t = "FrequencyShifter"
@module("tone") @new external makeWithOptions: options => t = "FrequencyShifter"

@get external frequency: t => Param.t = "frequency"
@get external wet: t => Param.t = "wet"

@send external dispose: t => t = "dispose"

external asAudioNode: t => AudioNode.t = "%identity"
