// Bindings for Tone.PolySynth - polyphonic synthesizer
open Types

type t

type options = {
  maxPolyphony?: int,
  volume?: decibels,
}

@module("tone") @new external make: unit => t = "PolySynth"
@module("tone") @new external makeWithOptions: options => t = "PolySynth"

// PolySynth takes arrays of notes
@send external triggerAttack: (t, array<frequency>) => t = "triggerAttack"
@send external triggerAttackNote: (t, frequency) => t = "triggerAttack"
@send external triggerAttackAt: (t, array<frequency>, ~time: time=?) => t = "triggerAttack"
@send external triggerAttackAtVel: (t, array<frequency>, ~time: time=?, ~velocity: normalRange=?) => t = "triggerAttack"
@send external triggerRelease: (t, array<frequency>) => t = "triggerRelease"
@send external triggerReleaseNote: (t, frequency) => t = "triggerRelease"
@send external triggerReleaseAt: (t, array<frequency>, ~time: time=?) => t = "triggerRelease"
@send external triggerAttackRelease: (t, array<frequency>, time) => t = "triggerAttackRelease"
@send external triggerAttackReleaseNote: (t, frequency, time) => t = "triggerAttackRelease"
@send external triggerAttackReleaseAt: (t, array<frequency>, time, ~time: time=?) => t = "triggerAttackRelease"
@send external triggerAttackReleaseAtVel: (t, array<frequency>, time, ~time: time=?, ~velocity: normalRange=?) => t = "triggerAttackRelease"
@send external releaseAll: (t, ~time: time=?) => t = "releaseAll"

@get external volume: t => Param.t = "volume"
@get external activeVoices: t => int = "activeVoices"
@get external maxPolyphony: t => int = "maxPolyphony"
@set external setMaxPolyphony: (t, int) => unit = "maxPolyphony"

@send external dispose: t => t = "dispose"
@send external sync: t => t = "sync"
@send external unsync: t => t = "unsync"

external asAudioNode: t => AudioNode.t = "%identity"
