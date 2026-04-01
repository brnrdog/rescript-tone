open Xote

// ---- JS bindings ----
@val external setTimeout: (unit => unit, int) => unit = "setTimeout"

// Tone.js accepts strings for frequency ("C4") and time ("8n") at runtime
// but the bindings type them as float/abstract. These helpers cast safely.
// The Tone bindings use abstract types, but Tone.js accepts strings at runtime.
// We use Obj.magic for the type casts in these interactive demos.
let toFreq: string => 'a = Obj.magic
let toTime: string => 'a = Obj.magic
let floatToTime: float => 'a = Obj.magic

let toOsc = (s: string): Tone.Types.oscillatorType => {
  switch s {
  | "sine" => Sine
  | "square" => Square
  | "sawtooth" => Sawtooth
  | _ => Triangle
  }
}

let makeEnvelope = (
  ~attack: float,
  ~decay: float,
  ~sustain: float,
  ~release: float,
): Tone.Types.envelopeOptions => {
  attack: floatToTime(attack),
  decay: floatToTime(decay),
  sustain,
  release: floatToTime(release),
}

// ---- Interactive Synth Keyboard Demo ----
module SynthKeyboard = {
  type props = {}

  let notes = ["C4", "D4", "E4", "F4", "G4", "A4", "B4", "C5"]
  let noteLabels = ["C", "D", "E", "F", "G", "A", "B", "C"]

  let make = (_props: props) => {
    let isReady = Signal.make(false)
    let activeNote = Signal.make("")
    let waveform = Signal.make("triangle")

    // Store synth in a ref-like signal
    let synthRef: ref<option<Tone.Synth.t>> = ref(None)

    let initAudio = _ => {
      let _ = Tone.Core.start()
      let synth = Tone.Synth.makeWithOptions({
        oscillator: {\"type": toOsc(Signal.get(waveform))},
        envelope: makeEnvelope(~attack=0.01, ~decay=0.2, ~sustain=0.3, ~release=0.8),
      })
      synth->Tone.Synth.asAudioNode->Tone.AudioNode.toDestination->ignore
      synthRef := Some(synth)
      Signal.set(isReady, true)
    }

    let playNote = (note: string) => _ => {
      switch synthRef.contents {
      | Some(synth) => {
          synth->Tone.Synth.triggerAttackRelease(toFreq(note), toTime("8n"))->ignore
          Signal.set(activeNote, note)
          setTimeout(() => Signal.set(activeNote, ""), 200)
        }
      | None => ()
      }
    }

    let setWave = (wave: string) => _ => {
      Signal.set(waveform, wave)
      // Recreate synth with new waveform
      switch synthRef.contents {
      | Some(_) => {
          let synth = Tone.Synth.makeWithOptions({
            oscillator: {\"type": toOsc(wave)},
            envelope: makeEnvelope(~attack=0.01, ~decay=0.2, ~sustain=0.3, ~release=0.8),
          })
          synth->Tone.Synth.asAudioNode->Tone.AudioNode.toDestination->ignore
          synthRef := Some(synth)
        }
      | None => ()
      }
    }

    <div class="demo-card">
      <div class="demo-header">
        <h3> {Component.text("Synth Keyboard")} </h3>
        <p> {Component.text("Click a key to play a note. Choose different waveforms to change the timbre.")} </p>
      </div>
      <div class="demo-body">
        {Component.signalFragment(
          Computed.make(() => {
            if Signal.get(isReady) {
              [
                <div class="demo-controls">
                  <span class="demo-label"> {Component.text("Waveform:")} </span>
                  {Component.element(
                    "button",
                    ~attrs=[
                      Component.computedAttr("class", () =>
                        "demo-wave-btn" ++ (Signal.get(waveform) == "sine" ? " active" : "")
                      ),
                    ],
                    ~events=[("click", setWave("sine"))],
                    ~children=[Component.text("Sine")],
                    (),
                  )}
                  {Component.element(
                    "button",
                    ~attrs=[
                      Component.computedAttr("class", () =>
                        "demo-wave-btn" ++ (Signal.get(waveform) == "triangle" ? " active" : "")
                      ),
                    ],
                    ~events=[("click", setWave("triangle"))],
                    ~children=[Component.text("Triangle")],
                    (),
                  )}
                  {Component.element(
                    "button",
                    ~attrs=[
                      Component.computedAttr("class", () =>
                        "demo-wave-btn" ++ (Signal.get(waveform) == "sawtooth" ? " active" : "")
                      ),
                    ],
                    ~events=[("click", setWave("sawtooth"))],
                    ~children=[Component.text("Sawtooth")],
                    (),
                  )}
                  {Component.element(
                    "button",
                    ~attrs=[
                      Component.computedAttr("class", () =>
                        "demo-wave-btn" ++ (Signal.get(waveform) == "square" ? " active" : "")
                      ),
                    ],
                    ~events=[("click", setWave("square"))],
                    ~children=[Component.text("Square")],
                    (),
                  )}
                </div>,
                <div class="piano-keys">
                  {Component.fragment(
                    notes->Array.mapWithIndex((note, i) => {
                      Component.element(
                        "button",
                        ~attrs=[
                          Component.computedAttr("class", () =>
                            "piano-key" ++ (Signal.get(activeNote) == note ? " active" : "")
                          ),
                        ],
                        ~events=[("click", playNote(note))],
                        ~children=[
                          Component.text(
                            switch noteLabels->Array.get(i) {
                            | Some(l) => l
                            | None => ""
                            },
                          ),
                        ],
                        (),
                      )
                    }),
                  )}
                </div>,
              ]
            } else {
              [
                Component.element(
                  "button",
                  ~attrs=[Component.attr("class", "btn btn-primary demo-start-btn")],
                  ~events=[("click", initAudio)],
                  ~children=[Component.text("Start Audio")],
                  (),
                ),
              ]
            }
          }),
        )}
      </div>
      <div class="demo-source">
        <CodeBlock
          code={`open Tone

let synth = Synth.makeWithOptions({
  oscillator: {"type": "triangle"},
  envelope: {
    attack: 0.01, decay: 0.2,
    sustain: 0.3, release: 0.8,
  },
})
synth->Synth.asAudioNode->AudioNode.toDestination

synth->Synth.triggerAttackRelease("C4", "8n")`}
        />
      </div>
    </div>
  }
}

