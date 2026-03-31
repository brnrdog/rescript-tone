open ToneJs_Types
open Zekr

// Note: Tone.js has limited functionality in Node.js (no AudioContext).
// These tests verify binding correctness for what works in Node.js.
// Full integration tests require a browser environment.

let toneModuleSuite = suite("Tone Module", [
  test("version is a non-empty string", () => {
    let v = ToneJs_Tone.version
    assertTrue(String.length(v) > 0)
  }),
  test("now() returns a non-negative number", () => {
    let t = ToneJs_Tone.now()
    assertTrue(t >= 0.0)
  }),
  test("immediate() returns a non-negative number", () => {
    let t = ToneJs_Tone.immediate()
    assertTrue(t >= 0.0)
  }),
  test("getContext returns a context object", () => {
    let ctx = ToneJs_Tone.getContext()
    let t = ToneJs_Context.now(ctx)
    assertTrue(t >= 0.0)
  }),
  test("getTransport returns a transport object", () => {
    let _transport = ToneJs_Tone.getTransport()
    Pass
  }),
  test("getDestination returns a destination object", () => {
    let _dest = ToneJs_Tone.getDestination()
    Pass
  }),
])

let contextSuite = suite("Context", [
  test("now() returns a non-negative time", () => {
    let ctx = ToneJs_Tone.getContext()
    let t = ToneJs_Context.now(ctx)
    assertTrue(t >= 0.0)
  }),
  test("immediate() returns a non-negative time", () => {
    let ctx = ToneJs_Tone.getContext()
    let t = ToneJs_Context.immediate(ctx)
    assertTrue(t >= 0.0)
  }),
  test("currentTime is non-negative", () => {
    let ctx = ToneJs_Tone.getContext()
    let t = ToneJs_Context.currentTime(ctx)
    assertTrue(t >= 0.0)
  }),
  test("lookAhead can be get and set", () => {
    let ctx = ToneJs_Tone.getContext()
    let original = ToneJs_Context.lookAhead(ctx)
    ToneJs_Context.setLookAhead(ctx, 0.2)
    let updated = ToneJs_Context.lookAhead(ctx)
    ToneJs_Context.setLookAhead(ctx, original)
    assertTrue(updated == 0.2)
  }),
])

let timeTypesSuite = suite("Time Types", [
  test("Time.seconds creates a time from float", () => {
    let t = Time.seconds(1.5)
    assertEqual(Time.toFloat(t), 1.5)
  }),
  test("Time.notation creates a time from string", () => {
    let _t = Time.notation("4n")
    Pass
  }),
  test("Frequency.hz creates a frequency", () => {
    let f = Frequency.hz(440.0)
    assertTrue(f == 440.0)
  }),
])

let paramSuite = suite("Param", [
  test("Param bindings compile correctly", () => {
    // Verify the binding types are correct at compile time
    // Param methods require a real AudioContext to test at runtime
    let _ = ToneJs_Param.getValue
    let _ = ToneJs_Param.setValue
    let _ = ToneJs_Param.rampTo
    let _ = ToneJs_Param.linearRampTo
    let _ = ToneJs_Param.exponentialRampTo
    let _ = ToneJs_Param.cancelScheduledValues
    Pass
  }),
])

let audioNodeSuite = suite("AudioNode", [
  test("AudioNode bindings compile correctly", () => {
    let _ = ToneJs_AudioNode.connect
    let _ = ToneJs_AudioNode.disconnect
    let _ = ToneJs_AudioNode.toDestination
    let _ = ToneJs_AudioNode.dispose
    let _ = ToneJs_AudioNode.chain
    let _ = ToneJs_AudioNode.fan
    let _ = ToneJs_AudioNode.numberOfInputs
    let _ = ToneJs_AudioNode.numberOfOutputs
    Pass
  }),
])

let transportSuite = suite("Transport", [
  test("Transport bindings compile correctly", () => {
    let _ = ToneJs_Transport.start
    let _ = ToneJs_Transport.stop
    let _ = ToneJs_Transport.pause
    let _ = ToneJs_Transport.toggle
    let _ = ToneJs_Transport.schedule
    let _ = ToneJs_Transport.scheduleRepeat
    let _ = ToneJs_Transport.scheduleOnce
    let _ = ToneJs_Transport.clear
    let _ = ToneJs_Transport.cancel
    let _ = ToneJs_Transport.bpm
    let _ = ToneJs_Transport.position
    let _ = ToneJs_Transport.setPosition
    let _ = ToneJs_Transport.loop
    let _ = ToneJs_Transport.setLoop
    let _ = ToneJs_Transport.state
    let _ = ToneJs_Transport.ppq
    Pass
  }),
])

let destinationSuite = suite("Destination", [
  test("Destination bindings compile correctly", () => {
    let _ = ToneJs_Destination.volume
    let _ = ToneJs_Destination.mute
    let _ = ToneJs_Destination.setMute
    let _ = ToneJs_Destination.maxChannelCount
    let _ = ToneJs_Destination.dispose
    let _ = ToneJs_Destination.asAudioNode
    Pass
  }),
])

let suites = [
  toneModuleSuite,
  contextSuite,
  timeTypesSuite,
  paramSuite,
  audioNodeSuite,
  transportSuite,
  destinationSuite,
]
