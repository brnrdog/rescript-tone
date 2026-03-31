// Bindings for Tone.FrequencyShifter
open ToneJs_Types

type t

type options = {
  frequency?: frequency,
  wet?: normalRange,
}

@module("tone") @new external make: unit => t = "FrequencyShifter"
@module("tone") @new external makeWithOptions: options => t = "FrequencyShifter"

@get external frequency: t => ToneJs_Param.t = "frequency"
@get external wet: t => ToneJs_Param.t = "wet"

@send external dispose: t => t = "dispose"

external asAudioNode: t => ToneJs_AudioNode.t = "%identity"
