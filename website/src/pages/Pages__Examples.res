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

    <h2 id="code-examples"> {Component.text("More Code Examples")} </h2>

    <h3 id="simple-melody"> {Component.text("Simple Melody")} </h3>
    <p>
      {Component.text(
        "Play a sequence of notes using Sequence and the Transport.",
      )}
    </p>
    <CodeBlock
      code={`open Tone

let synth = Synth.makeWithOptions({
  oscillator: {"type": "triangle"},
  envelope: {attack: 0.01, decay: 0.1, sustain: 0.3, release: 0.5},
})
synth->Synth.asAudioNode->AudioNode.toDestination

let notes = ["C4", "D4", "E4", "F4", "G4", "A4", "B4", "C5"]

let _seq = Sequence.make((_time, note) => {
  synth->Synth.triggerAttackRelease(note, "8n")
}, notes, "4n")

let startButton = async () => {
  await Core.start()
  let transport = Core.getTransport()
  transport->Transport.start()
}`}
    />

    <h3 id="drum-pattern"> {Component.text("Drum Pattern")} </h3>
    <p>
      {Component.text(
        "Use Loop and Transport to create a repeating drum pattern.",
      )}
    </p>
    <CodeBlock
      code={`open Tone

let kick = Synth.makeWithOptions({
  oscillator: {"type": "sine"},
  envelope: {attack: 0.001, decay: 0.2, sustain: 0.0, release: 0.2},
})
kick->Synth.asAudioNode->AudioNode.toDestination

let hihat = Noise.makeWithOptions({
  "type": "white",
  volume: -20.0,
})
hihat->Noise.asAudioNode->AudioNode.toDestination

let transport = Core.getTransport()

// Kick on every beat
let _kickLoop = Loop.make(_time => {
  kick->Synth.triggerAttackRelease("C1", "8n")
}, "4n")

// Hi-hat on every eighth note
let _hatLoop = Loop.make(_time => {
  hihat->Noise.start()
  hihat->Noise.stop(~time="+32n")
}, "8n")

transport->Transport.start()`}
    />

    <h3 id="parameter-automation"> {Component.text("Parameter Automation")} </h3>
    <p>
      {Component.text(
        "Automate parameters over time for expressive control.",
      )}
    </p>
    <CodeBlock
      code={`open Tone

let osc = Oscillator.makeWithOptions({
  frequency: 200.0,
  "type": "sawtooth",
})

let filter = Filter.makeWithOptions({
  frequency: 500.0,
  "type": "lowpass",
  rolloff: -24,
})

osc->Oscillator.asAudioNode
->AudioNode.connect(filter->Filter.asAudioNode)
->AudioNode.toDestination

// Automate filter cutoff
let cutoff = filter->Filter.frequency
cutoff->Param.rampTo(2000.0, "2m")

osc->Oscillator.start()`}
    />
  </article>
}
