open Zekr

let reverbSuite = suite("Reverb", [
  test("bindings type-check", () => {
    let _ = Reverb.make
    let _ = Reverb.makeWithDecay
    let _ = Reverb.makeWithOptions
    let _ = Reverb.decay
    let _ = Reverb.setDecay
    let _ = Reverb.preDelay
    let _ = Reverb.setPreDelay
    let _ = Reverb.wet
    let _ = Reverb.ready
    let _ = Reverb.generate
    let _ = Reverb.dispose
    let _ = Reverb.asAudioNode
    Pass
  }),
])

let feedbackDelaySuite = suite("FeedbackDelay", [
  test("bindings type-check", () => {
    let _ = FeedbackDelay.make
    let _ = FeedbackDelay.makeWithTime
    let _ = FeedbackDelay.makeWithTimeFeedback
    let _ = FeedbackDelay.makeWithOptions
    let _ = FeedbackDelay.delayTime
    let _ = FeedbackDelay.feedback
    let _ = FeedbackDelay.wet
    let _ = FeedbackDelay.dispose
    let _ = FeedbackDelay.asAudioNode
    Pass
  }),
])

let chorusSuite = suite("Chorus", [
  test("bindings type-check", () => {
    let _ = Chorus.make
    let _ = Chorus.makeWithArgs
    let _ = Chorus.makeWithOptions
    let _ = Chorus.frequency
    let _ = Chorus.depth
    let _ = Chorus.setDepth
    let _ = Chorus.delayTime
    let _ = Chorus.setDelayTime
    let _ = Chorus.getType
    let _ = Chorus.setType
    let _ = Chorus.spread
    let _ = Chorus.setSpread
    let _ = Chorus.wet
    let _ = Chorus.start
    let _ = Chorus.stop
    let _ = Chorus.sync
    let _ = Chorus.unsync
    let _ = Chorus.dispose
    let _ = Chorus.asAudioNode
    Pass
  }),
])

let distortionSuite = suite("Distortion", [
  test("bindings type-check", () => {
    let _ = Distortion.make
    let _ = Distortion.makeWithAmount
    let _ = Distortion.makeWithOptions
    let _ = Distortion.distortion
    let _ = Distortion.setDistortion
    let _ = Distortion.oversample
    let _ = Distortion.setOversample
    let _ = Distortion.wet
    let _ = Distortion.dispose
    let _ = Distortion.asAudioNode
    Pass
  }),
])

let autoFilterSuite = suite("AutoFilter", [
  test("bindings type-check", () => {
    let _ = AutoFilter.make
    let _ = AutoFilter.makeWithOptions
    let _ = AutoFilter.frequency
    let _ = AutoFilter.depth
    let _ = AutoFilter.wet
    let _ = AutoFilter.octaves
    let _ = AutoFilter.setOctaves
    let _ = AutoFilter.baseFrequency
    let _ = AutoFilter.setBaseFrequency
    let _ = AutoFilter.start
    let _ = AutoFilter.stop
    let _ = AutoFilter.dispose
    let _ = AutoFilter.asAudioNode
    Pass
  }),
])

let autoPannerSuite = suite("AutoPanner", [
  test("bindings type-check", () => {
    let _ = AutoPanner.make
    let _ = AutoPanner.makeWithOptions
    let _ = AutoPanner.frequency
    let _ = AutoPanner.depth
    let _ = AutoPanner.wet
    let _ = AutoPanner.start
    let _ = AutoPanner.stop
    let _ = AutoPanner.dispose
    let _ = AutoPanner.asAudioNode
    Pass
  }),
])

let autoWahSuite = suite("AutoWah", [
  test("bindings type-check", () => {
    let _ = AutoWah.make
    let _ = AutoWah.makeWithOptions
    let _ = AutoWah.gain
    let _ = AutoWah.q
    let _ = AutoWah.wet
    let _ = AutoWah.octaves
    let _ = AutoWah.setOctaves
    let _ = AutoWah.baseFrequency
    let _ = AutoWah.setBaseFrequency
    let _ = AutoWah.sensitivity
    let _ = AutoWah.setSensitivity
    let _ = AutoWah.dispose
    let _ = AutoWah.asAudioNode
    Pass
  }),
])

