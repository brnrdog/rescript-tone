// Bindings for Tone.Distortion
open Types

type t

type options = {
  distortion?: float,
  oversample?: oversampleType,
  wet?: normalRange,
}

@module("tone") @new external make: unit => t = "Distortion"
@module("tone") @new external makeWithAmount: float => t = "Distortion"
@module("tone") @new external makeWithOptions: options => t = "Distortion"

@get external distortion: t => float = "distortion"
@set external setDistortion: (t, float) => unit = "distortion"
@get external oversample: t => oversampleType = "oversample"
@set external setOversample: (t, oversampleType) => unit = "oversample"
@get external wet: t => Param.t = "wet"

@send external dispose: t => t = "dispose"

external asAudioNode: t => AudioNode.t = "%identity"
