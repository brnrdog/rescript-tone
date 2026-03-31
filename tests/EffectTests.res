open Zekr

let reverbSuite = suite("Reverb", [
  test("bindings type-check", () => {
    let _ = ToneJs_Reverb.make
    let _ = ToneJs_Reverb.makeWithDecay
    let _ = ToneJs_Reverb.makeWithOptions
    let _ = ToneJs_Reverb.decay
    let _ = ToneJs_Reverb.setDecay
    let _ = ToneJs_Reverb.preDelay
    let _ = ToneJs_Reverb.setPreDelay
    let _ = ToneJs_Reverb.wet
    let _ = ToneJs_Reverb.ready
    let _ = ToneJs_Reverb.generate
    let _ = ToneJs_Reverb.dispose
    let _ = ToneJs_Reverb.asAudioNode
    Pass
  }),
])

let feedbackDelaySuite = suite("FeedbackDelay", [
  test("bindings type-check", () => {
    let _ = ToneJs_FeedbackDelay.make
    let _ = ToneJs_FeedbackDelay.makeWithTime
    let _ = ToneJs_FeedbackDelay.makeWithTimeFeedback
    let _ = ToneJs_FeedbackDelay.makeWithOptions
    let _ = ToneJs_FeedbackDelay.delayTime
    let _ = ToneJs_FeedbackDelay.feedback
    let _ = ToneJs_FeedbackDelay.wet
    let _ = ToneJs_FeedbackDelay.dispose
    let _ = ToneJs_FeedbackDelay.asAudioNode
    Pass
  }),
])

let chorusSuite = suite("Chorus", [
  test("bindings type-check", () => {
    let _ = ToneJs_Chorus.make
    let _ = ToneJs_Chorus.makeWithArgs
    let _ = ToneJs_Chorus.makeWithOptions
    let _ = ToneJs_Chorus.frequency
    let _ = ToneJs_Chorus.depth
    let _ = ToneJs_Chorus.setDepth
    let _ = ToneJs_Chorus.delayTime
    let _ = ToneJs_Chorus.setDelayTime
    let _ = ToneJs_Chorus.getType
    let _ = ToneJs_Chorus.setType
    let _ = ToneJs_Chorus.spread
    let _ = ToneJs_Chorus.setSpread
    let _ = ToneJs_Chorus.wet
    let _ = ToneJs_Chorus.start
    let _ = ToneJs_Chorus.stop
    let _ = ToneJs_Chorus.sync
    let _ = ToneJs_Chorus.unsync
    let _ = ToneJs_Chorus.dispose
    let _ = ToneJs_Chorus.asAudioNode
    Pass
  }),
])

let distortionSuite = suite("Distortion", [
  test("bindings type-check", () => {
    let _ = ToneJs_Distortion.make
    let _ = ToneJs_Distortion.makeWithAmount
    let _ = ToneJs_Distortion.makeWithOptions
    let _ = ToneJs_Distortion.distortion
    let _ = ToneJs_Distortion.setDistortion
    let _ = ToneJs_Distortion.oversample
    let _ = ToneJs_Distortion.setOversample
    let _ = ToneJs_Distortion.wet
    let _ = ToneJs_Distortion.dispose
    let _ = ToneJs_Distortion.asAudioNode
    Pass
  }),
])

let autoFilterSuite = suite("AutoFilter", [
  test("bindings type-check", () => {
    let _ = ToneJs_AutoFilter.make
    let _ = ToneJs_AutoFilter.makeWithOptions
    let _ = ToneJs_AutoFilter.frequency
    let _ = ToneJs_AutoFilter.depth
    let _ = ToneJs_AutoFilter.wet
    let _ = ToneJs_AutoFilter.octaves
    let _ = ToneJs_AutoFilter.setOctaves
    let _ = ToneJs_AutoFilter.baseFrequency
    let _ = ToneJs_AutoFilter.setBaseFrequency
    let _ = ToneJs_AutoFilter.start
    let _ = ToneJs_AutoFilter.stop
    let _ = ToneJs_AutoFilter.dispose
    let _ = ToneJs_AutoFilter.asAudioNode
    Pass
  }),
])