// ---- Effects Chain Demo ----
module EffectsChain = {
  type props = {}

  let make = (_props: props) => {
    let isReady = Signal.make(false)
    let reverbWet = Signal.make(50)
    let delayWet = Signal.make(30)
    let activeNote = Signal.make("")

    let synthRef: ref<option<Tone.FMSynth.t>> = ref(None)
    let reverbRef: ref<option<Tone.Reverb.t>> = ref(None)
    let delayRef: ref<option<Tone.FeedbackDelay.t>> = ref(None)

    let initAudio = _ => {
      let _ = Tone.Core.start()
      let synth = Tone.FMSynth.make()
      let reverb = Tone.Reverb.makeWithOptions({decay: 3.0, wet: 0.5})
      let delay = Tone.FeedbackDelay.makeWithOptions({
        delayTime: toTime("8n."),
        feedback: 0.3,
        wet: 0.3,
      })

      synth->Tone.FMSynth.asAudioNode
      ->Tone.AudioNode.connect(delay->Tone.FeedbackDelay.asAudioNode)
      ->ignore
      delay->Tone.FeedbackDelay.asAudioNode
      ->Tone.AudioNode.connect(reverb->Tone.Reverb.asAudioNode)
      ->ignore
      reverb->Tone.Reverb.asAudioNode->Tone.AudioNode.toDestination->ignore

      synthRef := Some(synth)
      reverbRef := Some(reverb)
      delayRef := Some(delay)
      Signal.set(isReady, true)
    }

    let playNote = (note: string) => _ => {
      switch synthRef.contents {
      | Some(synth) => {
          synth->Tone.FMSynth.triggerAttackRelease(toFreq(note), toTime("4n"))->ignore
          Signal.set(activeNote, note)
          setTimeout(() => Signal.set(activeNote, ""), 300)
        }
      | None => ()
      }
    }

    let notes = ["C3", "E3", "G3", "C4", "E4", "G4"]

    <div class="demo-card">
      <div class="demo-header">
        <h3> {Component.text("Effects Chain")} </h3>
        <p> {Component.text("FM Synth routed through Delay and Reverb. Adjust the wet mix of each effect.")} </p>
      </div>
      <div class="demo-body">
        {Component.signalFragment(
          Computed.make(() => {
            if Signal.get(isReady) {
              [
                <div class="demo-controls">
                  <div class="demo-slider-group">
                    <span class="demo-label">
                      {Component.textSignal(() =>
                        "Reverb: " ++ Int.toString(Signal.get(reverbWet)) ++ "%"
                      )}
                    </span>
                    {Component.element(
                      "input",
                      ~attrs=[
                        Component.attr("type", "range"),
                        Component.attr("min", "0"),
                        Component.attr("max", "100"),
                        Component.computedAttr("value", () =>
                          Int.toString(Signal.get(reverbWet))
                        ),
                        Component.attr("class", "demo-slider"),
                      ],
                      ~events=[
                        ("input", evt => {
                          let val: string = Obj.magic(evt)["target"]["value"]
                          let intVal = Int.fromString(val)->Option.getOr(50)
                          Signal.set(reverbWet, intVal)
                          switch reverbRef.contents {
                          | Some(reverb) =>
                            Tone.Reverb.wet(reverb)->Tone.Param.setValue(
                              Int.toFloat(intVal) /. 100.0,
                            )
                          | None => ()
                          }
                        }),
                      ],
                      (),
                    )}
                  </div>
                  <div class="demo-slider-group">
                    <span class="demo-label">
                      {Component.textSignal(() =>
                        "Delay: " ++ Int.toString(Signal.get(delayWet)) ++ "%"
                      )}
                    </span>
                    {Component.element(
                      "input",
                      ~attrs=[
                        Component.attr("type", "range"),
                        Component.attr("min", "0"),
                        Component.attr("max", "100"),
                        Component.computedAttr("value", () =>
                          Int.toString(Signal.get(delayWet))
                        ),
                        Component.attr("class", "demo-slider"),
                      ],
                      ~events=[
                        ("input", evt => {
                          let val: string = Obj.magic(evt)["target"]["value"]
                          let intVal = Int.fromString(val)->Option.getOr(30)
                          Signal.set(delayWet, intVal)
                          switch delayRef.contents {
                          | Some(delay) =>
                            Tone.FeedbackDelay.wet(delay)->Tone.Param.setValue(
                              Int.toFloat(intVal) /. 100.0,
                            )
                          | None => ()
                          }
                        }),
                      ],
                      (),
                    )}
                  </div>
                </div>,
                <div class="demo-note-grid">
                  {Component.fragment(
                    notes->Array.map(note => {
                      Component.element(
                        "button",
                        ~attrs=[
                          Component.computedAttr("class", () =>
                            "demo-note-btn" ++
                            (Signal.get(activeNote) == note ? " active" : "")
                          ),
                        ],
                        ~events=[("click", playNote(note))],
                        ~children=[Component.text(note)],
                        (),
                      )
                    }),
                  )}
                </div>,
              ]
            } else {
              [
                Component.element(
                  "button",
                  ~attrs=[Component.attr("class", "btn btn-primary demo-start-btn")],
                  ~events=[("click", initAudio)],
                  ~children=[Component.text("Start Audio")],
                  (),
                ),
              ]
            }
          }),
        )}
      </div>
      <div class="demo-source">
        <CodeBlock
          code={`open Tone

let synth = FMSynth.make()
let reverb = Reverb.makeWithOptions({
  decay: 3.0, wet: 0.5,
})
let delay = FeedbackDelay.makeWithOptions({
  delayTime: "8n.", feedback: 0.3, wet: 0.3,
})

synth->FMSynth.asAudioNode
->AudioNode.connect(delay->FeedbackDelay.asAudioNode)
->AudioNode.connect(reverb->Reverb.asAudioNode)
->AudioNode.toDestination`}
        />
      </div>
    </div>
  }
}