let bitCrusherSuite = suite("BitCrusher", [
  test("bindings type-check", () => {
    let _ = BitCrusher.make
    let _ = BitCrusher.makeWithBits
    let _ = BitCrusher.makeWithOptions
    let _ = BitCrusher.bits
    let _ = BitCrusher.wet
    let _ = BitCrusher.dispose
    let _ = BitCrusher.asAudioNode
    Pass
  }),
])

let chebyshevSuite = suite("Chebyshev", [
  test("bindings type-check", () => {
    let _ = Chebyshev.make
    let _ = Chebyshev.makeWithOrder
    let _ = Chebyshev.makeWithOptions
    let _ = Chebyshev.order
    let _ = Chebyshev.setOrder
    let _ = Chebyshev.oversample
    let _ = Chebyshev.setOversample
    let _ = Chebyshev.wet
    let _ = Chebyshev.dispose
    let _ = Chebyshev.asAudioNode
    Pass
  }),
])

let freeverbSuite = suite("Freeverb", [
  test("bindings type-check", () => {
    let _ = Freeverb.make
    let _ = Freeverb.makeWithOptions
    let _ = Freeverb.roomSize
    let _ = Freeverb.dampening
    let _ = Freeverb.wet
    let _ = Freeverb.dispose
    let _ = Freeverb.asAudioNode
    Pass
  }),
])

let jcReverbSuite = suite("JCReverb", [
  test("bindings type-check", () => {
    let _ = JCReverb.make
    let _ = JCReverb.makeWithOptions
    let _ = JCReverb.roomSize
    let _ = JCReverb.wet
    let _ = JCReverb.dispose
    let _ = JCReverb.asAudioNode
    Pass
  }),
])

let phaserSuite = suite("Phaser", [
  test("bindings type-check", () => {
    let _ = Phaser.make
    let _ = Phaser.makeWithOptions
    let _ = Phaser.frequency
    let _ = Phaser.octaves
    let _ = Phaser.setOctaves
    let _ = Phaser.q
    let _ = Phaser.baseFrequency
    let _ = Phaser.setBaseFrequency
    let _ = Phaser.wet
    let _ = Phaser.dispose
    let _ = Phaser.asAudioNode
    Pass
  }),
])

let pingPongDelaySuite = suite("PingPongDelay", [
  test("bindings type-check", () => {
    let _ = PingPongDelay.make
    let _ = PingPongDelay.makeWithTime
    let _ = PingPongDelay.makeWithTimeFeedback
    let _ = PingPongDelay.makeWithOptions
    let _ = PingPongDelay.delayTime
    let _ = PingPongDelay.feedback
    let _ = PingPongDelay.wet
    let _ = PingPongDelay.dispose
    let _ = PingPongDelay.asAudioNode
    Pass
  }),
])

let pitchShiftSuite = suite("PitchShift", [
  test("bindings type-check", () => {
    let _ = PitchShift.make
    let _ = PitchShift.makeWithOptions
    let _ = PitchShift.pitch
    let _ = PitchShift.setPitch
    let _ = PitchShift.windowSize
    let _ = PitchShift.setWindowSize
    let _ = PitchShift.delayTime
    let _ = PitchShift.feedback
    let _ = PitchShift.wet
    let _ = PitchShift.dispose
    let _ = PitchShift.asAudioNode
    Pass
  }),
])

let tremoloSuite = suite("Tremolo", [
  test("bindings type-check", () => {
    let _ = Tremolo.make
    let _ = Tremolo.makeWithOptions
    let _ = Tremolo.frequency
    let _ = Tremolo.depth
    let _ = Tremolo.getType
    let _ = Tremolo.setType
    let _ = Tremolo.spread
    let _ = Tremolo.setSpread
    let _ = Tremolo.wet
    let _ = Tremolo.start
    let _ = Tremolo.stop
    let _ = Tremolo.dispose
    let _ = Tremolo.asAudioNode
    Pass
  }),
])

