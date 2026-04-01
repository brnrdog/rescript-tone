open Xote

// ---- JS bindings ----
@val external navigator: {..} = "navigator"
@val external setTimeout: (unit => unit, int) => unit = "setTimeout"

let toFreq: string => 'a = Obj.magic
let toTime: string => 'a = Obj.magic
let floatToTime: float => 'a = Obj.magic

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

// ---- Hero ----
module Hero = {
  type props = {}

  let make = (_props: props) => {
    <section class="hero">
      <div class="hero-backdrop" />
      <div class="hero-content">
        <h1 class="hero-title">
          <span class="hero-title-accent"> {Component.text("rescript-tone")} </span>
        </h1>
        <p class="hero-subtitle">
          {Component.text(
            "Type-safe ReScript bindings for Tone.js. Build interactive music and audio applications in the browser.",
          )}
        </p>
        <div class="hero-actions">
          {Router.link(
            ~to="/getting-started",
            ~attrs=[Component.attr("class", "btn btn-primary")],
            ~children=[
              Component.text("Get Started "),
              Basefn.Icon.make({name: ChevronRight, size: Sm}),
            ],
            (),
          )}
          {Component.element(
            "a",
            ~attrs=[
              Component.attr("class", "btn btn-secondary"),
              Component.attr("href", "https://github.com/brnrdog/rescript-tone"),
              Component.attr("target", "_blank"),
              Component.attr("rel", "noopener noreferrer"),
            ],
            ~children=[
              Basefn.Icon.make({name: GitHub, size: Sm}),
              Component.text(" GitHub"),
            ],
            (),
          )}
        </div>
        <div class="hero-install">
          <code> {Component.text("npm install rescript-tone tone")} </code>
        </div>
      </div>
    </section>
  }
}

// ---- Mini Synth Demo ----
module MiniSynth = {
  type props = {}

  let notes = ["C4", "D4", "E4", "F4", "G4", "A4", "B4", "C5"]
  let labels = ["C", "D", "E", "F", "G", "A", "B", "C"]