// ---- Sequencer Demo ----
module SequencerDemo = {
  type props = {}

  let make = (_props: props) => {
    let isReady = Signal.make(false)
    let isPlaying = Signal.make(false)
    let currentStep = Signal.make(-1)

    let steps = [
      ("C4", true),
      ("D4", false),
      ("E4", true),
      ("F4", false),
      ("G4", true),
      ("A4", false),
      ("B4", true),
      ("C5", false),
    ]
    let stepActive = steps->Array.map(((_, active)) => Signal.make(active))

    let synthRef: ref<option<Tone.Synth.t>> = ref(None)
    let loopRef: ref<option<Tone.Loop.t>> = ref(None)

    let initAudio = _ => {
      let _ = Tone.Core.start()
      let synth = Tone.Synth.makeWithOptions({
        oscillator: {\"type": Square},
        envelope: makeEnvelope(~attack=0.01, ~decay=0.1, ~sustain=0.1, ~release=0.3),
      })
      synth->Tone.Synth.asAudioNode->Tone.AudioNode.toDestination->ignore

      let stepIdx = ref(0)
      let loop = Tone.Loop.make(_time => {
        let idx = mod(stepIdx.contents, 8)
        Signal.set(currentStep, idx)

        let isActive = switch stepActive->Array.get(idx) {
        | Some(s) => Signal.get(s)
        | None => false
        }

        if isActive {
          let (note, _) = switch steps->Array.get(idx) {
          | Some(s) => s
          | None => ("C4", false)
          }
          synth->Tone.Synth.triggerAttackRelease(toFreq(note), toTime("16n"))->ignore
        }

        stepIdx := stepIdx.contents + 1
      }, toTime("8n"))

      synthRef := Some(synth)
      loopRef := Some(loop)
      Signal.set(isReady, true)
    }

    let togglePlay = _ => {
      let playing = Signal.get(isPlaying)
      if playing {
        switch loopRef.contents {
        | Some(loop) => loop->Tone.Loop.stop->ignore
        | None => ()
        }
        let transport = Tone.Core.getTransport()
        transport->Tone.Transport.stop->ignore
        Signal.set(isPlaying, false)
        Signal.set(currentStep, -1)
      } else {
        switch loopRef.contents {
        | Some(loop) => loop->Tone.Loop.start->ignore
        | None => ()
        }
        let transport = Tone.Core.getTransport()
        transport->Tone.Transport.start->ignore
        Signal.set(isPlaying, true)
      }
    }

    <div class="demo-card">
      <div class="demo-header">
        <h3> {Component.text("Step Sequencer")} </h3>
        <p> {Component.text("Toggle steps on/off to create a pattern. Uses Loop and Transport for timing.")} </p>
      </div>
      <div class="demo-body">
        {Component.signalFragment(
          Computed.make(() => {
            if Signal.get(isReady) {
              let _ = Signal.get(isPlaying)
              [
                <div class="sequencer-controls">
                  {Component.element(
                    "button",
                    ~attrs=[
                      Component.computedAttr("class", () =>
                        "btn " ++
                        (Signal.get(isPlaying) ? "btn-danger" : "btn-primary")
                      ),
                    ],
                    ~events=[("click", togglePlay)],
                    ~children=[
                      Component.textSignal(() =>
                        Signal.get(isPlaying) ? "Stop" : "Play"
                      ),
                    ],
                    (),
                  )}
                </div>,
                <div class="sequencer-grid">
                  {Component.fragment(
                    steps->Array.mapWithIndex(((note, _), i) => {
                      let stepSignal = switch stepActive->Array.get(i) {
                      | Some(s) => s
                      | None => Signal.make(false)
                      }
                      Component.element(
                        "button",
                        ~attrs=[
                          Component.computedAttr("class", () => {
                            let isCurrent = Signal.get(currentStep) == i
                            let active = Signal.get(stepSignal)
                            "seq-step" ++
                            (active ? " on" : "") ++
                            (isCurrent ? " current" : "")
                          }),
                        ],
                        ~events=[
                          ("click", _ => {
                            Signal.update(stepSignal, v => !v)
                          }),
                        ],
                        ~children=[
                          <span class="seq-step-note"> {Component.text(note)} </span>,
                        ],
                        (),
                      )
                    }),
                  )}
                </div>,
              ]
            } else {
              [
                Component.element(
                  "button",
                  ~attrs=[Component.attr("class", "btn btn-primary demo-start-btn")],
                  ~events=[("click", initAudio)],
                  ~children=[Component.text("Start Audio")],
                  (),
                ),
              ]
            }
          }),
        )}
      </div>
      <div class="demo-source">
        <CodeBlock
          code={`open Tone

let synth = Synth.makeWithOptions({
  oscillator: {"type": "square"},
  envelope: {
    attack: 0.01, decay: 0.1,
    sustain: 0.1, release: 0.3,
  },
})
synth->Synth.asAudioNode->AudioNode.toDestination

let _loop = Loop.make(_time => {
  synth->Synth.triggerAttackRelease("C4", "16n")
}, "8n")

let transport = Core.getTransport()
transport->Transport.start()`}
        />
      </div>
    </div>
  }
}

// ---- Melody Sequencer Demo ----
module MelodyDemo = {
  type props = {}

  let melodyNotes = ["C4", "D4", "E4", "G4", "A4", "G4", "E4", "D4"]
  let melodyLabels = ["C4", "D4", "E4", "G4", "A4", "G4", "E4", "D4"]

