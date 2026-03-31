open Zekr

let loopSuite = suite("Loop", [
  test("bindings type-check", () => {
    let _ = ToneJs_Loop.make
    let _ = ToneJs_Loop.makeWithOptions
    let _ = ToneJs_Loop.start
    let _ = ToneJs_Loop.stop
    let _ = ToneJs_Loop.cancel
    let _ = ToneJs_Loop.dispose
    let _ = ToneJs_Loop.state
    let _ = ToneJs_Loop.progress
    let _ = ToneJs_Loop.interval
    let _ = ToneJs_Loop.setInterval
    let _ = ToneJs_Loop.playbackRate
    let _ = ToneJs_Loop.setPlaybackRate
    let _ = ToneJs_Loop.humanize
    let _ = ToneJs_Loop.setHumanize
    let _ = ToneJs_Loop.probability
    let _ = ToneJs_Loop.setProbability
    let _ = ToneJs_Loop.mute
    let _ = ToneJs_Loop.setMute
    let _ = ToneJs_Loop.iterations
    let _ = ToneJs_Loop.setIterations
    let _ = ToneJs_Loop.callback
    let _ = ToneJs_Loop.setCallback
    Pass
  }),
])

let eventSuite = suite("Event", [
  test("bindings type-check", () => {
    let _ = ToneJs_Event.make
    let _ = ToneJs_Event.start
    let _ = ToneJs_Event.stop
    let _ = ToneJs_Event.cancel
    let _ = ToneJs_Event.dispose
    let _ = ToneJs_Event.state
    let _ = ToneJs_Event.progress
    let _ = ToneJs_Event.loop
    let _ = ToneJs_Event.setLoop
    let _ = ToneJs_Event.loopEnd
    let _ = ToneJs_Event.setLoopEnd
    let _ = ToneJs_Event.loopStart
    let _ = ToneJs_Event.setLoopStart
    let _ = ToneJs_Event.playbackRate
    let _ = ToneJs_Event.setPlaybackRate
    let _ = ToneJs_Event.probability
    let _ = ToneJs_Event.setProbability
    let _ = ToneJs_Event.mute
    let _ = ToneJs_Event.setMute
    let _ = ToneJs_Event.humanize
    let _ = ToneJs_Event.setHumanize
    Pass
  }),
])

let partSuite = suite("Part", [
  test("bindings type-check", () => {
    let _ = ToneJs_Part.make
    let _ = ToneJs_Part.start
    let _ = ToneJs_Part.startWithOffset
    let _ = ToneJs_Part.stop
    let _ = ToneJs_Part.cancel
    let _ = ToneJs_Part.clear
    let _ = ToneJs_Part.dispose
    let _ = ToneJs_Part.add
    let _ = ToneJs_Part.remove
    let _ = ToneJs_Part.at
    let _ = ToneJs_Part.state
    let _ = ToneJs_Part.progress
    let _ = ToneJs_Part.length
    let _ = ToneJs_Part.loop
    let _ = ToneJs_Part.setLoop
    let _ = ToneJs_Part.setLoopCount
    let _ = ToneJs_Part.loopEnd
    let _ = ToneJs_Part.setLoopEnd
    let _ = ToneJs_Part.loopStart
    let _ = ToneJs_Part.setLoopStart
    let _ = ToneJs_Part.playbackRate
    let _ = ToneJs_Part.setPlaybackRate
    let _ = ToneJs_Part.probability
    let _ = ToneJs_Part.setProbability
    let _ = ToneJs_Part.mute
    let _ = ToneJs_Part.setMute
    let _ = ToneJs_Part.humanize
    let _ = ToneJs_Part.setHumanize
    Pass
  }),
])

let sequenceSuite = suite("Sequence", [
  test("bindings type-check", () => {
    let _ = ToneJs_Sequence.make
    let _ = ToneJs_Sequence.makeWithSubdivision
    let _ = ToneJs_Sequence.start
    let _ = ToneJs_Sequence.startWithOffset
    let _ = ToneJs_Sequence.stop
    let _ = ToneJs_Sequence.clear
    let _ = ToneJs_Sequence.dispose
    let _ = ToneJs_Sequence.events
    let _ = ToneJs_Sequence.setEvents
    let _ = ToneJs_Sequence.subdivision
    let _ = ToneJs_Sequence.state
    let _ = ToneJs_Sequence.progress
    let _ = ToneJs_Sequence.length
    let _ = ToneJs_Sequence.loop
    let _ = ToneJs_Sequence.setLoop
    let _ = ToneJs_Sequence.setLoopCount
    let _ = ToneJs_Sequence.loopEnd
    let _ = ToneJs_Sequence.setLoopEnd
    let _ = ToneJs_Sequence.loopStart
    let _ = ToneJs_Sequence.setLoopStart
    let _ = ToneJs_Sequence.playbackRate
    let _ = ToneJs_Sequence.setPlaybackRate
    let _ = ToneJs_Sequence.probability
    let _ = ToneJs_Sequence.setProbability
    let _ = ToneJs_Sequence.mute
    let _ = ToneJs_Sequence.setMute
    let _ = ToneJs_Sequence.humanize
    let _ = ToneJs_Sequence.setHumanize
    Pass
  }),
])

let suites = [loopSuite, eventSuite, partSuite, sequenceSuite]
