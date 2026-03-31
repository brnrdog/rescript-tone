// Bindings for Tone.AMSynth - AM synthesis
open Types

type t

type options = {
  harmonicity?: positive,
  oscillator?: oscillatorOptions,
  modulation?: oscillatorOptions,
  envelope?: envelopeOptions,
  modulationEnvelope?: envelopeOptions,
  volume?: decibels,
}

@module("tone") @new external make: unit => t = "AMSynth"
@module("tone") @new external makeWithOptions: options => t = "AMSynth"

@send external triggerAttack: (t, frequency) => t = "triggerAttack"
@send external triggerAttackAt: (t, frequency, ~time: time=?) => t = "triggerAttack"
@send external triggerAttackAtVel: (t, frequency, ~time: time=?, ~velocity: normalRange=?) => t = "triggerAttack"
@send external triggerRelease: (t, ~time: time=?) => t = "triggerRelease"
@send external triggerAttackRelease: (t, frequency, time) => t = "triggerAttackRelease"
@send external triggerAttackReleaseAt: (t, frequency, time, ~time: time=?) => t = "triggerAttackRelease"
@send external triggerAttackReleaseAtVel: (t, frequency, time, ~time: time=?, ~velocity: normalRange=?) => t = "triggerAttackRelease"

@get external volume: t => Param.t = "volume"
@get external frequency: t => Param.t = "frequency"
@get external detune: t => Param.t = "detune"

@send external dispose: t => t = "dispose"
@send external sync: t => t = "sync"
@send external unsync: t => t = "unsync"

external asAudioNode: t => AudioNode.t = "%identity"