  let make = (_props: props) => {
    let isReady = Signal.make(false)
    let isPlaying = Signal.make(false)
    let currentStep = Signal.make(-1)
    let bpm = Signal.make(120)

    let synthRef: ref<option<Tone.Synth.t>> = ref(None)
    let seqRef: ref<option<Tone.Sequence.t>> = ref(None)

    let initAudio = _ => {
      let _ = Tone.Core.start()
      let synth = Tone.Synth.makeWithOptions({
        oscillator: {\"type": Triangle},
        envelope: makeEnvelope(~attack=0.01, ~decay=0.1, ~sustain=0.3, ~release=0.5),
      })
      synth->Tone.Synth.asAudioNode->Tone.AudioNode.toDestination->ignore

      let stepIdx = ref(0)
      let seq = Tone.Sequence.makeWithSubdivision(
        (_time, note) => {
          let noteStr: string = Obj.magic(note)
          synth->Tone.Synth.triggerAttackRelease(toFreq(noteStr), toTime("8n"))->ignore
          Signal.set(currentStep, mod(stepIdx.contents, 8))
          stepIdx := stepIdx.contents + 1
        },
        melodyNotes->Array.map(n => Obj.magic(n)),
        toTime("4n"),
      )

      let transport = Tone.Core.getTransport()
      Tone.Transport.bpm(transport)->Tone.Param.setValue(120.0)

      synthRef := Some(synth)
      seqRef := Some(seq)
      Signal.set(isReady, true)
    }

    let togglePlay = _ => {
      if Signal.get(isPlaying) {
        switch seqRef.contents {
        | Some(seq) => seq->Tone.Sequence.stop->ignore
        | None => ()
        }
        Tone.Core.getTransport()->Tone.Transport.stop->ignore
        Signal.set(isPlaying, false)
        Signal.set(currentStep, -1)
      } else {
        switch seqRef.contents {
        | Some(seq) => seq->Tone.Sequence.start->ignore
        | None => ()
        }
        Tone.Core.getTransport()->Tone.Transport.start->ignore
        Signal.set(isPlaying, true)
      }
    }

    let changeBpm = evt => {
      let val: string = Obj.magic(evt)["target"]["value"]
      let intVal = Int.fromString(val)->Option.getOr(120)
      Signal.set(bpm, intVal)
      let transport = Tone.Core.getTransport()
      Tone.Transport.bpm(transport)->Tone.Param.setValue(Int.toFloat(intVal))
    }

    <div class="demo-card">
      <div class="demo-header">
        <h3> {Component.text("Melody Sequencer")} </h3>
        <p> {Component.text("Play a looping melody using Sequence and Transport. Adjust the BPM to change the tempo.")} </p>
      </div>
      <div class="demo-body">
        {Component.signalFragment(
          Computed.make(() => {
            if Signal.get(isReady) {
              [
                <div class="demo-controls">
                  {Component.element(
                    "button",
                    ~attrs=[
                      Component.computedAttr("class", () =>
                        "btn " ++ (Signal.get(isPlaying) ? "btn-danger" : "btn-primary")
                      ),
                    ],
                    ~events=[("click", togglePlay)],
                    ~children=[
                      Component.textSignal(() =>
                        Signal.get(isPlaying) ? "Stop" : "Play"
                      ),
                    ],
                    (),
                  )}
                  <div class="demo-slider-group">
                    <span class="demo-label">
                      {Component.textSignal(() =>
                        "BPM: " ++ Int.toString(Signal.get(bpm))
                      )}
                    </span>
                    {Component.element(
                      "input",
                      ~attrs=[
                        Component.attr("type", "range"),
                        Component.attr("min", "60"),
                        Component.attr("max", "200"),
                        Component.computedAttr("value", () => Int.toString(Signal.get(bpm))),
                        Component.attr("class", "demo-slider"),
                      ],
                      ~events=[("input", changeBpm)],
                      (),
                    )}
                  </div>
                </div>,
                <div class="sequencer-grid">
                  {Component.fragment(
                    melodyLabels->Array.mapWithIndex((label, i) => {
                      Component.element(
                        "button",
                        ~attrs=[
                          Component.computedAttr("class", () =>
                            "seq-step melody-step" ++
                            " on" ++
                            (Signal.get(currentStep) == i ? " current" : "")
                          ),
                        ],
                        ~events=[("click", _ => ())],
                        ~children=[
                          <span class="seq-step-note"> {Component.text(label)} </span>,
                        ],
                        (),
                      )
                    }),
                  )}
                </div>,
              ]
            } else {
              [
                Component.element(
                  "button",
                  ~attrs=[Component.attr("class", "btn btn-primary demo-start-btn")],
                  ~events=[("click", initAudio)],
                  ~children=[Component.text("Start Audio")],
                  (),
                ),
              ]
            }
          }),
        )}
      </div>
      <div class="demo-source">
        <CodeBlock
          code={`open Tone

let synth = Synth.makeWithOptions({
  oscillator: {"type": "triangle"},
  envelope: {attack: 0.01, decay: 0.1, sustain: 0.3, release: 0.5},
})
synth->Synth.asAudioNode->AudioNode.toDestination

let notes = ["C4", "D4", "E4", "G4", "A4", "G4", "E4", "D4"]

let _seq = Sequence.makeWithSubdivision(
  (_time, note) => {
    synth->Synth.triggerAttackRelease(note, "8n")
  }, notes, "4n"
)

let transport = Core.getTransport()
transport->Transport.start()`}
        />
      </div>
    </div>
  }
}

// ---- Drum Machine Demo ----
module DrumMachine = {
  type props = {}

