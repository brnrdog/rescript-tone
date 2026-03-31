// Bindings for Tone.PingPongDelay
open Types

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

@get external delayTime: t => Param.t = "delayTime"
@get external feedback: t => Param.t = "feedback"
@get external wet: t => Param.t = "wet"

@send external dispose: t => t = "dispose"

external asAudioNode: t => AudioNode.t = "%identity"