let autoPannerSuite = suite("AutoPanner", [
  test("bindings type-check", () => {
    let _ = ToneJs_AutoPanner.make
    let _ = ToneJs_AutoPanner.makeWithOptions
    let _ = ToneJs_AutoPanner.frequency
    let _ = ToneJs_AutoPanner.depth
    let _ = ToneJs_AutoPanner.wet
    let _ = ToneJs_AutoPanner.start
    let _ = ToneJs_AutoPanner.stop
    let _ = ToneJs_AutoPanner.dispose
    let _ = ToneJs_AutoPanner.asAudioNode
    Pass
  }),
])

let autoWahSuite = suite("AutoWah", [
  test("bindings type-check", () => {
    let _ = ToneJs_AutoWah.make
    let _ = ToneJs_AutoWah.makeWithOptions
    let _ = ToneJs_AutoWah.gain
    let _ = ToneJs_AutoWah.q
    let _ = ToneJs_AutoWah.wet
    let _ = ToneJs_AutoWah.octaves
    let _ = ToneJs_AutoWah.setOctaves
    let _ = ToneJs_AutoWah.baseFrequency
    let _ = ToneJs_AutoWah.setBaseFrequency
    let _ = ToneJs_AutoWah.sensitivity
    let _ = ToneJs_AutoWah.setSensitivity
    let _ = ToneJs_AutoWah.dispose
    let _ = ToneJs_AutoWah.asAudioNode
    Pass
  }),
])

let bitCrusherSuite = suite("BitCrusher", [
  test("bindings type-check", () => {
    let _ = ToneJs_BitCrusher.make
    let _ = ToneJs_BitCrusher.makeWithBits
    let _ = ToneJs_BitCrusher.makeWithOptions
    let _ = ToneJs_BitCrusher.bits
    let _ = ToneJs_BitCrusher.wet
    let _ = ToneJs_BitCrusher.dispose
    let _ = ToneJs_BitCrusher.asAudioNode
    Pass
  }),
])

let chebyshevSuite = suite("Chebyshev", [
  test("bindings type-check", () => {
    let _ = ToneJs_Chebyshev.make
    let _ = ToneJs_Chebyshev.makeWithOrder
    let _ = ToneJs_Chebyshev.makeWithOptions
    let _ = ToneJs_Chebyshev.order
    let _ = ToneJs_Chebyshev.setOrder
    let _ = ToneJs_Chebyshev.oversample
    let _ = ToneJs_Chebyshev.setOversample
    let _ = ToneJs_Chebyshev.wet
    let _ = ToneJs_Chebyshev.dispose
    let _ = ToneJs_Chebyshev.asAudioNode
    Pass
  }),
])

let freeverbSuite = suite("Freeverb", [
  test("bindings type-check", () => {
    let _ = ToneJs_Freeverb.make
    let _ = ToneJs_Freeverb.makeWithOptions
    let _ = ToneJs_Freeverb.roomSize
    let _ = ToneJs_Freeverb.dampening
    let _ = ToneJs_Freeverb.wet
    let _ = ToneJs_Freeverb.dispose
    let _ = ToneJs_Freeverb.asAudioNode
    Pass
  }),
])

let jcReverbSuite = suite("JCReverb", [
  test("bindings type-check", () => {
    let _ = ToneJs_JCReverb.make
    let _ = ToneJs_JCReverb.makeWithOptions
    let _ = ToneJs_JCReverb.roomSize
    let _ = ToneJs_JCReverb.wet
    let _ = ToneJs_JCReverb.dispose
    let _ = ToneJs_JCReverb.asAudioNode
    Pass
  }),
])

let phaserSuite = suite("Phaser", [
  test("bindings type-check", () => {
    let _ = ToneJs_Phaser.make
    let _ = ToneJs_Phaser.makeWithOptions
    let _ = ToneJs_Phaser.frequency
    let _ = ToneJs_Phaser.octaves
    let _ = ToneJs_Phaser.setOctaves
    let _ = ToneJs_Phaser.q
    let _ = ToneJs_Phaser.baseFrequency
    let _ = ToneJs_Phaser.setBaseFrequency
    let _ = ToneJs_Phaser.wet
    let _ = ToneJs_Phaser.dispose
    let _ = ToneJs_Phaser.asAudioNode
    Pass
  }),
])

