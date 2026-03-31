// Bindings for Tone.Synth - a basic synthesizer
open ToneJs_Types

type t

type options = {
  oscillator?: oscillatorOptions,
  envelope?: envelopeOptions,
  volume?: decibels,
}

@module("tone") @new external make: unit => t = "Synth"
@module("tone") @new external makeWithOptions: options => t = "Synth"

// Instrument methods
@send external triggerAttack: (t, frequency) => t = "triggerAttack"
@send external triggerAttackAt: (t, frequency, ~time: time=?) => t = "triggerAttack"
@send external triggerAttackAtVel: (t, frequency, ~time: time=?, ~velocity: normalRange=?) => t = "triggerAttack"
@send external triggerRelease: (t, ~time: time=?) => t = "triggerRelease"
@send external triggerAttackRelease: (t, frequency, time) => t = "triggerAttackRelease"
@send external triggerAttackReleaseAt: (t, frequency, time, ~time: time=?) => t = "triggerAttackRelease"
@send external triggerAttackReleaseAtVel: (t, frequency, time, ~time: time=?, ~velocity: normalRange=?) => t = "triggerAttackRelease"

// Properties
@get external volume: t => ToneJs_Param.t = "volume"
@get external frequency: t => ToneJs_Param.t = "frequency"
@get external detune: t => ToneJs_Param.t = "detune"

// Lifecycle
@send external dispose: t => t = "dispose"
@send external sync: t => t = "sync"
@send external unsync: t => t = "unsync"

// AudioNode
external asAudioNode: t => ToneJs_AudioNode.t = "%identity"
