// Bindings for Tone.PitchShift
open Types

type t

type options = {
  pitch?: float,
  windowSize?: seconds,
  delayTime?: time,
  feedback?: normalRange,
  wet?: normalRange,
}

@module("tone") @new external make: unit => t = "PitchShift"
@module("tone") @new external makeWithOptions: options => t = "PitchShift"

@get external pitch: t => float = "pitch"
@set external setPitch: (t, float) => unit = "pitch"
@get external windowSize: t => seconds = "windowSize"
@set external setWindowSize: (t, seconds) => unit = "windowSize"
@get external delayTime: t => Param.t = "delayTime"
@get external feedback: t => Param.t = "feedback"
@get external wet: t => Param.t = "wet"

@send external dispose: t => t = "dispose"

external asAudioNode: t => AudioNode.t = "%identity"
