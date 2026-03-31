open Xote

type props = {}

let make = (_props: props) => {
  <article class="docs-article">
    <h1 id="scheduling"> {Component.text("Scheduling")} </h1>
    <p>
      {Component.text(
        "Scheduling modules let you trigger events over time, synced to the Transport.",
      )}
    </p>

    <h2 id="loop"> {Component.text("Loop")} </h2>
    <p>
      {Component.text(
        "A Loop calls a callback at a regular interval.",
      )}
    </p>
    <CodeBlock
      code={`let loop = Loop.make(time => {
  synth->Synth.triggerAttackRelease("C4", "8n")
}, "4n")

let loop2 = Loop.makeWithOptions({
  callback: time => Console.log(time),
  interval: "4n",
  iterations: 8, // stop after 8 repeats
  probability: 0.9, // 90% chance each iteration fires
  humanize: true,
})

loop->Loop.start()
loop->Loop.stop()
loop->Loop.cancel()

// Properties
loop->Loop.state // "started" | "stopped"
loop->Loop.progress // normalRange
loop->Loop.interval // time
loop->Loop.setInterval("8n")
loop->Loop.playbackRate // positive
loop->Loop.setPlaybackRate(2.0)
loop->Loop.iterations // int
loop->Loop.setIterations(16)
loop->Loop.mute // bool
loop->Loop.setMute(true)
loop->Loop.humanize // bool
loop->Loop.probability // normalRange`}
    />

    <h2 id="event"> {Component.text("Event")} </h2>
    <p>
      {Component.text(
        "An Event triggers a callback on a schedule. Similar to Loop but for single occurrences.",
      )}
    </p>
    <CodeBlock
      code={`let event = Event.make(time => {
  synth->Synth.triggerAttackRelease("E4", "8n")
})

let event2 = Event.makeWithOptions({
  callback: _time => Console.log("event!"),
  loop: true,
  loopStart: "0",
  loopEnd: "2m",
  playbackRate: 1.0,
})

event->Event.start("0")
event->Event.stop("4m")
event->Event.cancel()

event->Event.state // playbackState
event->Event.progress // normalRange
event->Event.loop // bool
event->Event.setLoop(true)
event->Event.mute // bool
event->Event.probability // normalRange`}
    />

    <h2 id="part"> {Component.text("Part")} </h2>
    <p>
      {Component.text(
        "A Part schedules an array of events along a timeline.",
      )}
    </p>
    <CodeBlock
      code={`// Each event has a time and a value
let part = Part.make((time, note) => {
  synth->Synth.triggerAttackRelease(note, "8n")
}, [
  {"time": "0:0:0", "note": "C4"},
  {"time": "0:1:0", "note": "E4"},
  {"time": "0:2:0", "note": "G4"},
])

part->Part.start("0")
part->Part.stop()

part->Part.loop // bool
part->Part.setLoop(true)
part->Part.loopStart // time
part->Part.loopEnd // time
part->Part.playbackRate // positive
part->Part.length // int

// Add/remove events
part->Part.add("0:3:0", "B4")
part->Part.remove("0:1:0", "E4")
part->Part.clear()`}
    />

    <h2 id="sequence"> {Component.text("Sequence")} </h2>
    <p>
      {Component.text(
        "A Sequence plays an array of values at a given subdivision.",
      )}
    </p>
    <CodeBlock
      code={`let seq = Sequence.make((time, note) => {
  synth->Synth.triggerAttackRelease(note, "8n")
}, ["C4", "E4", "G4", "B4"], "4n")

seq->Sequence.start("0")
seq->Sequence.stop()

seq->Sequence.loop // bool
seq->Sequence.setLoop(true)
seq->Sequence.subdivision // time
seq->Sequence.events // array
seq->Sequence.playbackRate // positive`}
    />
  </article>
}
