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
open RescriptTone

// Create a synth and connect it to the speakers
let synth = ToneJs_Synth.make()
let node = synth->ToneJs_Synth.asAudioNode->ToneJs_AudioNode.toDestination

// Play a note
let _ = synth->ToneJs_Synth.triggerAttackRelease(440.0, ToneJs_Types.Time.seconds(0.5))

// Start the audio context (required by browsers)
let _ = ToneJs_Tone.start()
```

## Usage Examples

### Playing Notes with a Synth

```rescript
open RescriptTone

let synth = ToneJs_Synth.makeWithOptions({
  oscillator: ?Some({\"type": ?Some(ToneJs_Types.Sawtooth)}),
  envelope: ?Some({
    attack: ?Some(ToneJs_Types.Time.seconds(0.1)),
    decay: ?Some(ToneJs_Types.Time.seconds(0.2)),
    sustain: ?Some(0.5),
    release: ?Some(ToneJs_Types.Time.seconds(0.8)),
  }),
})

let _ = synth->ToneJs_Synth.asAudioNode->ToneJs_AudioNode.toDestination
let _ = synth->ToneJs_Synth.triggerAttackRelease(440.0, ToneJs_Types.Time.seconds(0.5))
```

### Chaining Effects

```rescript
open RescriptTone

let synth = ToneJs_Synth.make()
let reverb = ToneJs_Reverb.makeWithDecay(1.5)
let delay = ToneJs_FeedbackDelay.makeWithTimeFeedback(ToneJs_Types.Time.notation("8n"), 0.5)
let dest = ToneJs_Tone.getDestination()

// Chain: synth -> delay -> reverb -> destination
let _ = synth
  ->ToneJs_Synth.asAudioNode
  ->ToneJs_AudioNode.chain([
    delay->ToneJs_FeedbackDelay.asAudioNode,
    reverb->ToneJs_Reverb.asAudioNode,
    dest->ToneJs_Destination.asAudioNode,
  ])
```

### Scheduling with Transport

```rescript
open RescriptTone

let synth = ToneJs_Synth.make()
let _ = synth->ToneJs_Synth.asAudioNode->ToneJs_AudioNode.toDestination

let transport = ToneJs_Tone.getTransport()

// Set BPM
let bpm = transport->ToneJs_Transport.bpm
ToneJs_Param.setValue(bpm, 120.0)

// Schedule a repeating note
let _ = transport->ToneJs_Transport.scheduleRepeat(
  _time => {
    let _ = synth->ToneJs_Synth.triggerAttackRelease(440.0, ToneJs_Types.Time.notation("8n"))
  },
  ToneJs_Types.Time.notation("4n"),
)

// Start the transport
let _ = transport->ToneJs_Transport.start
```

### Looping Patterns

```rescript
open RescriptTone

let synth = ToneJs_Synth.make()
let _ = synth->ToneJs_Synth.asAudioNode->ToneJs_AudioNode.toDestination

let notes = ["C4", "E4", "G4", "B4"]

let seq = ToneJs_Sequence.makeWithSubdivision(
  (time, note) => {
    let _ = synth->ToneJs_Synth.triggerAttackReleaseAt(
      ToneJs_Types.Frequency.fromNotation(note),
      ToneJs_Types.Time.notation("8n"),
      ~time=ToneJs_Types.Time.fromFloat(time),
    )
  },
  notes,
  ToneJs_Types.Time.notation("4n"),
)

let _ = seq->ToneJs_Sequence.start
let _ = ToneJs_Tone.getTransport()->ToneJs_Transport.start
```

### Polyphonic Synth

```rescript
open RescriptTone

let poly = ToneJs_PolySynth.makeWithOptions({maxPolyphony: ?Some(4)})
let _ = poly->ToneJs_PolySynth.asAudioNode->ToneJs_AudioNode.toDestination

// Play a chord
let _ = poly->ToneJs_PolySynth.triggerAttackRelease(
  [261.63, 329.63, 392.0],
  ToneJs_Types.Time.seconds(1.0),
)
```

## API Reference

See [docs/API.md](docs/API.md) for the complete API reference.

## Architecture

The library is organized into modules that mirror Tone.js's structure:

| Category | Modules |
|----------|---------|
| **Core** | `Tone`, `Context`, `Transport`, `Destination`, `Param`, `AudioNode`, `Types` |
| **Instruments** | `Synth`, `AMSynth`, `FMSynth`, `MonoSynth`, `PolySynth` |
| **Sources** | `Oscillator`, `Player`, `Noise` |
| **Effects** | `Reverb`, `FeedbackDelay`, `Chorus`, `Distortion`, `AutoFilter`, `AutoPanner`, `AutoWah`, `BitCrusher`, `Chebyshev`, `Freeverb`, `JCReverb`, `Phaser`, `PingPongDelay`, `PitchShift`, `Tremolo`, `Vibrato`, `FrequencyShifter`, `StereoWidener` |
| **Components** | `Compressor`, `Limiter`, `Gate`, `Filter`, `EQ3`, `Panner` |
| **Signal & Channel** | `Signal`, `Volume`, `Gain`, `Channel`, `CrossFade` |
| **Scheduling** | `Loop`, `Event`, `Part`, `Sequence` |

Each Tone.js class maps to a ReScript module with an abstract `type t`. Modules expose:
- `make` / `makeWithOptions` constructors
- `@send` methods for instance operations
- `@get` / `@set` for properties
- `asAudioNode` for casting to the base `ToneJs_AudioNode.t` type (for `connect`, `chain`, etc.)

## Requirements

- ReScript >= 12.0.0
- Tone.js >= 15.0.0
- A browser environment with Web Audio API support

## License

MIT
