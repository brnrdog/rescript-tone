open Types
open Zekr

// Note: Tone.js has limited functionality in Node.js (no AudioContext).
// These tests verify binding correctness for what works in Node.js.
// Full integration tests require a browser environment.

let toneModuleSuite = suite("Tone Module", [
  test("version is a non-empty string", () => {
    let v = Core.version
    assertTrue(String.length(v) > 0)
  }),
  test("now() returns a non-negative number", () => {
    let t = Core.now()
    assertTrue(t >= 0.0)
  }),
  test("immediate() returns a non-negative number", () => {
    let t = Core.immediate()
    assertTrue(t >= 0.0)
  }),
  test("getContext returns a context object", () => {
    let ctx = Core.getContext()
    let t = Context.now(ctx)
    assertTrue(t >= 0.0)
  }),
  test("getTransport returns a transport object", () => {
    let _transport = Core.getTransport()
    Pass
  }),
  test("getDestination returns a destination object", () => {
    let _dest = Core.getDestination()
    Pass
  }),
])

let contextSuite = suite("Context", [
  test("now() returns a non-negative time", () => {
    let ctx = Core.getContext()
    let t = Context.now(ctx)
    assertTrue(t >= 0.0)
  }),
  test("immediate() returns a non-negative time", () => {
    let ctx = Core.getContext()
    let t = Context.immediate(ctx)
    assertTrue(t >= 0.0)
  }),
  test("currentTime is non-negative", () => {
    let ctx = Core.getContext()
    let t = Context.currentTime(ctx)
    assertTrue(t >= 0.0)
  }),
  test("lookAhead can be get and set", () => {
    let ctx = Core.getContext()
    let original = Context.lookAhead(ctx)
    Context.setLookAhead(ctx, 0.2)
    let updated = Context.lookAhead(ctx)
    Context.setLookAhead(ctx, original)
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
    let _ = Param.getValue
    let _ = Param.setValue
    let _ = Param.rampTo
    let _ = Param.linearRampTo
    let _ = Param.exponentialRampTo
    let _ = Param.cancelScheduledValues
    Pass
  }),
])

let audioNodeSuite = suite("AudioNode", [
  test("AudioNode bindings compile correctly", () => {
    let _ = AudioNode.connect
    let _ = AudioNode.disconnect
    let _ = AudioNode.toDestination
    let _ = AudioNode.dispose
    let _ = AudioNode.chain
    let _ = AudioNode.fan
    let _ = AudioNode.numberOfInputs
    let _ = AudioNode.numberOfOutputs
    Pass
  }),
])

let transportSuite = suite("Transport", [
  test("Transport bindings compile correctly", () => {
    let _ = Transport.start
    let _ = Transport.stop
    let _ = Transport.pause
    let _ = Transport.toggle
    let _ = Transport.schedule
    let _ = Transport.scheduleRepeat
    let _ = Transport.scheduleOnce
    let _ = Transport.clear
    let _ = Transport.cancel
    let _ = Transport.bpm
    let _ = Transport.position
    let _ = Transport.setPosition
    let _ = Transport.loop
    let _ = Transport.setLoop
    let _ = Transport.state
    let _ = Transport.ppq
    Pass
  }),
])

let destinationSuite = suite("Destination", [
  test("Destination bindings compile correctly", () => {
    let _ = Destination.volume
    let _ = Destination.mute
    let _ = Destination.setMute
    let _ = Destination.maxChannelCount
    let _ = Destination.dispose
    let _ = Destination.asAudioNode
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
