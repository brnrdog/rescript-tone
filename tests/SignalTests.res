open Zekr

let signalSuite = suite("Signal", [
  test("bindings type-check", () => {
    let _ = Signal.make
    let _ = Signal.makeWithValue
    let _ = Signal.makeWithOptions
    let _ = Signal.getValue
    let _ = Signal.setValue
    let _ = Signal.overridden
    let _ = Signal.setOverridden
    let _ = Signal.maxValue
    let _ = Signal.minValue
    let _ = Signal.units
    let _ = Signal.convert
    let _ = Signal.setConvert
    let _ = Signal.setValueAtTime
    let _ = Signal.getValueAtTime
    let _ = Signal.linearRampToValueAtTime
    let _ = Signal.exponentialRampToValueAtTime
    let _ = Signal.linearRampTo
    let _ = Signal.exponentialRampTo
    let _ = Signal.targetRampTo
    let _ = Signal.rampTo
    let _ = Signal.setRampPoint
    let _ = Signal.setTargetAtTime
    let _ = Signal.cancelScheduledValues
    let _ = Signal.cancelAndHoldAtTime
    let _ = Signal.connect
    let _ = Signal.dispose
    let _ = Signal.asAudioNode
    let _ = Signal.asParam
    Pass
  }),
])

let volumeSuite = suite("Volume", [
  test("bindings type-check", () => {
    let _ = Volume.make
    let _ = Volume.makeWithVolume
    let _ = Volume.makeWithOptions
    let _ = Volume.volume
    let _ = Volume.mute
    let _ = Volume.setMute
    let _ = Volume.dispose
    let _ = Volume.asAudioNode
    Pass
  }),
])

let gainSuite = suite("Gain", [
  test("bindings type-check", () => {
    let _ = Gain.make
    let _ = Gain.makeWithGain
    let _ = Gain.makeWithOptions
    let _ = Gain.gain
    let _ = Gain.dispose
    let _ = Gain.asAudioNode
    Pass
  }),
])

let channelSuite = suite("Channel", [
  test("bindings type-check", () => {
    let _ = Channel.make
    let _ = Channel.makeWithVolume
    let _ = Channel.makeWithVolumePan
    let _ = Channel.makeWithOptions
    let _ = Channel.pan
    let _ = Channel.volume
    let _ = Channel.solo
    let _ = Channel.setSolo
    let _ = Channel.mute
    let _ = Channel.setMute
    let _ = Channel.muted
    let _ = Channel.send
    let _ = Channel.sendWithVolume
    let _ = Channel.receive
    let _ = Channel.dispose
    let _ = Channel.asAudioNode
    Pass
  }),
])

let crossFadeSuite = suite("CrossFade", [
  test("bindings type-check", () => {
    let _ = CrossFade.make
    let _ = CrossFade.makeWithFade
    let _ = CrossFade.makeWithOptions
    let _ = CrossFade.fade
    let _ = CrossFade.a
    let _ = CrossFade.b
    let _ = CrossFade.dispose
    let _ = CrossFade.asAudioNode
    Pass
  }),
])

let suites = [signalSuite, volumeSuite, gainSuite, channelSuite, crossFadeSuite]
