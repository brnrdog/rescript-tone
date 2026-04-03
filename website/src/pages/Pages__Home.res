open Xote

@val external setTimeout: (unit => unit, int) => unit = "setTimeout"
@val external windowOn: (string, 'a => unit) => unit = "window.addEventListener"
@send external slice: array<'a> => array<'a> = "slice"
@send external toFixed: (float, int) => string = "toFixed"

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
          <span class="hero-title-accent">{Component.text("rescript-tone")}</span>
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
// An Ableton Learning Music-inspired multi-track sequencer with 4 tracks:
// Beats, Chords, Bass, and Melody — all play together through a shared Transport.

module SoundGrid = {
  let numSteps = 8

  type dragState = {
    sig: Signal.t<float>,
    min: float,
    max: float,
    startY: float,
    startVal: float,
    onParam: float => unit,
  }

  let dragRef: ref<option<dragState>> = ref(None)

  let clamp = (v: float, lo: float, hi: float): float => {
    if v < lo {
      lo
    } else if v > hi {
      hi
    } else {
      v
    }
  }

  let toggleCell = (rowSig: Signal.t<array<bool>>, colIdx: int) => {
    let arr = Signal.get(rowSig)->slice
    let cur = arr->Array.getUnsafe(colIdx)
    arr->Array.setUnsafe(colIdx, !cur)
    Signal.set(rowSig, arr)
  }

  let exclusiveToggle = (
    rowSigs: array<Signal.t<array<bool>>>,
    rowIdx: int,
    colIdx: int,
  ) => {
    let targetSig = rowSigs->Array.getUnsafe(rowIdx)
    let targetArr = Signal.get(targetSig)
    let isOn = targetArr->Array.getUnsafe(colIdx)

    // Turn off all rows in this column
    rowSigs->Array.forEachWithIndex((sig, _rIdx) => {
      let arr = Signal.get(sig)->slice
      arr->Array.setUnsafe(colIdx, false)
      Signal.set(sig, arr)
    })

    // If it wasn't on, turn it on
    if !isOn {
      let arr = Signal.get(targetSig)->slice
      arr->Array.setUnsafe(colIdx, true)
      Signal.set(targetSig, arr)
    }
  }

  let renderRows = (
    ~rowLabels: array<string>,
    ~rowSigs: array<Signal.t<array<bool>>>,
    ~currentStep: Signal.t<int>,
    ~exclusive: bool,
  ) => {
    Component.fragment(
      rowLabels->Array.mapWithIndex((label, rowIdx) => {
        let rowSig = rowSigs->Array.getUnsafe(rowIdx)
        <div class="sg-row">
          <div class="sg-row-label">{Component.text(label)}</div>
          {Component.fragment(
            Array.fromInitializer(~length=numSteps, colIdx => {
              Component.element(
                "button",
                ~attrs=[
                  Component.computedAttr("class", () => {
                    let arr = Signal.get(rowSig)
                    let on = arr->Array.getUnsafe(colIdx)
                    let cur = Signal.get(currentStep) == colIdx
                    "sg-cell"
                    ++ (on ? " on" : "")
                    ++ (cur && on ? " pulse" : "")
                    ++ (cur ? " current" : "")
                  }),
                ],
                ~events=[
                  (
                    "click",
                    _ =>
                      if exclusive {
                        exclusiveToggle(rowSigs, rowIdx, colIdx)
                      } else {
                        toggleCell(rowSig, colIdx)
                      },
                  ),
                ],
                (),
              )
            }),
          )}
        </div>
      }),
    )
  }

  let renderKnob = (
    ~label: string,
    ~sig: Signal.t<float>,
    ~min: float,
    ~max: float,
    ~color: string,
    ~fmt: float => string,
    ~onParam: float => unit,
  ) => {
    <div class="fx-knob">
      {Component.element(
        "div",
        ~attrs=[
          Component.attr("class", "fx-knob-dial"),
          Component.computedAttr("style", () => {
            let v = Signal.get(sig)
            let pct = (v -. min) /. (max -. min)
            let arc = (pct *. 300.0)->toFixed(1)
            `background: conic-gradient(from 210deg, ${color} 0deg ${arc}deg, var(--bg-tertiary) ${arc}deg 300deg, transparent 300deg 360deg)`
          }),
        ],
        ~events=[
          (
            "mousedown",
            evt => {
              let y: float = Obj.magic(evt)["clientY"]
              dragRef := Some({sig, min, max, startY: y, startVal: Signal.get(sig), onParam})
            },
          ),
          (
            "touchstart",
            evt => {
              let t: {..} = Obj.magic(evt)["touches"]->Array.getUnsafe(0)
              let y: float = t["clientY"]
              dragRef := Some({sig, min, max, startY: y, startVal: Signal.get(sig), onParam})
            },
          ),
        ],
        ~children=[
          <div class="fx-knob-inner" />,
          Component.element(
            "div",
            ~attrs=[
              Component.attr("class", "fx-knob-pointer"),
              Component.computedAttr("style", () => {
                let v = Signal.get(sig)
                let pct = (v -. min) /. (max -. min)
                let deg = (-150.0 +. pct *. 300.0)->toFixed(1)
                `transform: rotate(${deg}deg)`
              }),
            ],
            (),
          ),
        ],
        (),
      )}
      <span class="fx-knob-label">{Component.text(label)}</span>
      <span class="fx-knob-value">
        {Component.textSignal(() => fmt(Signal.get(sig)))}
      </span>
    </div>
  }

  type props = {}

  let make = (_props: props) => {
    let isReady = Signal.make(false)
    let isPlaying = Signal.make(false)
    let currentStep = Signal.make(-1)
    let bpm = Signal.make(113)

    // Beat pattern — 80s four-on-the-floor
    let beatRows = [
      Signal.make([true, false, true, false, true, false, true, false]),   // Kick: every beat
      Signal.make([false, false, true, false, false, false, true, false]), // Snare: 2 & 4
      Signal.make([true, true, true, true, true, true, true, true]),       // HiHat: constant 8ths
      Signal.make([false, false, true, false, false, false, true, false]), // Clap: with snare
    ]
    let beatLabels = ["Kick", "Snare", "HiHat", "Clap"]

    // Chord pattern — I vi IV V (C Am F G)
    let chordRows = [
      Signal.make([false, false, true, true, false, false, false, false]), // Am: steps 3-4
      Signal.make([false, false, false, false, true, true, false, false]), // F:  steps 5-6
      Signal.make([true, true, false, false, false, false, false, false]), // C:  steps 1-2
      Signal.make([false, false, false, false, false, false, true, true]), // G:  steps 7-8
    ]
    let chordLabels = ["Am", "F", "C", "G"]

    // Bass pattern — the riff (E G C . . D C .)
    let bassRows = [
      Signal.make([false, false, false, false, false, false, false, false]), // A2
      Signal.make([false, true, false, false, false, false, false, false]),  // G2: step 2
      Signal.make([true, false, false, false, false, false, false, false]),  // E2: step 1
      Signal.make([false, false, false, false, false, true, false, false]),  // D2: step 6
      Signal.make([false, false, true, false, false, false, true, false]),   // C2: steps 3, 7
    ]
    let bassLabels = ["A2", "G2", "E2", "D2", "C2"]

    // Melody — synth hook (D E D G . E D C)
    let melodyRows = [
      Signal.make([false, false, false, false, false, false, false, false]), // A4
      Signal.make([false, false, false, true, false, false, false, false]),  // G4: step 4
      Signal.make([false, true, false, false, false, true, false, false]),   // E4: steps 2, 6
      Signal.make([true, false, true, false, false, false, true, false]),    // D4: steps 1, 3, 7
      Signal.make([false, false, false, false, false, false, false, true]),  // C4: step 8
    ]
    let melodyLabels = ["A4", "G4", "E4", "D4", "C4"]

    // Effect knob signals
    let reverbWet = Signal.make(0.2)
    let delayFb = Signal.make(0.0)
    let filterFreq = Signal.make(8000.0)
    let chorusWet = Signal.make(0.0)

    // Audio refs
    let kickRef: ref<option<Tone.Synth.t>> = ref(None)
    let snareRef: ref<option<Tone.Synth.t>> = ref(None)
    let hihatRef: ref<option<Tone.Synth.t>> = ref(None)
    let clapRef: ref<option<Tone.Synth.t>> = ref(None)
    let chordsRef: ref<option<Tone.PolySynth.t>> = ref(None)
    let bassRef: ref<option<Tone.FMSynth.t>> = ref(None)
    let melodyRef: ref<option<Tone.Synth.t>> = ref(None)
    let filterRef: ref<option<Tone.Filter.t>> = ref(None)
    let chorusRef: ref<option<Tone.Chorus.t>> = ref(None)
    let reverbRef: ref<option<Tone.Reverb.t>> = ref(None)
    let delayRef: ref<option<Tone.FeedbackDelay.t>> = ref(None)
    let loopRef: ref<option<Tone.Loop.t>> = ref(None)

    let updateReverb = (v: float) => {
      switch reverbRef.contents {
      | Some(r) => Tone.Reverb.wet(r)->Tone.Param.setValue(v)
      | None => ()
      }
    }

    let updateDelay = (v: float) => {
      switch delayRef.contents {
      | Some(d) => Tone.FeedbackDelay.feedback(d)->Tone.Param.setValue(v)
      | None => ()
      }
    }

    let updateFilter = (v: float) => {
      switch filterRef.contents {
      | Some(f) => Tone.Filter.frequency(f)->Tone.Param.setValue(v)
      | None => ()
      }
    }

    let updateChorus = (v: float) => {
      switch chorusRef.contents {
      | Some(c) => Tone.Chorus.wet(c)->Tone.Param.setValue(v)
      | None => ()
      }
    }

    let initAudio = _ => {
      let _ = Tone.Core.start()

      // Effects chain: Filter -> Chorus -> Reverb -> FeedbackDelay -> Destination
      let filter = Tone.Filter.makeWithOptions({
        \"type": Lowpass,
        frequency: 8000.0,
      })

      let chorus = Tone.Chorus.makeWithOptions({
        frequency: 1.5,
        delayTime: 3.5,
        depth: 0.7,
        wet: 0.0,
      })
      chorus->Tone.Chorus.start->ignore

      let reverb = Tone.Reverb.makeWithOptions({
        decay: 2.5,
        wet: 0.2,
      })

      let delay = Tone.FeedbackDelay.makeWithOptions({
        delayTime: toTime("8n."),
        feedback: 0.0,
        wet: 0.3,
      })

      let dest = Tone.Core.getDestination()

      // Chain: filter -> chorus -> reverb -> delay -> destination
      filter
      ->Tone.Filter.asAudioNode
      ->Tone.AudioNode.connect(chorus->Tone.Chorus.asAudioNode)
      ->ignore
      chorus
      ->Tone.Chorus.asAudioNode
      ->Tone.AudioNode.connect(reverb->Tone.Reverb.asAudioNode)
      ->ignore
      reverb
      ->Tone.Reverb.asAudioNode
      ->Tone.AudioNode.connect(delay->Tone.FeedbackDelay.asAudioNode)
      ->ignore
      delay
      ->Tone.FeedbackDelay.asAudioNode
      ->Tone.AudioNode.connect(dest->Tone.Destination.asAudioNode)
      ->ignore

      // Kick: Synth sine
      let kick = Tone.Synth.makeWithOptions({
        oscillator: {\"type": Sine},
        envelope: makeEnvelope(~attack=0.001, ~decay=0.2, ~sustain=0.0, ~release=0.1),
        volume: -6.0,
      })
      kick->Tone.Synth.asAudioNode->Tone.AudioNode.connect(filter->Tone.Filter.asAudioNode)->ignore

      // Snare: Synth triangle
      let snare = Tone.Synth.makeWithOptions({
        oscillator: {\"type": Triangle},
        envelope: makeEnvelope(~attack=0.001, ~decay=0.12, ~sustain=0.0, ~release=0.08),
        volume: -8.0,
      })
      snare
      ->Tone.Synth.asAudioNode
      ->Tone.AudioNode.connect(filter->Tone.Filter.asAudioNode)
      ->ignore

      // HiHat: Synth square
      let hihat = Tone.Synth.makeWithOptions({
        oscillator: {\"type": Square},
        envelope: makeEnvelope(~attack=0.001, ~decay=0.04, ~sustain=0.0, ~release=0.02),
        volume: -14.0,
      })
      hihat
      ->Tone.Synth.asAudioNode
      ->Tone.AudioNode.connect(filter->Tone.Filter.asAudioNode)
      ->ignore

      // Clap: Synth sawtooth
      let clap = Tone.Synth.makeWithOptions({
        oscillator: {\"type": Sawtooth},
        envelope: makeEnvelope(~attack=0.001, ~decay=0.1, ~sustain=0.0, ~release=0.06),
        volume: -10.0,
      })
      clap
      ->Tone.Synth.asAudioNode
      ->Tone.AudioNode.connect(filter->Tone.Filter.asAudioNode)
      ->ignore

      // Chords: PolySynth
      let chords = Tone.PolySynth.makeWithOptions({
        maxPolyphony: 8,
        volume: -12.0,
      })
      chords
      ->Tone.PolySynth.asAudioNode
      ->Tone.AudioNode.connect(filter->Tone.Filter.asAudioNode)
      ->ignore

      // Bass: FMSynth
      let bass = Tone.FMSynth.makeWithOptions({
        volume: -8.0,
      })
      bass
      ->Tone.FMSynth.asAudioNode
      ->Tone.AudioNode.connect(filter->Tone.Filter.asAudioNode)
      ->ignore

      // Melody: Synth triangle
      let melody = Tone.Synth.makeWithOptions({
        oscillator: {\"type": Triangle},
        envelope: makeEnvelope(~attack=0.02, ~decay=0.15, ~sustain=0.2, ~release=0.4),
        volume: -6.0,
      })
      melody
      ->Tone.Synth.asAudioNode
      ->Tone.AudioNode.connect(filter->Tone.Filter.asAudioNode)
      ->ignore

      // Transport BPM
      let transport = Tone.Core.getTransport()
      Tone.Transport.bpm(transport)->Tone.Param.setValue(113.0)

      // Chord voicings
      let chordVoicings = [
        ["A3", "C4", "E4"],
        ["F3", "A3", "C4"],
        ["C3", "E3", "G3"],
        ["G3", "B3", "D4"],
      ]

      // Bass notes (high to low: A2, G2, E2, D2, C2)
      let bassNotes = ["A2", "G2", "E2", "D2", "C2"]

      // Melody notes (high to low: A4, G4, E4, D4, C4)
      let melodyNotes = ["A4", "G4", "E4", "D4", "C4"]

      let stepIdx = ref(0)
      let loop = Tone.Loop.make(_time => {
        let col = mod(stepIdx.contents, numSteps)
        Signal.set(currentStep, col)

        // Beats
        let kickArr = Signal.get(beatRows->Array.getUnsafe(0))
        if kickArr->Array.getUnsafe(col) {
          kick->Tone.Synth.triggerAttackRelease(toFreq("C1"), toTime("16n"))->ignore
        }
        let snareArr = Signal.get(beatRows->Array.getUnsafe(1))
        if snareArr->Array.getUnsafe(col) {
          snare->Tone.Synth.triggerAttackRelease(toFreq("E3"), toTime("16n"))->ignore
        }
        let hihatArr = Signal.get(beatRows->Array.getUnsafe(2))
        if hihatArr->Array.getUnsafe(col) {
          hihat->Tone.Synth.triggerAttackRelease(toFreq("G5"), toTime("32n"))->ignore
        }
        let clapArr = Signal.get(beatRows->Array.getUnsafe(3))
        if clapArr->Array.getUnsafe(col) {
          clap->Tone.Synth.triggerAttackRelease(toFreq("C4"), toTime("16n"))->ignore
        }

        // Chords
        chordRows->Array.forEachWithIndex((sig, rIdx) => {
          let arr = Signal.get(sig)
          if arr->Array.getUnsafe(col) {
            let voicing = chordVoicings->Array.getUnsafe(rIdx)
            let freqs: array<Tone.Types.frequency> = voicing->Array.map(n => toFreq(n))
            chords->Tone.PolySynth.triggerAttackRelease(freqs, toTime("4n"))->ignore
          }
        })

        // Bass
        bassRows->Array.forEachWithIndex((sig, rIdx) => {
          let arr = Signal.get(sig)
          if arr->Array.getUnsafe(col) {
            let note = bassNotes->Array.getUnsafe(rIdx)
            bass->Tone.FMSynth.triggerAttackRelease(toFreq(note), toTime("8n"))->ignore
          }
        })

        // Melody
        melodyRows->Array.forEachWithIndex((sig, rIdx) => {
          let arr = Signal.get(sig)
          if arr->Array.getUnsafe(col) {
            let note = melodyNotes->Array.getUnsafe(rIdx)
            melody->Tone.Synth.triggerAttackRelease(toFreq(note), toTime("8n"))->ignore
          }
        })

        stepIdx := stepIdx.contents + 1
      }, toTime("8n"))

      kickRef := Some(kick)
      snareRef := Some(snare)
      hihatRef := Some(hihat)
      clapRef := Some(clap)
      chordsRef := Some(chords)
      bassRef := Some(bass)
      melodyRef := Some(melody)
      filterRef := Some(filter)
      chorusRef := Some(chorus)
      reverbRef := Some(reverb)
      delayRef := Some(delay)
      loopRef := Some(loop)

      // Global window listeners for knob drag
      windowOn("mousemove", evt => {
        switch dragRef.contents {
        | Some(state) => {
            let y: float = Obj.magic(evt)["clientY"]
            let range = state.max -. state.min
            let delta = (state.startY -. y) /. 150.0
            let newVal = clamp(state.startVal +. delta *. range, state.min, state.max)
            Signal.set(state.sig, newVal)
            state.onParam(newVal)
          }
        | None => ()
        }
      })

      windowOn("mouseup", _evt => {
        dragRef := None
      })

      windowOn("touchmove", evt => {
        switch dragRef.contents {
        | Some(state) => {
            let t: {..} = Obj.magic(evt)["touches"]->Array.getUnsafe(0)
            let y: float = t["clientY"]
            let range = state.max -. state.min
            let delta = (state.startY -. y) /. 150.0
            let newVal = clamp(state.startVal +. delta *. range, state.min, state.max)
            Signal.set(state.sig, newVal)
            state.onParam(newVal)
          }
        | None => ()
        }
      })

      windowOn("touchend", _evt => {
        dragRef := None
      })

      Signal.set(isReady, true)
    }

    // Suppress unused warnings
    let _ = (kickRef, snareRef, hihatRef, clapRef, chordsRef, bassRef, melodyRef, filterRef, chorusRef, reverbRef, delayRef)

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
      let intVal = Int.fromString(val)->Option.getOr(113)
      Signal.set(bpm, intVal)
      Tone.Transport.bpm(Tone.Core.getTransport())->Tone.Param.setValue(Int.toFloat(intVal))
    }

    <section class="grid-section">
      <div class="grid-container">
        <div class="grid-header">
          <h2 class="grid-title">{Component.text("Make some noise")}</h2>
          <p class="grid-subtitle">
            {Component.text(
              "Four tracks, one sequencer. Toggle cells to build a pattern — beats, chords, bass, and melody all play together.",
            )}
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
                      Component.textSignal(() => Signal.get(isPlaying) ? "Stop" : "Play"),
                    ],
                    (),
                  )}
                  <div class="grid-bpm">
                    <span class="grid-bpm-label">
                      {Component.textSignal(() => Int.toString(Signal.get(bpm)) ++ " bpm")}
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
                // Track cards in 2x2 grid
                <div class="sg-cards">
                  // Beats
                  <div class="sg-card sg-track-pink">
                    <div class="sg-track-header">
                      <span class="sg-track-name">{Component.text("Beats")}</span>
                      <code class="sg-track-api">
                        {Component.text("Synth.triggerAttackRelease")}
                      </code>
                    </div>
                    <div class="sg-step-numbers">
                      {Component.fragment(
                        Array.fromInitializer(~length=numSteps, i =>
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
                        ),
                      )}
                    </div>
                    {renderRows(
                      ~rowLabels=beatLabels,
                      ~rowSigs=beatRows,
                      ~currentStep,
                      ~exclusive=false,
                    )}
                  </div>
                  // Chords
                  <div class="sg-card sg-track-amber">
                    <div class="sg-track-header">
                      <span class="sg-track-name">{Component.text("Chords")}</span>
                      <code class="sg-track-api">
                        {Component.text("PolySynth.triggerAttackRelease")}
                      </code>
                    </div>
                    <div class="sg-step-numbers">
                      {Component.fragment(
                        Array.fromInitializer(~length=numSteps, i =>
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
                        ),
                      )}
                    </div>
                    {renderRows(
                      ~rowLabels=chordLabels,
                      ~rowSigs=chordRows,
                      ~currentStep,
                      ~exclusive=true,
                    )}
                  </div>
                  // Bass
                  <div class="sg-card sg-track-green">
                    <div class="sg-track-header">
                      <span class="sg-track-name">{Component.text("Bass")}</span>
                      <code class="sg-track-api">
                        {Component.text("FMSynth -> Filter -> Destination")}
                      </code>
                    </div>
                    <div class="sg-step-numbers">
                      {Component.fragment(
                        Array.fromInitializer(~length=numSteps, i =>
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
                        ),
                      )}
                    </div>
                    {renderRows(
                      ~rowLabels=bassLabels,
                      ~rowSigs=bassRows,
                      ~currentStep,
                      ~exclusive=true,
                    )}
                  </div>
                  // Melody
                  <div class="sg-card sg-track-purple">
                    <div class="sg-track-header">
                      <span class="sg-track-name">{Component.text("Melody")}</span>
                      <code class="sg-track-api">
                        {Component.text("Synth({oscillator: Triangle})")}
                      </code>
                    </div>
                    <div class="sg-step-numbers">
                      {Component.fragment(
                        Array.fromInitializer(~length=numSteps, i =>
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
                        ),
                      )}
                    </div>
                    {renderRows(
                      ~rowLabels=melodyLabels,
                      ~rowSigs=melodyRows,
                      ~currentStep,
                      ~exclusive=true,
                    )}
                  </div>
                </div>,
                // Effects section
                <div class="fx-section">
                  <div class="fx-title">{Component.text("Effects")}</div>
                  <div class="fx-knobs">
                    {renderKnob(
                      ~label="Reverb",
                      ~sig=reverbWet,
                      ~min=0.0,
                      ~max=1.0,
                      ~color="var(--pink-400)",
                      ~fmt=v => (v *. 100.0)->toFixed(0) ++ "%",
                      ~onParam=updateReverb,
                    )}
                    {renderKnob(
                      ~label="Delay",
                      ~sig=delayFb,
                      ~min=0.0,
                      ~max=0.8,
                      ~color="var(--amber-400)",
                      ~fmt=v => (v /. 0.8 *. 100.0)->toFixed(0) ++ "%",
                      ~onParam=updateDelay,
                    )}
                    {renderKnob(
                      ~label="Filter",
                      ~sig=filterFreq,
                      ~min=200.0,
                      ~max=8000.0,
                      ~color="var(--green-400)",
                      ~fmt=v =>
                        if v >= 1000.0 {
                          (v /. 1000.0)->toFixed(1) ++ "kHz"
                        } else {
                          v->toFixed(0) ++ "Hz"
                        },
                      ~onParam=updateFilter,
                    )}
                    {renderKnob(
                      ~label="Chorus",
                      ~sig=chorusWet,
                      ~min=0.0,
                      ~max=1.0,
                      ~color="var(--purple-400)",
                      ~fmt=v => (v *. 100.0)->toFixed(0) ++ "%",
                      ~onParam=updateChorus,
                    )}
                  </div>
                </div>,
              ]
            } else {
              [
                <div class="grid-start">
                  {Component.element(
                    "button",
                    ~attrs=[Component.attr("class", "grid-start-btn")],
                    ~events=[("click", initAudio)],
                    ~children=[Component.text("Start Audio")],
                    (),
                  )}
                  <span class="grid-start-hint">
                    {Component.text(
                      "Click to enable Web Audio, then toggle cells to create a pattern.",
                    )}
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
                <div class="feature-title">{Component.text(f.title)}</div>
                <p class="feature-desc">{Component.text(f.description)}</p>
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
      <h2 class="cta-title">{Component.text("Ready to build?")}</h2>
      <p class="cta-desc">
        {Component.text("Add rescript-tone to your project and start creating audio experiences.")}
      </p>
      <div class="cta-install">
        <code>{Component.text("npm install rescript-tone tone")}</code>
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
