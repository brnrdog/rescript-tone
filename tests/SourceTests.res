open Zekr

// Note: Tone.js instruments/sources require a real AudioContext to instantiate.
// Compilation of this file validates that all binding types are correct.
// These tests verify the bindings are properly exported.

let synthSuite = suite("Synth", [
  test("bindings type-check", () => {
    let _ = ToneJs_Synth.make
    let _ = ToneJs_Synth.makeWithOptions
    let _ = ToneJs_Synth.triggerAttack
    let _ = ToneJs_Synth.triggerAttackAt
    let _ = ToneJs_Synth.triggerAttackAtVel
    let _ = ToneJs_Synth.triggerRelease
    let _ = ToneJs_Synth.triggerAttackRelease
    let _ = ToneJs_Synth.triggerAttackReleaseAt
    let _ = ToneJs_Synth.triggerAttackReleaseAtVel
    let _ = ToneJs_Synth.volume
    let _ = ToneJs_Synth.frequency
    let _ = ToneJs_Synth.detune
    let _ = ToneJs_Synth.dispose
    let _ = ToneJs_Synth.sync
    let _ = ToneJs_Synth.unsync
    let _ = ToneJs_Synth.asAudioNode
    Pass
  }),
])

let amSynthSuite = suite("AMSynth", [
  test("bindings type-check", () => {
    let _ = ToneJs_AMSynth.make
    let _ = ToneJs_AMSynth.makeWithOptions
    let _ = ToneJs_AMSynth.triggerAttack
    let _ = ToneJs_AMSynth.triggerAttackAt
    let _ = ToneJs_AMSynth.triggerAttackAtVel
    let _ = ToneJs_AMSynth.triggerRelease
    let _ = ToneJs_AMSynth.triggerAttackRelease
    let _ = ToneJs_AMSynth.volume
    let _ = ToneJs_AMSynth.frequency
    let _ = ToneJs_AMSynth.detune
    let _ = ToneJs_AMSynth.dispose
    let _ = ToneJs_AMSynth.sync
    let _ = ToneJs_AMSynth.unsync
    let _ = ToneJs_AMSynth.asAudioNode
    Pass
  }),
])

let fmSynthSuite = suite("FMSynth", [
  test("bindings type-check", () => {
    let _ = ToneJs_FMSynth.make
    let _ = ToneJs_FMSynth.makeWithOptions
    let _ = ToneJs_FMSynth.triggerAttack
    let _ = ToneJs_FMSynth.triggerRelease
    let _ = ToneJs_FMSynth.triggerAttackRelease
    let _ = ToneJs_FMSynth.volume
    let _ = ToneJs_FMSynth.frequency
    let _ = ToneJs_FMSynth.detune
    let _ = ToneJs_FMSynth.dispose
    let _ = ToneJs_FMSynth.asAudioNode
    Pass
  }),
])

let monoSynthSuite = suite("MonoSynth", [
  test("bindings type-check", () => {
    let _ = ToneJs_MonoSynth.make
    let _ = ToneJs_MonoSynth.makeWithOptions
    let _ = ToneJs_MonoSynth.triggerAttack
    let _ = ToneJs_MonoSynth.triggerRelease
    let _ = ToneJs_MonoSynth.triggerAttackRelease
    let _ = ToneJs_MonoSynth.volume
    let _ = ToneJs_MonoSynth.frequency
    let _ = ToneJs_MonoSynth.detune
    let _ = ToneJs_MonoSynth.dispose
    let _ = ToneJs_MonoSynth.asAudioNode
    Pass
  }),
])

let polySynthSuite = suite("PolySynth", [
  test("bindings type-check", () => {
    let _ = ToneJs_PolySynth.make
    let _ = ToneJs_PolySynth.makeWithOptions
    let _ = ToneJs_PolySynth.triggerAttack
    let _ = ToneJs_PolySynth.triggerAttackNote
    let _ = ToneJs_PolySynth.triggerRelease
    let _ = ToneJs_PolySynth.triggerReleaseNote
    let _ = ToneJs_PolySynth.triggerAttackRelease
    let _ = ToneJs_PolySynth.triggerAttackReleaseNote
    let _ = ToneJs_PolySynth.releaseAll
    let _ = ToneJs_PolySynth.activeVoices
    let _ = ToneJs_PolySynth.maxPolyphony
    let _ = ToneJs_PolySynth.setMaxPolyphony
    let _ = ToneJs_PolySynth.dispose
    let _ = ToneJs_PolySynth.asAudioNode
    Pass
  }),
])

