open Zekr

let loopSuite = suite("Loop", [
  test("bindings type-check", () => {
    let _ = Loop.make
    let _ = Loop.makeWithOptions
    let _ = Loop.start
    let _ = Loop.stop
    let _ = Loop.cancel
    let _ = Loop.dispose
    let _ = Loop.state
    let _ = Loop.progress
    let _ = Loop.interval
    let _ = Loop.setInterval
    let _ = Loop.playbackRate
    let _ = Loop.setPlaybackRate
    let _ = Loop.humanize
    let _ = Loop.setHumanize
    let _ = Loop.probability
    let _ = Loop.setProbability
    let _ = Loop.mute
    let _ = Loop.setMute
    let _ = Loop.iterations
    let _ = Loop.setIterations
    let _ = Loop.callback
    let _ = Loop.setCallback
    Pass
  }),
])

let eventSuite = suite("Event", [
  test("bindings type-check", () => {
    let _ = Event.make
    let _ = Event.start
    let _ = Event.stop
    let _ = Event.cancel
    let _ = Event.dispose
    let _ = Event.state
    let _ = Event.progress
    let _ = Event.loop
    let _ = Event.setLoop
    let _ = Event.loopEnd
    let _ = Event.setLoopEnd
    let _ = Event.loopStart
    let _ = Event.setLoopStart
    let _ = Event.playbackRate
    let _ = Event.setPlaybackRate
    let _ = Event.probability
    let _ = Event.setProbability
    let _ = Event.mute
    let _ = Event.setMute
    let _ = Event.humanize
    let _ = Event.setHumanize
    Pass
  }),
])

let partSuite = suite("Part", [
  test("bindings type-check", () => {
    let _ = Part.make
    let _ = Part.start
    let _ = Part.startWithOffset
    let _ = Part.stop
    let _ = Part.cancel
    let _ = Part.clear
    let _ = Part.dispose
    let _ = Part.add
    let _ = Part.remove
    let _ = Part.at
    let _ = Part.state
    let _ = Part.progress
    let _ = Part.length
    let _ = Part.loop
    let _ = Part.setLoop
    let _ = Part.setLoopCount
    let _ = Part.loopEnd
    let _ = Part.setLoopEnd
    let _ = Part.loopStart
    let _ = Part.setLoopStart
    let _ = Part.playbackRate
    let _ = Part.setPlaybackRate
    let _ = Part.probability
    let _ = Part.setProbability
    let _ = Part.mute
    let _ = Part.setMute
    let _ = Part.humanize
    let _ = Part.setHumanize
    Pass
  }),
])

let sequenceSuite = suite("Sequence", [
  test("bindings type-check", () => {
    let _ = Sequence.make
    let _ = Sequence.makeWithSubdivision
    let _ = Sequence.start
    let _ = Sequence.startWithOffset
    let _ = Sequence.stop
    let _ = Sequence.clear
    let _ = Sequence.dispose
    let _ = Sequence.events
    let _ = Sequence.setEvents
    let _ = Sequence.subdivision
    let _ = Sequence.state
    let _ = Sequence.progress
    let _ = Sequence.length
    let _ = Sequence.loop
    let _ = Sequence.setLoop
    let _ = Sequence.setLoopCount
    let _ = Sequence.loopEnd
    let _ = Sequence.setLoopEnd
    let _ = Sequence.loopStart
    let _ = Sequence.setLoopStart
    let _ = Sequence.playbackRate
    let _ = Sequence.setPlaybackRate
    let _ = Sequence.probability
    let _ = Sequence.setProbability
    let _ = Sequence.mute
    let _ = Sequence.setMute
    let _ = Sequence.humanize
    let _ = Sequence.setHumanize
    Pass
  }),
])

let suites = [loopSuite, eventSuite, partSuite, sequenceSuite]