  let make = (_props: props) => {
    let isReady = Signal.make(false)
    let activeNote = Signal.make("")
    let synthRef: ref<option<Tone.Synth.t>> = ref(None)

    let initAudio = _ => {
      let _ = Tone.Core.start()
      let synth = Tone.Synth.makeWithOptions({
        oscillator: {\"type": Triangle},
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

    <div class="mini-demo">
      <div class="mini-demo-label"> {Component.text("Synth")} </div>
      <div class="mini-demo-body">
        {Component.signalFragment(
          Computed.make(() => {
            if Signal.get(isReady) {
              [
                <div class="mini-piano">
                  {Component.fragment(
                    notes->Array.mapWithIndex((note, i) => {
                      Component.element(
                        "button",
                        ~attrs=[
                          Component.computedAttr("class", () =>
                            "mini-key" ++ (Signal.get(activeNote) == note ? " active" : "")
                          ),
                        ],
                        ~events=[("click", playNote(note))],
                        ~children=[
                          Component.text(
                            switch labels->Array.get(i) {
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
                  ~attrs=[Component.attr("class", "mini-start-btn")],
                  ~events=[("click", initAudio)],
                  ~children=[
                    Basefn.Icon.make({name: ChevronRight, size: Sm}),
                    Component.text(" Play"),
                  ],
                  (),
                ),
              ]
            }
          }),
        )}
      </div>
      <div class="mini-demo-code">
        <code>
          {Component.text(`Synth.triggerAttackRelease("C4", "8n")`)}
        </code>
      </div>
    </div>
  }
}

// ---- Mini Effects Demo ----
module MiniEffects = {
  type props = {}

  let make = (_props: props) => {
    let isReady = Signal.make(false)
    let reverbWet = Signal.make(50)
    let activeNote = Signal.make("")

    let synthRef: ref<option<Tone.FMSynth.t>> = ref(None)
    let reverbRef: ref<option<Tone.Reverb.t>> = ref(None)

    let initAudio = _ => {
      let _ = Tone.Core.start()
      let synth = Tone.FMSynth.make()
      let reverb = Tone.Reverb.makeWithOptions({decay: 3.0, wet: 0.5})
      synth->Tone.FMSynth.asAudioNode
      ->Tone.AudioNode.connect(reverb->Tone.Reverb.asAudioNode)
      ->ignore
      reverb->Tone.Reverb.asAudioNode->Tone.AudioNode.toDestination->ignore
      synthRef := Some(synth)
      reverbRef := Some(reverb)
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

    let notes = ["C3", "E3", "G3", "C4"]

    <div class="mini-demo">
      <div class="mini-demo-label"> {Component.text("Effects")} </div>
      <div class="mini-demo-body">
        {Component.signalFragment(
          Computed.make(() => {
            if Signal.get(isReady) {
              [
                <div class="mini-controls">
                  <span class="mini-slider-label">
                    {Component.textSignal(() =>
                      "Reverb " ++ Int.toString(Signal.get(reverbWet)) ++ "%"
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
                      Component.attr("class", "mini-slider"),
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
                </div>,
                <div class="mini-note-row">
                  {Component.fragment(
                    notes->Array.map(note => {
                      Component.element(
                        "button",
                        ~attrs=[
                          Component.computedAttr("class", () =>
                            "mini-note" ++ (Signal.get(activeNote) == note ? " active" : "")
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
                  ~attrs=[Component.attr("class", "mini-start-btn")],
                  ~events=[("click", initAudio)],
                  ~children=[
                    Basefn.Icon.make({name: ChevronRight, size: Sm}),
                    Component.text(" Play"),
                  ],
                  (),
                ),
              ]
            }
          }),
        )}
      </div>
      <div class="mini-demo-code">
        <code>
          {Component.text(`FMSynth -> Reverb -> Destination`)}
        </code>
      </div>
    </div>
  }
}

// ---- Mini Sequencer Demo ----
module MiniSequencer = {
  type props = {}

  let make = (_props: props) => {
    let isReady = Signal.make(false)
    let isPlaying = Signal.make(false)
    let currentStep = Signal.make(-1)

    let steps = [true, false, true, false, true, true, false, true]
    let stepSignals = steps->Array.map(v => Signal.make(v))
    let stepNotes = ["C4", "D4", "E4", "F4", "G4", "A4", "B4", "C5"]

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
        let isActive = switch stepSignals->Array.get(idx) {
        | Some(s) => Signal.get(s)
        | None => false
        }
        if isActive {
          let note = switch stepNotes->Array.get(idx) {
          | Some(n) => n
          | None => "C4"
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
      if Signal.get(isPlaying) {
        switch loopRef.contents {
        | Some(loop) => loop->Tone.Loop.stop->ignore
        | None => ()
        }
        Tone.Core.getTransport()->Tone.Transport.stop->ignore
        Signal.set(isPlaying, false)
        Signal.set(currentStep, -1)
      } else {
        switch loopRef.contents {
        | Some(loop) => loop->Tone.Loop.start->ignore
        | None => ()
        }
        Tone.Core.getTransport()->Tone.Transport.start->ignore
        Signal.set(isPlaying, true)
      }
    }

    <div class="mini-demo">
      <div class="mini-demo-label"> {Component.text("Sequencer")} </div>
      <div class="mini-demo-body">
        {Component.signalFragment(
          Computed.make(() => {
            if Signal.get(isReady) {
              [
                <div class="mini-seq-row">
                  {Component.element(
                    "button",
                    ~attrs=[
                      Component.computedAttr("class", () =>
                        "mini-play-btn" ++ (Signal.get(isPlaying) ? " playing" : "")
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
                  <div class="mini-steps">
                    {Component.fragment(
                      stepSignals->Array.mapWithIndex((stepSig, i) => {
                        Component.element(
                          "button",
                          ~attrs=[
                            Component.computedAttr("class", () => {
                              let active = Signal.get(stepSig)
                              let isCurrent = Signal.get(currentStep) == i
                              "mini-step" ++
                              (active ? " on" : "") ++
                              (isCurrent ? " current" : "")
                            }),
                          ],
                          ~events=[("click", _ => Signal.update(stepSig, v => !v))],
                          (),
                        )
                      }),
                    )}
                  </div>
                </div>,
              ]
            } else {
              [
                Component.element(
                  "button",
                  ~attrs=[Component.attr("class", "mini-start-btn")],
                  ~events=[("click", initAudio)],
                  ~children=[
                    Basefn.Icon.make({name: ChevronRight, size: Sm}),
                    Component.text(" Play"),
                  ],
                  (),
                ),
              ]
            }
          }),
        )}
      </div>
      <div class="mini-demo-code">
        <code>
          {Component.text(`Loop.make(fn, "8n") -> Transport.start()`)}
        </code>
      </div>
    </div>
  }
}

// ---- Demos Grid ----
module DemosGrid = {
  type props = {}

  let make = (_props: props) => {
    <section class="demos-section">
      <div class="demos-grid">
        <MiniSynth />
        <MiniEffects />
        <MiniSequencer />
      </div>
      <div class="demos-cta">
        {Router.link(
          ~to="/examples",
          ~attrs=[Component.attr("class", "demos-more-link")],
          ~children=[
            Component.text("See all examples "),
            Basefn.Icon.make({name: ChevronRight, size: Sm}),
          ],
          (),
        )}
      </div>
    </section>
  }
}

// ---- Features ----
type feature = {
  iconName: Basefn.iconName,
  title: string,
  description: string,
}

let features: array<feature> = [
  {
    iconName: Basefn.Icon.Check,
    title: "Type-Safe",
    description: "Catch errors at compile time. Every synth, effect, and parameter is fully typed.",
  },
  {
    iconName: Basefn.Icon.Loader,
    title: "Zero Overhead",
    description: "Direct bindings with no wrapper layer. Compiles to clean Tone.js calls.",
  },
  {
    iconName: Basefn.Icon.Download,
    title: "Modular",
    description: "Import only what you need. Each module maps to a Tone.js class.",
  },
]

module Features = {
  type props = {}

  let make = (_props: props) => {
    <section class="features-section">
      <div class="features-list">
        {Component.fragment(
          features->Array.map(f => {
            <div class="feature-item">
              <div class="feature-icon">
                {Basefn.Icon.make({name: f.iconName, size: Sm})}
              </div>
              <div>
                <div class="feature-title"> {Component.text(f.title)} </div>
                <p class="feature-desc"> {Component.text(f.description)} </p>
              </div>
            </div>
          }),
        )}
      </div>
    </section>
  }
}

// ---- CTA ----
module CTA = {
  type props = {}

  let make = (_props: props) => {
    <section class="cta-section">
      <h2 class="cta-title"> {Component.text("Ready to build?")} </h2>
      <p class="cta-desc">
        {Component.text("Add rescript-tone to your project and start creating audio experiences.")}
      </p>
      <div class="cta-install">
        <code> {Component.text("npm install rescript-tone tone")} </code>
      </div>
      <div class="cta-actions">
        {Router.link(
          ~to="/getting-started",
          ~attrs=[Component.attr("class", "btn btn-primary")],
          ~children=[
            Component.text("Get Started "),
            Basefn.Icon.make({name: ChevronRight, size: Sm}),
          ],
          (),
        )}
        {Router.link(
          ~to="/api/core",
          ~attrs=[Component.attr("class", "btn btn-secondary")],
          ~children=[Component.text("API Reference")],
          (),
        )}
      </div>
    </section>
  }
}

// ---- Page ----
type props = {}

let make = (_props: props) => {
  <>
    <Hero />
    <DemosGrid />
    <Features />
    <CTA />
  </>
}
