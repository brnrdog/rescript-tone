// Bindings for Tone.Filter
open Types

type t

type filterType =
  | @as("lowpass") Lowpass
  | @as("highpass") Highpass
  | @as("bandpass") Bandpass
  | @as("lowshelf") Lowshelf
  | @as("highshelf") Highshelf
  | @as("notch") Notch
  | @as("allpass") Allpass
  | @as("peaking") Peaking

type rolloff =
  | @as(-12) R12
  | @as(-24) R24
  | @as(-48) R48
  | @as(-96) R96

type options = {
  frequency?: frequency,
  \"type"?: filterType,
  rolloff?: rolloff,
  q?: positive,
  gain?: float,
}

@module("tone") @new external make: unit => t = "Filter"
@module("tone") @new external makeWithFreq: frequency => t = "Filter"
@module("tone") @new external makeWithOptions: options => t = "Filter"

@get external frequency: t => Param.t = "frequency"
@get external q: t => Param.t = "Q"
@get external gain: t => Param.t = "gain"
@get external detune: t => Param.t = "detune"
@get external getType: t => filterType = "type"
@set external setType: (t, filterType) => unit = "type"
@get external rolloff: t => rolloff = "rolloff"
@set external setRolloff: (t, rolloff) => unit = "rolloff"

@send external getFrequencyResponse: (t, int) => array<float> = "getFrequencyResponse"
@send external dispose: t => t = "dispose"

external asAudioNode: t => AudioNode.t = "%identity"
