open Zekr

// Note: Tone.js instruments/sources require a real AudioContext to instantiate.
// Compilation of this file validates that all binding types are correct.
// These tests verify the bindings are properly exported.

let synthSuite = suite("Synth", [
  test("bindings type-check", () => {
    let _ = Synth.make
    let _ = Synth.makeWithOptions
    let _ = Synth.triggerAttack
    let _ = Synth.triggerAttackAt
    let _ = Synth.triggerAttackAtVel
    let _ = Synth.triggerRelease
    let _ = Synth.triggerAttackRelease
    let _ = Synth.triggerAttackReleaseAt
    let _ = Synth.triggerAttackReleaseAtVel
    let _ = Synth.volume
    let _ = Synth.frequency
    let _ = Synth.detune
    let _ = Synth.dispose
    let _ = Synth.sync
    let _ = Synth.unsync
    let _ = Synth.asAudioNode
    Pass
  }),
])

let amSynthSuite = suite("AMSynth", [
  test("bindings type-check", () => {
    let _ = AMSynth.make
    let _ = AMSynth.makeWithOptions
    let _ = AMSynth.triggerAttack
    let _ = AMSynth.triggerAttackAt
    let _ = AMSynth.triggerAttackAtVel
    let _ = AMSynth.triggerRelease
    let _ = AMSynth.triggerAttackRelease
    let _ = AMSynth.volume
    let _ = AMSynth.frequency
    let _ = AMSynth.detune
    let _ = AMSynth.dispose
    let _ = AMSynth.sync
    let _ = AMSynth.unsync
    let _ = AMSynth.asAudioNode
    Pass
  }),
])

let fmSynthSuite = suite("FMSynth", [
  test("bindings type-check", () => {
    let _ = FMSynth.make
    let _ = FMSynth.makeWithOptions
    let _ = FMSynth.triggerAttack
    let _ = FMSynth.triggerRelease
    let _ = FMSynth.triggerAttackRelease
    let _ = FMSynth.volume
    let _ = FMSynth.frequency
    let _ = FMSynth.detune
    let _ = FMSynth.dispose
    let _ = FMSynth.asAudioNode
    Pass
  }),
])

let monoSynthSuite = suite("MonoSynth", [
  test("bindings type-check", () => {
    let _ = MonoSynth.make
    let _ = MonoSynth.makeWithOptions
    let _ = MonoSynth.triggerAttack
    let _ = MonoSynth.triggerRelease
    let _ = MonoSynth.triggerAttackRelease
    let _ = MonoSynth.volume
    let _ = MonoSynth.frequency
    let _ = MonoSynth.detune
    let _ = MonoSynth.dispose
    let _ = MonoSynth.asAudioNode
    Pass
  }),
])

let polySynthSuite = suite("PolySynth", [
  test("bindings type-check", () => {
    let _ = PolySynth.make
    let _ = PolySynth.makeWithOptions
    let _ = PolySynth.triggerAttack
    let _ = PolySynth.triggerAttackNote
    let _ = PolySynth.triggerRelease
    let _ = PolySynth.triggerReleaseNote
    let _ = PolySynth.triggerAttackRelease
    let _ = PolySynth.triggerAttackReleaseNote
    let _ = PolySynth.releaseAll
    let _ = PolySynth.activeVoices
    let _ = PolySynth.maxPolyphony
    let _ = PolySynth.setMaxPolyphony
    let _ = PolySynth.dispose
    let _ = PolySynth.asAudioNode
    Pass
  }),
])

let oscillatorSuite = suite("Oscillator", [
  test("bindings type-check", () => {
    let _ = Oscillator.make
    let _ = Oscillator.makeWithOptions
    let _ = Oscillator.makeWithFreq
    let _ = Oscillator.start
    let _ = Oscillator.stop
    let _ = Oscillator.restart
    let _ = Oscillator.frequency
    let _ = Oscillator.detune
    let _ = Oscillator.volume
    let _ = Oscillator.getType
    let _ = Oscillator.setType
    let _ = Oscillator.phase
    let _ = Oscillator.setPhase
    let _ = Oscillator.partialCount
    let _ = Oscillator.setPartialCount
    let _ = Oscillator.partials
    let _ = Oscillator.setPartials
    let _ = Oscillator.syncFrequency
    let _ = Oscillator.unsyncFrequency
    let _ = Oscillator.dispose
    let _ = Oscillator.asAudioNode
    Pass
  }),
])

let playerSuite = suite("Player", [
  test("bindings type-check", () => {
    let _ = Player.make
    let _ = Player.makeWithOptions
    let _ = Player.start
    let _ = Player.startWithOffset
    let _ = Player.startWithOffsetDuration
    let _ = Player.stop
    let _ = Player.restart
    let _ = Player.seek
    let _ = Player.seekAt
    let _ = Player.load
    let _ = Player.loaded
    let _ = Player.loop
    let _ = Player.setLoop
    let _ = Player.loopStart
    let _ = Player.setLoopStart
    let _ = Player.loopEnd
    let _ = Player.setLoopEnd
    let _ = Player.setLoopPoints
    let _ = Player.playbackRate
    let _ = Player.setPlaybackRate
    let _ = Player.reverse
    let _ = Player.setReverse
    let _ = Player.autostart
    let _ = Player.setAutostart
    let _ = Player.fadeIn
    let _ = Player.setFadeIn
    let _ = Player.fadeOut
    let _ = Player.setFadeOut
    let _ = Player.dispose
    let _ = Player.asAudioNode
    Pass
  }),
])

let noiseSuite = suite("Noise", [
  test("bindings type-check", () => {
    let _ = Noise.make
    let _ = Noise.makeWithOptions
    let _ = Noise.start
    let _ = Noise.stop
    let _ = Noise.restart
    let _ = Noise.volume
    let _ = Noise.getType
    let _ = Noise.setType
    let _ = Noise.playbackRate
    let _ = Noise.setPlaybackRate
    let _ = Noise.fadeIn
    let _ = Noise.setFadeIn
    let _ = Noise.fadeOut
    let _ = Noise.setFadeOut
    let _ = Noise.dispose
    let _ = Noise.asAudioNode
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
