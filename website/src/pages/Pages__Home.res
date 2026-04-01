open Xote

// ---- JS bindings ----
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
      </div>
    </section>
  }
}

// ---- Sound Grid ----
// An Ableton-inspired beat grid. Each row is a different Tone.js
// instrument; each column is a step in time. Toggle cells to build
// a pattern — all rows play together through a shared Transport.

module SoundGrid = {
  type props = {}

  // Pentatonic notes per column so random toggling always sounds musical
  let melodyNotes = ["C4", "D4", "E4", "G4", "A4", "G4", "E4", "D4"]
  let bassNotes = ["C2", "C2", "E2", "E2", "G2", "G2", "C3", "C2"]
  let numSteps = 8

  // Row metadata
  type row = {
    label: string,
    code: string,
    color: string,
  }

  let rows: array<row> = [
    {
      label: "Lead",
      code: `Synth.triggerAttackRelease("C4", "8n")`,
      color: "pink",
    },
    {
      label: "Bass",
      code: `FMSynth -> Reverb -> Destination`,
      color: "green",
    },
    {
      label: "Beat",
      code: `Loop.make(callback, "8n")`,
      color: "purple",
    },
  ]

  let make = (_props: props) => {
    let isReady = Signal.make(false)
    let isPlaying = Signal.make(false)
    let currentStep = Signal.make(-1)
    let bpm = Signal.make(110)

    // 3 rows × 8 steps; preset a musical default pattern
    let grid =
      rows->Array.mapWithIndex((_, rowIdx) => {
        Array.fromInitializer(~length=numSteps, i => {
          let default = switch rowIdx {
          // Lead: beats 1, 3, 5, 7 (offbeats)
          | 0 => mod(i, 2) == 0
          // Bass: beats 1, 5
          | 1 => i == 0 || i == 4
          // Beat: every other
          | 2 => mod(i, 2) == 1
          | _ => false
          }
          Signal.make(default)
        })
      })

    let leadRef: ref<option<Tone.Synth.t>> = ref(None)
    let bassRef: ref<option<Tone.FMSynth.t>> = ref(None)
    let beatRef: ref<option<Tone.Synth.t>> = ref(None)
    let reverbRef: ref<option<Tone.Reverb.t>> = ref(None)
    let loopRef: ref<option<Tone.Loop.t>> = ref(None)

    let initAudio = _ => {
      let _ = Tone.Core.start()

      // Lead: bright triangle synth
      let lead = Tone.Synth.makeWithOptions({
        oscillator: {\"type": Triangle},
        envelope: makeEnvelope(~attack=0.02, ~decay=0.15, ~sustain=0.2, ~release=0.4),
        volume: -8.0,
      })
      lead->Tone.Synth.asAudioNode->Tone.AudioNode.toDestination->ignore

      // Bass: warm FM synth through reverb
      let reverb = Tone.Reverb.makeWithOptions({decay: 2.0, wet: 0.3})
      let bass = Tone.FMSynth.makeWithOptions({
        volume: -6.0,
      })
      bass->Tone.FMSynth.asAudioNode
      ->Tone.AudioNode.connect(reverb->Tone.Reverb.asAudioNode)
      ->ignore
      reverb->Tone.Reverb.asAudioNode->Tone.AudioNode.toDestination->ignore

      // Beat: short percussive square burst
      let beat = Tone.Synth.makeWithOptions({
        oscillator: {\"type": Square},
        envelope: makeEnvelope(~attack=0.001, ~decay=0.08, ~sustain=0.0, ~release=0.05),
        volume: -10.0,
      })
      beat->Tone.Synth.asAudioNode->Tone.AudioNode.toDestination->ignore

      let transport = Tone.Core.getTransport()
      Tone.Transport.bpm(transport)->Tone.Param.setValue(110.0)

      let stepIdx = ref(0)
      let loop = Tone.Loop.make(_time => {
        let col = mod(stepIdx.contents, numSteps)
        Signal.set(currentStep, col)

        // Lead
        let leadRow = grid->Array.getUnsafe(0)
        let leadOn = Signal.get(leadRow->Array.getUnsafe(col))
        if leadOn {
          let note = melodyNotes->Array.getUnsafe(col)
          lead->Tone.Synth.triggerAttackRelease(toFreq(note), toTime("16n"))->ignore
        }

        // Bass
        let bassRow = grid->Array.getUnsafe(1)
        let bassOn = Signal.get(bassRow->Array.getUnsafe(col))
        if bassOn {
          let note = bassNotes->Array.getUnsafe(col)
          bass->Tone.FMSynth.triggerAttackRelease(toFreq(note), toTime("8n"))->ignore
        }

        // Beat
        let beatRow = grid->Array.getUnsafe(2)
        let beatOn = Signal.get(beatRow->Array.getUnsafe(col))
        if beatOn {
          beat->Tone.Synth.triggerAttackRelease(toFreq("G5"), toTime("32n"))->ignore
        }

        stepIdx := stepIdx.contents + 1
      }, toTime("8n"))

      leadRef := Some(lead)
      bassRef := Some(bass)
      beatRef := Some(beat)
      reverbRef := Some(reverb)
      loopRef := Some(loop)
      Signal.set(isReady, true)
    }

    // Suppress unused var warnings
    let _ = (leadRef, bassRef, beatRef, reverbRef)

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

    let changeBpm = evt => {
      let val: string = Obj.magic(evt)["target"]["value"]
      let intVal = Int.fromString(val)->Option.getOr(110)
      Signal.set(bpm, intVal)
      Tone.Transport.bpm(Tone.Core.getTransport())->Tone.Param.setValue(Int.toFloat(intVal))
    }

    <section class="grid-section">
      <div class="grid-container">
        <div class="grid-header">
          <h2 class="grid-title"> {Component.text("Make some noise")} </h2>
          <p class="grid-subtitle">
            {Component.text("Toggle cells to build a pattern. Each row is a different Tone.js instrument — they all play together.")}
          </p>
        </div>

        {Component.signalFragment(
          Computed.make(() => {
            if Signal.get(isReady) {
              [
                // Transport controls
                <div class="grid-controls">
                  {Component.element(
                    "button",
                    ~attrs=[
                      Component.computedAttr("class", () =>
                        "grid-play-btn" ++ (Signal.get(isPlaying) ? " playing" : "")
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
                  <div class="grid-bpm">
                    <span class="grid-bpm-label">
                      {Component.textSignal(() =>
                        Int.toString(Signal.get(bpm)) ++ " bpm"
                      )}
                    </span>
                    {Component.element(
                      "input",
                      ~attrs=[
                        Component.attr("type", "range"),
                        Component.attr("min", "60"),
                        Component.attr("max", "180"),
                        Component.computedAttr("value", () => Int.toString(Signal.get(bpm))),
                        Component.attr("class", "grid-bpm-slider"),
                      ],
                      ~events=[("input", changeBpm)],
                      (),
                    )}
                  </div>
                </div>,

                // The grid
                <div class="sg">
                  // Step numbers header
                  <div class="sg-header">
                    <div class="sg-label-spacer" />
                    {Component.fragment(
                      Array.fromInitializer(~length=numSteps, i => {
                        Component.element(
                          "div",
                          ~attrs=[
                            Component.computedAttr("class", () =>
                              "sg-col-num" ++ (Signal.get(currentStep) == i ? " active" : "")
                            ),
                          ],
                          ~children=[Component.text(Int.toString(i + 1))],
                          (),
                        )
                      }),
                    )}
                  </div>

                  // Instrument rows
                  {Component.fragment(
                    rows->Array.mapWithIndex((row, rowIdx) => {
                      let rowSignals = grid->Array.getUnsafe(rowIdx)
                      <div class={"sg-row sg-row-" ++ row.color}>
                        <div class="sg-label">
                          <span class="sg-label-name"> {Component.text(row.label)} </span>
                          <code class="sg-label-code"> {Component.text(row.code)} </code>
                        </div>
                        {Component.fragment(
                          rowSignals->Array.mapWithIndex((cellSig, colIdx) => {
                            Component.element(
                              "button",
                              ~attrs=[
                                Component.computedAttr("class", () => {
                                  let on = Signal.get(cellSig)
                                  let isCurrent = Signal.get(currentStep) == colIdx
                                  "sg-cell" ++
                                  (on ? " on" : "") ++
                                  (isCurrent && on ? " pulse" : "") ++
                                  (isCurrent ? " current" : "")
                                }),
                              ],
                              ~events=[("click", _ => Signal.update(cellSig, v => !v))],
                              (),
                            )
                          }),
                        )}
                      </div>
                    }),
                  )}
                </div>,
              ]
            } else {
              [
                <div class="grid-start">
                  {Component.element(
                    "button",
                    ~attrs=[Component.attr("class", "grid-start-btn")],
                    ~events=[("click", initAudio)],
                    ~children=[
                      Component.text("Start Audio"),
                    ],
                    (),
                  )}
                  <span class="grid-start-hint">
                    {Component.text("Click to enable Web Audio, then toggle cells to create a pattern.")}
                  </span>
                </div>,
              ]
            }
          }),
        )}

        <div class="grid-footer">
          {Router.link(
            ~to="/examples",
            ~attrs=[Component.attr("class", "grid-more-link")],
            ~children=[
              Component.text("Explore more examples "),
              Basefn.Icon.make({name: ChevronRight, size: Sm}),
            ],
            (),
          )}
        </div>
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
    <SoundGrid />
    <Features />
    <CTA />
  </>
}