  let make = (_props: props) => {
    let isReady = Signal.make(false)
    let isPlaying = Signal.make(false)
    let currentBeat = Signal.make(-1)
    let bpm = Signal.make(120)

    // 8 steps for each of 3 drum sounds
    let kickPattern = Array.make(~length=8, false)->Array.map(v => Signal.make(v))
    let snarePattern = Array.make(~length=8, false)->Array.map(v => Signal.make(v))
    let hihatPattern = Array.make(~length=8, false)->Array.map(v => Signal.make(v))

    // Preset a classic pattern
    let _ = {
      // Kick on 1, 5
      switch kickPattern->Array.get(0) { | Some(s) => Signal.set(s, true) | None => () }
      switch kickPattern->Array.get(4) { | Some(s) => Signal.set(s, true) | None => () }
      // Snare on 3, 7
      switch snarePattern->Array.get(2) { | Some(s) => Signal.set(s, true) | None => () }
      switch snarePattern->Array.get(6) { | Some(s) => Signal.set(s, true) | None => () }
      // Hihat on all even
      [0, 2, 4, 6]->Array.forEach(i =>
        switch hihatPattern->Array.get(i) { | Some(s) => Signal.set(s, true) | None => () }
      )
    }

    let kickRef: ref<option<Tone.Synth.t>> = ref(None)
    let snareRef: ref<option<Tone.Noise.t>> = ref(None)
    let hihatRef: ref<option<Tone.Noise.t>> = ref(None)
    let loopRef: ref<option<Tone.Loop.t>> = ref(None)

    let initAudio = _ => {
      let _ = Tone.Core.start()

      // Kick: low sine
      let kick = Tone.Synth.makeWithOptions({
        oscillator: {\"type": Sine},
        envelope: makeEnvelope(~attack=0.001, ~decay=0.2, ~sustain=0.0, ~release=0.2),
      })
      kick->Tone.Synth.asAudioNode->Tone.AudioNode.toDestination->ignore

      // Snare: white noise burst
      let snare = Tone.Noise.makeWithOptions({
        \"type": White,
        volume: -10.0,
      })
      let snareEnv = Tone.Gain.make()
      snare->Tone.Noise.asAudioNode
      ->Tone.AudioNode.connect(snareEnv->Tone.Gain.asAudioNode)
      ->ignore
      snareEnv->Tone.Gain.asAudioNode->Tone.AudioNode.toDestination->ignore
      snare->Tone.Noise.start->ignore

      // Hihat: filtered noise
      let hihat = Tone.Noise.makeWithOptions({
        \"type": White,
        volume: -18.0,
      })
      let hihatFilter = Tone.Filter.makeWithOptions({
        frequency: 8000.0,
        \"type": Highpass,
      })
      hihat->Tone.Noise.asAudioNode
      ->Tone.AudioNode.connect(hihatFilter->Tone.Filter.asAudioNode)
      ->ignore
      hihatFilter->Tone.Filter.asAudioNode->Tone.AudioNode.toDestination->ignore
      hihat->Tone.Noise.start->ignore

      let transport = Tone.Core.getTransport()
      Tone.Transport.bpm(transport)->Tone.Param.setValue(120.0)

      let stepIdx = ref(0)
      let loop = Tone.Loop.make(_time => {
        let idx = mod(stepIdx.contents, 8)
        Signal.set(currentBeat, idx)

        // Kick
        let kickOn = switch kickPattern->Array.get(idx) {
        | Some(s) => Signal.get(s)
        | None => false
        }
        if kickOn {
          kick->Tone.Synth.triggerAttackRelease(toFreq("C1"), toTime("16n"))->ignore
        }

        // Snare
        let snareOn = switch snarePattern->Array.get(idx) {
        | Some(s) => Signal.get(s)
        | None => false
        }
        if snareOn {
          Tone.Gain.gain(snareEnv)->Tone.Param.setValue(1.0)
          Tone.Gain.gain(snareEnv)->Tone.Param.linearRampTo(0.0, toTime("32n"))->ignore
        }

        // Hihat
        let hihatOn = switch hihatPattern->Array.get(idx) {
        | Some(s) => Signal.get(s)
        | None => false
        }
        if hihatOn {
          hihat->Tone.Noise.restart->ignore
        }

        stepIdx := stepIdx.contents + 1
      }, toTime("8n"))

      kickRef := Some(kick)
      snareRef := Some(snare)
      hihatRef := Some(hihat)
      loopRef := Some(loop)
      Signal.set(isReady, true)
    }

    let togglePlay = _ => {
      if Signal.get(isPlaying) {
        switch loopRef.contents {
        | Some(loop) => loop->Tone.Loop.stop->ignore
        | None => ()
        }
        Tone.Core.getTransport()->Tone.Transport.stop->ignore
        Signal.set(isPlaying, false)
        Signal.set(currentBeat, -1)
      } else {
        switch loopRef.contents {
        | Some(loop) => loop->Tone.Loop.start->ignore
        | None => ()
        }
        Tone.Core.getTransport()->Tone.Transport.start->ignore
        Signal.set(isPlaying, true)
      }
    }

    let changeBpm = evt => {
      let val: string = Obj.magic(evt)["target"]["value"]
      let intVal = Int.fromString(val)->Option.getOr(120)
      Signal.set(bpm, intVal)
      Tone.Transport.bpm(Tone.Core.getTransport())->Tone.Param.setValue(Int.toFloat(intVal))
    }

    let drumLabels = ["Kick", "Snare", "Hi-hat"]
    let patterns = [kickPattern, snarePattern, hihatPattern]

    <div class="demo-card">
      <div class="demo-header">
        <h3> {Component.text("Drum Machine")} </h3>
        <p> {Component.text("A drum sequencer with kick, snare, and hi-hat. Toggle steps on/off to create your own beat.")} </p>
      </div>
      <div class="demo-body">
        {Component.signalFragment(
          Computed.make(() => {
            if Signal.get(isReady) {
              [
                <div class="demo-controls">
                  {Component.element(
                    "button",
                    ~attrs=[
                      Component.computedAttr("class", () =>
                        "btn " ++ (Signal.get(isPlaying) ? "btn-danger" : "btn-primary")
                      ),
                    ],
                    ~events=[("click", togglePlay)],
                    ~children=[
                      Component.textSignal(() =>
                        Signal.get(isPlaying) ? "Stop" : "Play"
                      ),
                    ],
                    (),
                  )}
                  <div class="demo-slider-group">
                    <span class="demo-label">
                      {Component.textSignal(() =>
                        "BPM: " ++ Int.toString(Signal.get(bpm))
                      )}
                    </span>
                    {Component.element(
                      "input",
                      ~attrs=[
                        Component.attr("type", "range"),
                        Component.attr("min", "60"),
                        Component.attr("max", "200"),
                        Component.computedAttr("value", () => Int.toString(Signal.get(bpm))),
                        Component.attr("class", "demo-slider"),
                      ],
                      ~events=[("input", changeBpm)],
                      (),
                    )}
                  </div>
                </div>,
                <div class="drum-grid">
                  {Component.fragment(
                    drumLabels->Array.mapWithIndex((label, rowIdx) => {
                      let pattern = switch patterns->Array.get(rowIdx) {
                      | Some(p) => p
                      | None => []
                      }
                      <div class="drum-row">
                        <span class="drum-label"> {Component.text(label)} </span>
                        <div class="drum-steps">
                          {Component.fragment(
                            pattern->Array.mapWithIndex((stepSignal, colIdx) => {
                              Component.element(
                                "button",
                                ~attrs=[
                                  Component.computedAttr("class", () => {
                                    let active = Signal.get(stepSignal)
                                    let isCurrent = Signal.get(currentBeat) == colIdx
                                    "drum-step" ++
                                    (active ? " on" : "") ++
                                    (isCurrent ? " current" : "")
                                  }),
                                ],
                                ~events=[("click", _ => Signal.update(stepSignal, v => !v))],
                                (),
                              )
                            }),
                          )}
                        </div>
                      </div>
                    }),
                  )}
                </div>,
              ]
            } else {
              [
                Component.element(
                  "button",
                  ~attrs=[Component.attr("class", "btn btn-primary demo-start-btn")],
                  ~events=[("click", initAudio)],
                  ~children=[Component.text("Start Audio")],
                  (),
                ),
              ]
            }
          }),
        )}
      </div>
      <div class="demo-source">
        <CodeBlock
          code={`open Tone

let kick = Synth.makeWithOptions({
  oscillator: {"type": "sine"},
  envelope: {attack: 0.001, decay: 0.2, sustain: 0.0, release: 0.2},
})
kick->Synth.asAudioNode->AudioNode.toDestination

let snare = Noise.makeWithOptions({"type": "white", volume: -10.0})
snare->Noise.asAudioNode->AudioNode.toDestination

let hihat = Noise.makeWithOptions({"type": "white", volume: -18.0})
let hpf = Filter.makeWithOptions({frequency: 8000.0, "type": "highpass"})
hihat->Noise.asAudioNode->AudioNode.connect(hpf->Filter.asAudioNode)
hpf->Filter.asAudioNode->AudioNode.toDestination

let _loop = Loop.make(_time => {
  kick->Synth.triggerAttackRelease("C1", "16n")
}, "8n")

let transport = Core.getTransport()
transport->Transport.start()`}
        />
      </div>
    </div>
  }
}

