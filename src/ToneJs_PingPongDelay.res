// Bindings for Tone.PingPongDelay
open ToneJs_Types

type t

type options = {
  delayTime?: time,
  maxDelay?: time,
  feedback?: normalRange,
  wet?: normalRange,
}

@module("tone") @new external make: unit => t = "PingPongDelay"
@module("tone") @new external makeWithTime: time => t = "PingPongDelay"
@module("tone") @new external makeWithTimeFeedback: (time, normalRange) => t = "PingPongDelay"
@module("tone") @new external makeWithOptions: options => t = "PingPongDelay"

@get external delayTime: t => ToneJs_Param.t = "delayTime"
@get external feedback: t => ToneJs_Param.t = "feedback"
@get external wet: t => ToneJs_Param.t = "wet"

@send external dispose: t => t = "dispose"

external asAudioNode: t => ToneJs_AudioNode.t = "%identity"