let oscillatorSuite = suite("Oscillator", [
  test("bindings type-check", () => {
    let _ = ToneJs_Oscillator.make
    let _ = ToneJs_Oscillator.makeWithOptions
    let _ = ToneJs_Oscillator.makeWithFreq
    let _ = ToneJs_Oscillator.start
    let _ = ToneJs_Oscillator.stop
    let _ = ToneJs_Oscillator.restart
    let _ = ToneJs_Oscillator.frequency
    let _ = ToneJs_Oscillator.detune
    let _ = ToneJs_Oscillator.volume
    let _ = ToneJs_Oscillator.getType
    let _ = ToneJs_Oscillator.setType
    let _ = ToneJs_Oscillator.phase
    let _ = ToneJs_Oscillator.setPhase
    let _ = ToneJs_Oscillator.partialCount
    let _ = ToneJs_Oscillator.setPartialCount
    let _ = ToneJs_Oscillator.partials
    let _ = ToneJs_Oscillator.setPartials
    let _ = ToneJs_Oscillator.syncFrequency
    let _ = ToneJs_Oscillator.unsyncFrequency
    let _ = ToneJs_Oscillator.dispose
    let _ = ToneJs_Oscillator.asAudioNode
    Pass
  }),
])

let playerSuite = suite("Player", [
  test("bindings type-check", () => {
    let _ = ToneJs_Player.make
    let _ = ToneJs_Player.makeWithOptions
    let _ = ToneJs_Player.start
    let _ = ToneJs_Player.startWithOffset
    let _ = ToneJs_Player.startWithOffsetDuration
    let _ = ToneJs_Player.stop
    let _ = ToneJs_Player.restart
    let _ = ToneJs_Player.seek
    let _ = ToneJs_Player.seekAt
    let _ = ToneJs_Player.load
    let _ = ToneJs_Player.loaded
    let _ = ToneJs_Player.loop
    let _ = ToneJs_Player.setLoop
    let _ = ToneJs_Player.loopStart
    let _ = ToneJs_Player.setLoopStart
    let _ = ToneJs_Player.loopEnd
    let _ = ToneJs_Player.setLoopEnd
    let _ = ToneJs_Player.setLoopPoints
    let _ = ToneJs_Player.playbackRate
    let _ = ToneJs_Player.setPlaybackRate
    let _ = ToneJs_Player.reverse
    let _ = ToneJs_Player.setReverse
    let _ = ToneJs_Player.autostart
    let _ = ToneJs_Player.setAutostart
    let _ = ToneJs_Player.fadeIn
    let _ = ToneJs_Player.setFadeIn
    let _ = ToneJs_Player.fadeOut
    let _ = ToneJs_Player.setFadeOut
    let _ = ToneJs_Player.dispose
    let _ = ToneJs_Player.asAudioNode
    Pass
  }),
])

let noiseSuite = suite("Noise", [
  test("bindings type-check", () => {
    let _ = ToneJs_Noise.make
    let _ = ToneJs_Noise.makeWithOptions
    let _ = ToneJs_Noise.start
    let _ = ToneJs_Noise.stop
    let _ = ToneJs_Noise.restart
    let _ = ToneJs_Noise.volume
    let _ = ToneJs_Noise.getType
    let _ = ToneJs_Noise.setType
    let _ = ToneJs_Noise.playbackRate
    let _ = ToneJs_Noise.setPlaybackRate
    let _ = ToneJs_Noise.fadeIn
    let _ = ToneJs_Noise.setFadeIn
    let _ = ToneJs_Noise.fadeOut
    let _ = ToneJs_Noise.setFadeOut
    let _ = ToneJs_Noise.dispose
    let _ = ToneJs_Noise.asAudioNode
    Pass
  }),
])

let suites = [
  synthSuite,
  amSynthSuite,
  fmSynthSuite,
  monoSynthSuite,
  polySynthSuite,
  oscillatorSuite,
  playerSuite,
  noiseSuite,
]