// ---- Filter Sweep Demo ----
module FilterSweep = {
  type props = {}

  let make = (_props: props) => {
    let isReady = Signal.make(false)
    let isPlaying = Signal.make(false)
    let cutoff = Signal.make(500)
    let resonance = Signal.make(1)

    let oscRef: ref<option<Tone.Oscillator.t>> = ref(None)
    let filterRef: ref<option<Tone.Filter.t>> = ref(None)

    let initAudio = _ => {
      let _ = Tone.Core.start()
      let osc = Tone.Oscillator.makeWithOptions({
        frequency: 110.0,
        \"type": Sawtooth,
        volume: -12.0,
      })
      let filter = Tone.Filter.makeWithOptions({
        frequency: 500.0,
        \"type": Lowpass,
        rolloff: R24,
        q: 1.0,
      })
      osc->Tone.Oscillator.asAudioNode
      ->Tone.AudioNode.connect(filter->Tone.Filter.asAudioNode)
      ->ignore
      filter->Tone.Filter.asAudioNode->Tone.AudioNode.toDestination->ignore

      oscRef := Some(osc)
      filterRef := Some(filter)
      Signal.set(isReady, true)
    }

    let togglePlay = _ => {
      if Signal.get(isPlaying) {
        switch oscRef.contents {
        | Some(osc) => osc->Tone.Oscillator.stop->ignore
        | None => ()
        }
        Signal.set(isPlaying, false)
      } else {
        switch oscRef.contents {
        | Some(osc) => osc->Tone.Oscillator.start->ignore
        | None => ()
        }
        Signal.set(isPlaying, true)
      }
    }

    let changeCutoff = evt => {
      let val: string = Obj.magic(evt)["target"]["value"]
      let intVal = Int.fromString(val)->Option.getOr(500)
      Signal.set(cutoff, intVal)
      switch filterRef.contents {
      | Some(filter) =>
        Tone.Filter.frequency(filter)->Tone.Param.setValue(Int.toFloat(intVal))
      | None => ()
      }
    }

    let changeResonance = evt => {
      let val: string = Obj.magic(evt)["target"]["value"]
      let intVal = Int.fromString(val)->Option.getOr(1)
      Signal.set(resonance, intVal)
      switch filterRef.contents {
      | Some(filter) =>
        Tone.Filter.q(filter)->Tone.Param.setValue(Int.toFloat(intVal))
      | None => ()
      }
    }

    <div class="demo-card">
      <div class="demo-header">
        <h3> {Component.text("Filter Sweep")} </h3>
        <p> {Component.text("A sawtooth oscillator through a resonant low-pass filter. Sweep the cutoff frequency and resonance.")} </p>
      </div>
      <div class="demo-body">
        {Component.signalFragment(
          Computed.make(() => {
            if Signal.get(isReady) {
              [
                <div class="demo-controls">
                  {Component.element(
                    "button",
                    ~attrs=[
                      Component.computedAttr("class", () =>
                        "btn " ++ (Signal.get(isPlaying) ? "btn-danger" : "btn-primary")
                      ),
                    ],
                    ~events=[("click", togglePlay)],
                    ~children=[
                      Component.textSignal(() =>
                        Signal.get(isPlaying) ? "Stop" : "Play"
                      ),
                    ],
                    (),
                  )}
                </div>,
                <div class="demo-controls" style="flex-direction: column; gap: 12px">
                  <div class="demo-slider-group" style="width: 100%">
                    <span class="demo-label">
                      {Component.textSignal(() =>
                        "Cutoff: " ++ Int.toString(Signal.get(cutoff)) ++ " Hz"
                      )}
                    </span>
                    {Component.element(
                      "input",
                      ~attrs=[
                        Component.attr("type", "range"),
                        Component.attr("min", "50"),
                        Component.attr("max", "8000"),
                        Component.computedAttr("value", () => Int.toString(Signal.get(cutoff))),
                        Component.attr("class", "demo-slider"),
                      ],
                      ~events=[("input", changeCutoff)],
                      (),
                    )}
                  </div>
                  <div class="demo-slider-group" style="width: 100%">
                    <span class="demo-label">
                      {Component.textSignal(() =>
                        "Resonance (Q): " ++ Int.toString(Signal.get(resonance))
                      )}
                    </span>
                    {Component.element(
                      "input",
                      ~attrs=[
                        Component.attr("type", "range"),
                        Component.attr("min", "0"),
                        Component.attr("max", "20"),
                        Component.computedAttr("value", () => Int.toString(Signal.get(resonance))),
                        Component.attr("class", "demo-slider"),
                      ],
                      ~events=[("input", changeResonance)],
                      (),
                    )}
                  </div>
                </div>,
              ]
            } else {
              [
                Component.element(
                  "button",
                  ~attrs=[Component.attr("class", "btn btn-primary demo-start-btn")],
                  ~events=[("click", initAudio)],
                  ~children=[Component.text("Start Audio")],
                  (),
                ),
              ]
            }
          }),
        )}
      </div>
      <div class="demo-source">
        <CodeBlock
          code={`open Tone

let osc = Oscillator.makeWithOptions({
  frequency: 110.0,
  "type": "sawtooth",
})

let filter = Filter.makeWithOptions({
  frequency: 500.0,
  "type": "lowpass",
  rolloff: -24,
  q: 1.0,
})

osc->Oscillator.asAudioNode
->AudioNode.connect(filter->Filter.asAudioNode)
->AudioNode.toDestination

// Sweep the filter cutoff
filter->Filter.frequency->Param.rampTo(2000.0, "2m")

osc->Oscillator.start()`}
        />
      </div>
    </div>
  }
}

