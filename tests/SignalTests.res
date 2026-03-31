open Zekr

let signalSuite = suite("Signal", [
  test("bindings type-check", () => {
    let _ = ToneJs_Signal.make
    let _ = ToneJs_Signal.makeWithValue
    let _ = ToneJs_Signal.makeWithOptions
    let _ = ToneJs_Signal.getValue
    let _ = ToneJs_Signal.setValue
    let _ = ToneJs_Signal.overridden
    let _ = ToneJs_Signal.setOverridden
    let _ = ToneJs_Signal.maxValue
    let _ = ToneJs_Signal.minValue
    let _ = ToneJs_Signal.units
    let _ = ToneJs_Signal.convert
    let _ = ToneJs_Signal.setConvert
    let _ = ToneJs_Signal.setValueAtTime
    let _ = ToneJs_Signal.getValueAtTime
    let _ = ToneJs_Signal.linearRampToValueAtTime
    let _ = ToneJs_Signal.exponentialRampToValueAtTime
    let _ = ToneJs_Signal.linearRampTo
    let _ = ToneJs_Signal.exponentialRampTo
    let _ = ToneJs_Signal.targetRampTo
    let _ = ToneJs_Signal.rampTo
    let _ = ToneJs_Signal.setRampPoint
    let _ = ToneJs_Signal.setTargetAtTime
    let _ = ToneJs_Signal.cancelScheduledValues
    let _ = ToneJs_Signal.cancelAndHoldAtTime
    let _ = ToneJs_Signal.connect
    let _ = ToneJs_Signal.dispose
    let _ = ToneJs_Signal.asAudioNode
    let _ = ToneJs_Signal.asParam
    Pass
  }),
])

let volumeSuite = suite("Volume", [
  test("bindings type-check", () => {
    let _ = ToneJs_Volume.make
    let _ = ToneJs_Volume.makeWithVolume
    let _ = ToneJs_Volume.makeWithOptions
    let _ = ToneJs_Volume.volume
    let _ = ToneJs_Volume.mute
    let _ = ToneJs_Volume.setMute
    let _ = ToneJs_Volume.dispose
    let _ = ToneJs_Volume.asAudioNode
    Pass
  }),
])

let gainSuite = suite("Gain", [
  test("bindings type-check", () => {
    let _ = ToneJs_Gain.make
    let _ = ToneJs_Gain.makeWithGain
    let _ = ToneJs_Gain.makeWithOptions
    let _ = ToneJs_Gain.gain
    let _ = ToneJs_Gain.dispose
    let _ = ToneJs_Gain.asAudioNode
    Pass
  }),
])

let channelSuite = suite("Channel", [
  test("bindings type-check", () => {
    let _ = ToneJs_Channel.make
    let _ = ToneJs_Channel.makeWithVolume
    let _ = ToneJs_Channel.makeWithVolumePan
    let _ = ToneJs_Channel.makeWithOptions
    let _ = ToneJs_Channel.pan
    let _ = ToneJs_Channel.volume
    let _ = ToneJs_Channel.solo
    let _ = ToneJs_Channel.setSolo
    let _ = ToneJs_Channel.mute
    let _ = ToneJs_Channel.setMute
    let _ = ToneJs_Channel.muted
    let _ = ToneJs_Channel.send
    let _ = ToneJs_Channel.sendWithVolume
    let _ = ToneJs_Channel.receive
    let _ = ToneJs_Channel.dispose
    let _ = ToneJs_Channel.asAudioNode
    Pass
  }),
])

let crossFadeSuite = suite("CrossFade", [
  test("bindings type-check", () => {
    let _ = ToneJs_CrossFade.make
    let _ = ToneJs_CrossFade.makeWithFade
    let _ = ToneJs_CrossFade.makeWithOptions
    let _ = ToneJs_CrossFade.fade
    let _ = ToneJs_CrossFade.a
    let _ = ToneJs_CrossFade.b
    let _ = ToneJs_CrossFade.dispose
    let _ = ToneJs_CrossFade.asAudioNode
    Pass
  }),
])

let suites = [signalSuite, volumeSuite, gainSuite, channelSuite, crossFadeSuite]