let pingPongDelaySuite = suite("PingPongDelay", [
  test("bindings type-check", () => {
    let _ = ToneJs_PingPongDelay.make
    let _ = ToneJs_PingPongDelay.makeWithTime
    let _ = ToneJs_PingPongDelay.makeWithTimeFeedback
    let _ = ToneJs_PingPongDelay.makeWithOptions
    let _ = ToneJs_PingPongDelay.delayTime
    let _ = ToneJs_PingPongDelay.feedback
    let _ = ToneJs_PingPongDelay.wet
    let _ = ToneJs_PingPongDelay.dispose
    let _ = ToneJs_PingPongDelay.asAudioNode
    Pass
  }),
])

let pitchShiftSuite = suite("PitchShift", [
  test("bindings type-check", () => {
    let _ = ToneJs_PitchShift.make
    let _ = ToneJs_PitchShift.makeWithOptions
    let _ = ToneJs_PitchShift.pitch
    let _ = ToneJs_PitchShift.setPitch
    let _ = ToneJs_PitchShift.windowSize
    let _ = ToneJs_PitchShift.setWindowSize
    let _ = ToneJs_PitchShift.delayTime
    let _ = ToneJs_PitchShift.feedback
    let _ = ToneJs_PitchShift.wet
    let _ = ToneJs_PitchShift.dispose
    let _ = ToneJs_PitchShift.asAudioNode
    Pass
  }),
])

let tremoloSuite = suite("Tremolo", [
  test("bindings type-check", () => {
    let _ = ToneJs_Tremolo.make
    let _ = ToneJs_Tremolo.makeWithOptions
    let _ = ToneJs_Tremolo.frequency
    let _ = ToneJs_Tremolo.depth
    let _ = ToneJs_Tremolo.getType
    let _ = ToneJs_Tremolo.setType
    let _ = ToneJs_Tremolo.spread
    let _ = ToneJs_Tremolo.setSpread
    let _ = ToneJs_Tremolo.wet
    let _ = ToneJs_Tremolo.start
    let _ = ToneJs_Tremolo.stop
    let _ = ToneJs_Tremolo.dispose
    let _ = ToneJs_Tremolo.asAudioNode
    Pass
  }),
])

let vibratoSuite = suite("Vibrato", [
  test("bindings type-check", () => {
    let _ = ToneJs_Vibrato.make
    let _ = ToneJs_Vibrato.makeWithOptions
    let _ = ToneJs_Vibrato.frequency
    let _ = ToneJs_Vibrato.depth
    let _ = ToneJs_Vibrato.getType
    let _ = ToneJs_Vibrato.setType
    let _ = ToneJs_Vibrato.wet
    let _ = ToneJs_Vibrato.dispose
    let _ = ToneJs_Vibrato.asAudioNode
    Pass
  }),
])

let frequencyShifterSuite = suite("FrequencyShifter", [
  test("bindings type-check", () => {
    let _ = ToneJs_FrequencyShifter.make
    let _ = ToneJs_FrequencyShifter.makeWithOptions
    let _ = ToneJs_FrequencyShifter.frequency
    let _ = ToneJs_FrequencyShifter.wet
    let _ = ToneJs_FrequencyShifter.dispose
    let _ = ToneJs_FrequencyShifter.asAudioNode
    Pass
  }),
])

let stereoWidenerSuite = suite("StereoWidener", [
  test("bindings type-check", () => {
    let _ = ToneJs_StereoWidener.make
    let _ = ToneJs_StereoWidener.makeWithOptions
    let _ = ToneJs_StereoWidener.width
    let _ = ToneJs_StereoWidener.wet
    let _ = ToneJs_StereoWidener.dispose
    let _ = ToneJs_StereoWidener.asAudioNode
    Pass
  }),
])