// ---- Polyphonic Chords Demo ----
module PolyChordsDemo = {
  type props = {}

  type chord = {
    name: string,
    notes: array<string>,
  }

  let chords = [
    {name: "Cmaj", notes: ["C4", "E4", "G4"]},
    {name: "Fmaj", notes: ["F3", "A3", "C4"]},
    {name: "Am", notes: ["A3", "C4", "E4"]},
    {name: "G", notes: ["G3", "B3", "D4"]},
    {name: "Dm", notes: ["D3", "F3", "A3"]},
    {name: "Em", notes: ["E3", "G3", "B3"]},
  ]

  let make = (_props: props) => {
    let isReady = Signal.make(false)
    let activeChord = Signal.make("")

    let synthRef: ref<option<Tone.PolySynth.t>> = ref(None)

    let initAudio = _ => {
      let _ = Tone.Core.start()
      let synth = Tone.PolySynth.makeWithOptions({
        maxPolyphony: 6,
        volume: -8.0,
      })
      synth->Tone.PolySynth.asAudioNode->Tone.AudioNode.toDestination->ignore
      synthRef := Some(synth)
      Signal.set(isReady, true)
    }

    let playChord = (chord: chord) => _ => {
      switch synthRef.contents {
      | Some(synth) => {
          let freqs = chord.notes->Array.map(n => toFreq(n))
          synth->Tone.PolySynth.triggerAttackRelease(freqs, toTime("2n"))->ignore
          Signal.set(activeChord, chord.name)
          setTimeout(() => Signal.set(activeChord, ""), 500)
        }
      | None => ()
      }
    }

    <div class="demo-card">
      <div class="demo-header">
        <h3> {Component.text("Polyphonic Chords")} </h3>
        <p> {Component.text("Play chords using PolySynth. Each button triggers multiple notes simultaneously.")} </p>
      </div>
      <div class="demo-body">
        {Component.signalFragment(
          Computed.make(() => {
            if Signal.get(isReady) {
              [
                <div class="chord-grid">
                  {Component.fragment(
                    chords->Array.map(chord => {
                      Component.element(
                        "button",
                        ~attrs=[
                          Component.computedAttr("class", () =>
                            "chord-btn" ++
                            (Signal.get(activeChord) == chord.name ? " active" : "")
                          ),
                        ],
                        ~events=[("click", playChord(chord))],
                        ~children=[
                          <span class="chord-name"> {Component.text(chord.name)} </span>,
                          <span class="chord-notes">
                            {Component.text(chord.notes->Array.join(", "))}
                          </span>,
                        ],
                        (),
                      )
                    }),
                  )}
                </div>,
              ]
            } else {
              [
                Component.element(
                  "button",
                  ~attrs=[Component.attr("class", "btn btn-primary demo-start-btn")],
                  ~events=[("click", initAudio)],
                  ~children=[Component.text("Start Audio")],
                  (),
                ),
              ]
            }
          }),
        )}
      </div>
      <div class="demo-source">
        <CodeBlock
          code={`open Tone

let synth = PolySynth.makeWithOptions({
  maxPolyphony: 6,
  volume: -8.0,
})
synth->PolySynth.asAudioNode->AudioNode.toDestination

// Play a C major chord
synth->PolySynth.triggerAttackRelease(
  ["C4", "E4", "G4"], "2n"
)`}
        />
      </div>
    </div>
  }
}

// ---- AM Synth Pad Demo ----
module AMSynthPad = {
  type props = {}