let vibratoSuite = suite("Vibrato", [
  test("bindings type-check", () => {
    let _ = Vibrato.make
    let _ = Vibrato.makeWithOptions
    let _ = Vibrato.frequency
    let _ = Vibrato.depth
    let _ = Vibrato.getType
    let _ = Vibrato.setType
    let _ = Vibrato.wet
    let _ = Vibrato.dispose
    let _ = Vibrato.asAudioNode
    Pass
  }),
])

let frequencyShifterSuite = suite("FrequencyShifter", [
  test("bindings type-check", () => {
    let _ = FrequencyShifter.make
    let _ = FrequencyShifter.makeWithOptions
    let _ = FrequencyShifter.frequency
    let _ = FrequencyShifter.wet
    let _ = FrequencyShifter.dispose
    let _ = FrequencyShifter.asAudioNode
    Pass
  }),
])

let stereoWidenerSuite = suite("StereoWidener", [
  test("bindings type-check", () => {
    let _ = StereoWidener.make
    let _ = StereoWidener.makeWithOptions
    let _ = StereoWidener.width
    let _ = StereoWidener.wet
    let _ = StereoWidener.dispose
    let _ = StereoWidener.asAudioNode
    Pass
  }),
])

let compressorSuite = suite("Compressor", [
  test("bindings type-check", () => {
    let _ = Compressor.make
    let _ = Compressor.makeWithThreshold
    let _ = Compressor.makeWithThresholdRatio
    let _ = Compressor.makeWithOptions
    let _ = Compressor.threshold
    let _ = Compressor.ratio
    let _ = Compressor.attack
    let _ = Compressor.release
    let _ = Compressor.knee
    let _ = Compressor.reduction
    let _ = Compressor.dispose
    let _ = Compressor.asAudioNode
    Pass
  }),
])

let limiterSuite = suite("Limiter", [
  test("bindings type-check", () => {
    let _ = Limiter.make
    let _ = Limiter.makeWithThreshold
    let _ = Limiter.makeWithOptions
    let _ = Limiter.threshold
    let _ = Limiter.reduction
    let _ = Limiter.dispose
    let _ = Limiter.asAudioNode
    Pass
  }),
])

let gateSuite = suite("Gate", [
  test("bindings type-check", () => {
    let _ = Gate.make
    let _ = Gate.makeWithThreshold
    let _ = Gate.makeWithOptions
    let _ = Gate.threshold
    let _ = Gate.smoothing
    let _ = Gate.setSmoothing
    let _ = Gate.dispose
    let _ = Gate.asAudioNode
    Pass
  }),
])

let filterSuite = suite("Filter", [
  test("bindings type-check", () => {
    let _ = Filter.make
    let _ = Filter.makeWithFreq
    let _ = Filter.makeWithOptions
    let _ = Filter.frequency
    let _ = Filter.q
    let _ = Filter.gain
    let _ = Filter.detune
    let _ = Filter.getType
    let _ = Filter.setType
    let _ = Filter.rolloff
    let _ = Filter.setRolloff
    let _ = Filter.getFrequencyResponse
    let _ = Filter.dispose
    let _ = Filter.asAudioNode
    Pass
  }),
])

let eq3Suite = suite("EQ3", [
  test("bindings type-check", () => {
    let _ = EQ3.make
    let _ = EQ3.makeWithOptions
    let _ = EQ3.low
    let _ = EQ3.mid
    let _ = EQ3.high
    let _ = EQ3.lowFrequency
    let _ = EQ3.highFrequency
    let _ = EQ3.dispose
    let _ = EQ3.asAudioNode
    Pass
  }),
])

let pannerSuite = suite("Panner", [
  test("bindings type-check", () => {
    let _ = Panner.make
    let _ = Panner.makeWithPan
    let _ = Panner.makeWithOptions
    let _ = Panner.pan
    let _ = Panner.dispose
    let _ = Panner.asAudioNode
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
