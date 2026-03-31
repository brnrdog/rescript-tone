# rescript-tone

ReScript bindings for [Tone.js](https://tonejs.github.io/), a Web Audio framework for creating interactive music in the browser.

## Installation

```bash
npm install rescript-tone tone
```

Add to your `rescript.json`:

```json
{
  "bs-dependencies": ["rescript-tone"]
}
```

## Quick Start

```rescript
// Create a synth and connect it to the speakers
let synth = Tone.Synth.make()
let node = synth->Tone.Synth.asAudioNode->Tone.AudioNode.toDestination

// Play a note
let _ = synth->Tone.Synth.triggerAttackRelease(440.0, Tone.Types.Time.seconds(0.5))

// Start the audio context (required by browsers)
let _ = Tone.Core.start()
```

## Usage Examples

### Playing Notes with a Synth

```rescript
let synth = Tone.Synth.makeWithOptions({
  oscillator: ?Some({\"type": ?Some(Tone.Types.Sawtooth)}),
  envelope: ?Some({
    attack: ?Some(Tone.Types.Time.seconds(0.1)),
    decay: ?Some(Tone.Types.Time.seconds(0.2)),
    sustain: ?Some(0.5),
    release: ?Some(Tone.Types.Time.seconds(0.8)),
  }),
})

let _ = synth->Tone.Synth.asAudioNode->Tone.AudioNode.toDestination
let _ = synth->Tone.Synth.triggerAttackRelease(440.0, Tone.Types.Time.seconds(0.5))
```

### Chaining Effects

```rescript
let synth = Tone.Synth.make()
let reverb = Tone.Reverb.makeWithDecay(1.5)
let delay = Tone.FeedbackDelay.makeWithTimeFeedback(Tone.Types.Time.notation("8n"), 0.5)
let dest = Tone.Core.getDestination()

// Chain: synth -> delay -> reverb -> destination
let _ = synth
  ->Tone.Synth.asAudioNode
  ->Tone.AudioNode.chain([
    delay->Tone.FeedbackDelay.asAudioNode,
    reverb->Tone.Reverb.asAudioNode,
    dest->Tone.Destination.asAudioNode,
  ])
```

### Scheduling with Transport

```rescript
let synth = Tone.Synth.make()
let _ = synth->Tone.Synth.asAudioNode->Tone.AudioNode.toDestination

let transport = Tone.Core.getTransport()

// Set BPM
let bpm = transport->Tone.Transport.bpm
Tone.Param.setValue(bpm, 120.0)

// Schedule a repeating note
let _ = transport->Tone.Transport.scheduleRepeat(
  _time => {
    let _ = synth->Tone.Synth.triggerAttackRelease(440.0, Tone.Types.Time.notation("8n"))
  },
  Tone.Types.Time.notation("4n"),
)

// Start the transport
let _ = transport->Tone.Transport.start
```

### Looping Patterns

```rescript
let synth = Tone.Synth.make()
let _ = synth->Tone.Synth.asAudioNode->Tone.AudioNode.toDestination

let notes = ["C4", "E4", "G4", "B4"]

let seq = Tone.Sequence.makeWithSubdivision(
  (time, note) => {
    let _ = synth->Tone.Synth.triggerAttackReleaseAt(
      Tone.Types.Frequency.fromNotation(note),
      Tone.Types.Time.notation("8n"),
      ~time=Tone.Types.Time.fromFloat(time),
    )
  },
  notes,
  Tone.Types.Time.notation("4n"),
)

let _ = seq->Tone.Sequence.start
let _ = Tone.Core.getTransport()->Tone.Transport.start
```

### Polyphonic Synth

```rescript
let poly = Tone.PolySynth.makeWithOptions({maxPolyphony: ?Some(4)})
let _ = poly->Tone.PolySynth.asAudioNode->Tone.AudioNode.toDestination

// Play a chord
let _ = poly->Tone.PolySynth.triggerAttackRelease(
  [261.63, 329.63, 392.0],
  Tone.Types.Time.seconds(1.0),
)
```

## API Reference

See [docs/API.md](docs/API.md) for the complete API reference.

## Architecture

The library is organized into modules that mirror Tone.js's structure:

| Category | Modules |
|----------|---------|
| **Core** | `Core`, `Context`, `Transport`, `Destination`, `Param`, `AudioNode`, `Types` |
| **Instruments** | `Synth`, `AMSynth`, `FMSynth`, `MonoSynth`, `PolySynth` |
| **Sources** | `Oscillator`, `Player`, `Noise` |
| **Effects** | `Reverb`, `FeedbackDelay`, `Chorus`, `Distortion`, `AutoFilter`, `AutoPanner`, `AutoWah`, `BitCrusher`, `Chebyshev`, `Freeverb`, `JCReverb`, `Phaser`, `PingPongDelay`, `PitchShift`, `Tremolo`, `Vibrato`, `FrequencyShifter`, `StereoWidener` |
| **Components** | `Compressor`, `Limiter`, `Gate`, `Filter`, `EQ3`, `Panner` |
| **Signal & Channel** | `Signal`, `Volume`, `Gain`, `Channel`, `CrossFade` |
| **Scheduling** | `Loop`, `Event`, `Part`, `Sequence` |

All modules are accessible under the `Tone` namespace (e.g., `Tone.Synth.make()`, `Tone.Reverb.makeWithDecay(1.5)`).

Each Tone.js class maps to a ReScript module with an abstract `type t`. Modules expose:
- `make` / `makeWithOptions` constructors
- `@send` methods for instance operations
- `@get` / `@set` for properties
- `asAudioNode` for casting to the base `AudioNode.t` type (for `connect`, `chain`, etc.)

## Requirements

- ReScript >= 12.0.0
- Tone.js >= 15.0.0
- A browser environment with Web Audio API support

## License

MIT