let compressorSuite = suite("Compressor", [
  test("bindings type-check", () => {
    let _ = ToneJs_Compressor.make
    let _ = ToneJs_Compressor.makeWithThreshold
    let _ = ToneJs_Compressor.makeWithThresholdRatio
    let _ = ToneJs_Compressor.makeWithOptions
    let _ = ToneJs_Compressor.threshold
    let _ = ToneJs_Compressor.ratio
    let _ = ToneJs_Compressor.attack
    let _ = ToneJs_Compressor.release
    let _ = ToneJs_Compressor.knee
    let _ = ToneJs_Compressor.reduction
    let _ = ToneJs_Compressor.dispose
    let _ = ToneJs_Compressor.asAudioNode
    Pass
  }),
])

let limiterSuite = suite("Limiter", [
  test("bindings type-check", () => {
    let _ = ToneJs_Limiter.make
    let _ = ToneJs_Limiter.makeWithThreshold
    let _ = ToneJs_Limiter.makeWithOptions
    let _ = ToneJs_Limiter.threshold
    let _ = ToneJs_Limiter.reduction
    let _ = ToneJs_Limiter.dispose
    let _ = ToneJs_Limiter.asAudioNode
    Pass
  }),
])

let gateSuite = suite("Gate", [
  test("bindings type-check", () => {
    let _ = ToneJs_Gate.make
    let _ = ToneJs_Gate.makeWithThreshold
    let _ = ToneJs_Gate.makeWithOptions
    let _ = ToneJs_Gate.threshold
    let _ = ToneJs_Gate.smoothing
    let _ = ToneJs_Gate.setSmoothing
    let _ = ToneJs_Gate.dispose
    let _ = ToneJs_Gate.asAudioNode
    Pass
  }),
])

let filterSuite = suite("Filter", [
  test("bindings type-check", () => {
    let _ = ToneJs_Filter.make
    let _ = ToneJs_Filter.makeWithFreq
    let _ = ToneJs_Filter.makeWithOptions
    let _ = ToneJs_Filter.frequency
    let _ = ToneJs_Filter.q
    let _ = ToneJs_Filter.gain
    let _ = ToneJs_Filter.detune
    let _ = ToneJs_Filter.getType
    let _ = ToneJs_Filter.setType
    let _ = ToneJs_Filter.rolloff
    let _ = ToneJs_Filter.setRolloff
    let _ = ToneJs_Filter.getFrequencyResponse
    let _ = ToneJs_Filter.dispose
    let _ = ToneJs_Filter.asAudioNode
    Pass
  }),
])

let eq3Suite = suite("EQ3", [
  test("bindings type-check", () => {
    let _ = ToneJs_EQ3.make
    let _ = ToneJs_EQ3.makeWithOptions
    let _ = ToneJs_EQ3.low
    let _ = ToneJs_EQ3.mid
    let _ = ToneJs_EQ3.high
    let _ = ToneJs_EQ3.lowFrequency
    let _ = ToneJs_EQ3.highFrequency
    let _ = ToneJs_EQ3.dispose
    let _ = ToneJs_EQ3.asAudioNode
    Pass
  }),
])

let pannerSuite = suite("Panner", [
  test("bindings type-check", () => {
    let _ = ToneJs_Panner.make
    let _ = ToneJs_Panner.makeWithPan
    let _ = ToneJs_Panner.makeWithOptions
    let _ = ToneJs_Panner.pan
    let _ = ToneJs_Panner.dispose
    let _ = ToneJs_Panner.asAudioNode
    Pass
  }),
])

let suites = [
  reverbSuite,
  feedbackDelaySuite,
  chorusSuite,
  distortionSuite,
  autoFilterSuite,
  autoPannerSuite,
  autoWahSuite,
  bitCrusherSuite,
  chebyshevSuite,
  freeverbSuite,
  jcReverbSuite,
  phaserSuite,
  pingPongDelaySuite,
  pitchShiftSuite,
  tremoloSuite,
  vibratoSuite,
  frequencyShifterSuite,
  stereoWidenerSuite,
  compressorSuite,
  limiterSuite,
  gateSuite,
  filterSuite,
  eq3Suite,
  pannerSuite,
]
