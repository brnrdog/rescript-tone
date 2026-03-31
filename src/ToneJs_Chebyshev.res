// Bindings for Tone.Chebyshev - waveshaping distortion
open ToneJs_Types

type t

type options = {
  order?: int,
  oversample?: oversampleType,
  wet?: normalRange,
}

@module("tone") @new external make: unit => t = "Chebyshev"
@module("tone") @new external makeWithOrder: int => t = "Chebyshev"
@module("tone") @new external makeWithOptions: options => t = "Chebyshev"

@get external order: t => int = "order"
@set external setOrder: (t, int) => unit = "order"
@get external oversample: t => oversampleType = "oversample"
@set external setOversample: (t, oversampleType) => unit = "oversample"
@get external wet: t => ToneJs_Param.t = "wet"

@send external dispose: t => t = "dispose"

external asAudioNode: t => ToneJs_AudioNode.t = "%identity"