  let make = (_props: props) => {
    let isReady = Signal.make(false)
    let activeNote = Signal.make("")
    let harmonicity = Signal.make(3)

    let synthRef: ref<option<Tone.AMSynth.t>> = ref(None)
    let reverbRef: ref<option<Tone.Reverb.t>> = ref(None)

    let initAudio = _ => {
      let _ = Tone.Core.start()
      let reverb = Tone.Reverb.makeWithOptions({decay: 4.0, wet: 0.6})
      let synth = Tone.AMSynth.makeWithOptions({
        harmonicity: 3.0,
        oscillator: {\"type": Sine},
        modulation: {\"type": Square},
        envelope: makeEnvelope(~attack=0.5, ~decay=0.3, ~sustain=0.8, ~release=1.5),
        modulationEnvelope: makeEnvelope(~attack=0.2, ~decay=0.1, ~sustain=0.5, ~release=0.8),
      })
      synth->Tone.AMSynth.asAudioNode
      ->Tone.AudioNode.connect(reverb->Tone.Reverb.asAudioNode)
      ->ignore
      reverb->Tone.Reverb.asAudioNode->Tone.AudioNode.toDestination->ignore
      synthRef := Some(synth)
      reverbRef := Some(reverb)
      Signal.set(isReady, true)
    }

    let notes = ["C3", "E3", "G3", "A3", "C4", "E4"]

    let playNote = (note: string) => _ => {
      switch synthRef.contents {
      | Some(synth) => {
          synth->Tone.AMSynth.triggerAttackRelease(toFreq(note), toTime("1n"))->ignore
          Signal.set(activeNote, note)
          setTimeout(() => Signal.set(activeNote, ""), 600)
        }
      | None => ()
      }
    }

    let changeHarmonicity = evt => {
      let val: string = Obj.magic(evt)["target"]["value"]
      let intVal = Int.fromString(val)->Option.getOr(3)
      Signal.set(harmonicity, intVal)
      // Recreate synth with new harmonicity
      switch (synthRef.contents, reverbRef.contents) {
      | (Some(_), Some(reverb)) => {
          let synth = Tone.AMSynth.makeWithOptions({
            harmonicity: Int.toFloat(intVal),
            oscillator: {\"type": Sine},
            modulation: {\"type": Square},
            envelope: makeEnvelope(~attack=0.5, ~decay=0.3, ~sustain=0.8, ~release=1.5),
            modulationEnvelope: makeEnvelope(~attack=0.2, ~decay=0.1, ~sustain=0.5, ~release=0.8),
          })
          synth->Tone.AMSynth.asAudioNode
          ->Tone.AudioNode.connect(reverb->Tone.Reverb.asAudioNode)
          ->ignore
          synthRef := Some(synth)
        }
      | _ => ()
      }
    }

    <div class="demo-card">
      <div class="demo-header">
        <h3> {Component.text("AM Synth Pad")} </h3>
        <p> {Component.text("Amplitude Modulation synthesis with reverb. Adjust harmonicity to change the modulation character.")} </p>
      </div>
      <div class="demo-body">
        {Component.signalFragment(
          Computed.make(() => {
            if Signal.get(isReady) {
              [
                <div class="demo-controls">
                  <div class="demo-slider-group">
                    <span class="demo-label">
                      {Component.textSignal(() =>
                        "Harmonicity: " ++ Int.toString(Signal.get(harmonicity))
                      )}
                    </span>
                    {Component.element(
                      "input",
                      ~attrs=[
                        Component.attr("type", "range"),
                        Component.attr("min", "1"),
                        Component.attr("max", "12"),
                        Component.computedAttr("value", () => Int.toString(Signal.get(harmonicity))),
                        Component.attr("class", "demo-slider"),
                      ],
                      ~events=[("input", changeHarmonicity)],
                      (),
                    )}
                  </div>
                </div>,
                <div class="demo-note-grid">
                  {Component.fragment(
                    notes->Array.map(note => {
                      Component.element(
                        "button",
                        ~attrs=[
                          Component.computedAttr("class", () =>
                            "demo-note-btn pad-btn" ++
                            (Signal.get(activeNote) == note ? " active" : "")
                          ),
                        ],
                        ~events=[("click", playNote(note))],
                        ~children=[Component.text(note)],
                        (),
                      )
                    }),
                  )}
                </div>,
              ]
            } else {
              [
                Component.element(
                  "button",
                  ~attrs=[Component.attr("class", "btn btn-primary demo-start-btn")],
                  ~events=[("click", initAudio)],
                  ~children=[Component.text("Start Audio")],
                  (),
                ),
              ]
            }
          }),
        )}
      </div>
      <div class="demo-source">
        <CodeBlock
          code={`open Tone

let reverb = Reverb.makeWithOptions({decay: 4.0, wet: 0.6})

let synth = AMSynth.makeWithOptions({
  harmonicity: 3.0,
  oscillator: {"type": "sine"},
  modulation: {"type": "square"},
  envelope: {attack: 0.5, decay: 0.3, sustain: 0.8, release: 1.5},
  modulationEnvelope: {
    attack: 0.2, decay: 0.1, sustain: 0.5, release: 0.8,
  },
})

synth->AMSynth.asAudioNode
->AudioNode.connect(reverb->Reverb.asAudioNode)
->AudioNode.toDestination

synth->AMSynth.triggerAttackRelease("C3", "1n")`}
        />
      </div>
    </div>
  }
}

// ---- Page ----
type props = {}

let make = (_props: props) => {
  <article class="docs-article">
    <h1 id="examples"> {Component.text("Interactive Examples")} </h1>
    <p>
      {Component.text(
        "Try these live demos built with rescript-tone and xote. Click \"Start Audio\" to initialize the Web Audio context, then interact with each demo.",
      )}
    </p>

    <h2 id="synth-keyboard"> {Component.text("Synth Keyboard")} </h2>
    <SynthKeyboard />

    <h2 id="effects-chain"> {Component.text("Effects Chain")} </h2>
    <EffectsChain />

    <h2 id="step-sequencer"> {Component.text("Step Sequencer")} </h2>
    <SequencerDemo />

    <h2 id="melody-sequencer"> {Component.text("Melody Sequencer")} </h2>
    <MelodyDemo />

    <h2 id="drum-machine"> {Component.text("Drum Machine")} </h2>
    <DrumMachine />

    <h2 id="filter-sweep"> {Component.text("Filter Sweep")} </h2>
    <FilterSweep />

    <h2 id="polyphonic-chords"> {Component.text("Polyphonic Chords")} </h2>
    <PolyChordsDemo />

    <h2 id="am-synth-pad"> {Component.text("AM Synth Pad")} </h2>
    <AMSynthPad />
  </article>
}
