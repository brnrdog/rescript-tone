# rescript-tone API Reference

Complete API reference for rescript-tone bindings. All modules are accessible via `open RescriptTone` or by using the `ToneJs_` prefixed module names directly.

---

## Table of Contents

- [Types](#types)
- [Core](#core)
  - [Tone](#tone)
  - [Context](#context)
  - [Transport](#transport)
  - [Destination](#destination)
  - [AudioNode](#audionode)
  - [Param](#param)
- [Instruments](#instruments)
  - [Synth](#synth)
  - [AMSynth](#amsynth)
  - [FMSynth](#fmsynth)
  - [MonoSynth](#monosynth)
  - [PolySynth](#polysynth)
- [Sources](#sources)
  - [Oscillator](#oscillator)
  - [Player](#player)
  - [Noise](#noise)
- [Effects](#effects)
  - [Reverb](#reverb)
  - [FeedbackDelay](#feedbackdelay)
  - [Chorus](#chorus)
  - [Distortion](#distortion)
  - [AutoFilter](#autofilter)
  - [AutoPanner](#autopanner)
  - [AutoWah](#autowah)
  - [BitCrusher](#bitcrusher)
  - [Chebyshev](#chebyshev)
  - [Freeverb](#freeverb)
  - [JCReverb](#jcreverb)
  - [Phaser](#phaser)
  - [PingPongDelay](#pingpongdelay)
  - [PitchShift](#pitchshift)
  - [Tremolo](#tremolo)
  - [Vibrato](#vibrato)
  - [FrequencyShifter](#frequencyshifter)
  - [StereoWidener](#stereowidener)
- [Components](#components)
  - [Compressor](#compressor)
  - [Limiter](#limiter)
  - [Gate](#gate)
  - [Filter](#filter)
  - [EQ3](#eq3)
  - [Panner](#panner)
- [Signal & Channel](#signal--channel)
  - [Signal](#signal)
  - [Volume](#volume)
  - [Gain](#gain)
  - [Channel](#channel)
  - [CrossFade](#crossfade)
- [Scheduling](#scheduling)
  - [Loop](#loop)
  - [Event](#event)
  - [Part](#part)
  - [Sequence](#sequence)

---

## Types

Module: `ToneJs_Types`

### Unit Types

All numeric unit types are aliases for `float`:

| Type | Description |
|------|-------------|
| `seconds` | Time in seconds |
| `milliseconds` | Time in milliseconds |
| `decibels` | Volume in dB |
| `normalRange` | Value between 0.0 and 1.0 |
| `audioRange` | Value between -1.0 and 1.0 |
| `frequency` | Frequency in Hz |
| `hertz` | Frequency in Hz |
| `cents` | 1/100th of a semitone |
| `bpm` | Beats per minute |
| `ticks` | Transport ticks |
| `degrees` | Angle in degrees |
| `positive` | Non-negative number |
| `gainFactor` | Gain multiplier |
| `samples` | Audio samples |

### Abstract Types

| Type | Description |
|------|-------------|
| `time` | Opaque time value (can be seconds or notation like `"4n"`) |
| `transportTime` | Alias for `time`, used for transport-relative scheduling |

### Variant Types

```rescript
type playbackState = Started | Stopped | Paused
type basicPlaybackState = Started | Stopped
type oscillatorType = Sine | Square | Triangle | Sawtooth | Custom
type noiseType = White | Brown | Pink
type oversampleType = None | TwoX | FourX
```

### Shared Option Types

```rescript
type envelopeOptions = {
  attack?: time,
  decay?: time,
  sustain?: normalRange,
  release?: time,
}

type filterEnvelopeOptions = {
  attack?: time,
  decay?: time,
  sustain?: normalRange,
  release?: time,
  baseFrequency?: frequency,
  octaves?: positive,
  exponent?: positive,
}

type oscillatorOptions = { "type"?: oscillatorType }

type filterOptions = {
  "type"?: string,
  frequency?: frequency,
  rolloff?: int,
  q?: positive,
}
```

### Time Helpers

```rescript
Time.seconds(1.5)         // Create time from float seconds
Time.notation("4n")       // Create time from notation string
Time.fromFloat(1.5)       // Raw float -> time
Time.fromString("4n")     // Raw string -> time
Time.toFloat(t)           // time -> float
```

### Frequency Helpers

```rescript
Frequency.hz(440.0)          // Create frequency from Hz
Frequency.fromNotation("C4") // Create frequency from note name
```

---

## Core

### Tone

Module: `ToneJs_Tone`

Top-level functions for the Tone.js audio engine.

```rescript
start: unit => promise<unit>
now: unit => seconds
immediate: unit => seconds
getContext: unit => ToneJs_Context.t
getTransport: unit => ToneJs_Transport.t
getDestination: unit => ToneJs_Destination.t
loaded: unit => promise<unit>
supported: unit => bool
version: string
```

### Context

Module: `ToneJs_Context`

The audio context wrapper.

```rescript
// Timing
now: t => seconds
immediate: t => seconds
currentTime: t => seconds              // @get
sampleRate: t => float                 // @get
state: t => string                     // @get

// Lifecycle
resume: t => promise<unit>
close: t => promise<unit>
dispose: t => t

// Look-ahead
lookAhead: t => seconds                // @get
setLookAhead: (t, seconds) => unit     // @set

// Scheduling
setTimeout: (t, unit => unit, seconds) => int
clearTimeout: (t, int) => t
setInterval: (t, unit => unit, seconds) => int
clearInterval: (t, int) => t
```

### Transport

Module: `ToneJs_Transport`

Master timing and scheduling.

```rescript
// Lifecycle
start: t => t
startAt: (t, ~time: time=?) => t
startAtWithOffset: (t, ~time: time=?, ~offset: transportTime=?) => t
stop: t => t
stopAt: (t, ~time: time=?) => t
pause: t => t
pauseAt: (t, ~time: time=?) => t
toggle: t => t
toggleAt: (t, ~time: time=?) => t
cancel: t => t
cancelAfter: (t, ~after: transportTime=?) => t
dispose: t => t

// Scheduling
schedule: (t, seconds => unit, transportTime) => int
scheduleRepeat: (t, seconds => unit, time) => int
scheduleRepeatFrom: (t, seconds => unit, time, ~startTime: transportTime=?) => int
scheduleRepeatFromFor: (t, seconds => unit, time, ~startTime: transportTime=?, ~duration: time=?) => int
scheduleOnce: (t, seconds => unit, transportTime) => int
clear: (t, int) => t

// Properties
bpm: t => ToneJs_Param.t                  // @get
position: t => string                      // @get
setPosition: (t, string) => unit           // @set
seconds: t => seconds                      // @get
setSeconds: (t, seconds) => unit           // @set
progress: t => normalRange                 // @get
ticks: t => ticks                          // @get
setTicks: (t, ticks) => unit               // @set
state: t => playbackState                  // @get
ppq: t => int                              // @get
setPPQ: (t, int) => unit                   // @set
timeSignature: t => int                    // @get
setTimeSignature: (t, int) => unit         // @set

// Loop
loop: t => bool                            // @get
setLoop: (t, bool) => unit                 // @set
loopStart: t => time                       // @get
setLoopStart: (t, time) => unit            // @set
loopEnd: t => time                         // @get
setLoopEnd: (t, time) => unit              // @set
setLoopPoints: (t, transportTime, transportTime) => t

// Swing
swing: t => normalRange                    // @get
setSwing: (t, normalRange) => unit         // @set

// Timing queries
getTicksAtTime: (t, time) => ticks
getSecondsAtTime: (t, time) => seconds
nextSubdivision: (t, time) => seconds
```

### Destination

Module: `ToneJs_Destination`

The master audio output.

```rescript
volume: t => ToneJs_Param.t       // @get
mute: t => bool                    // @get
setMute: (t, bool) => unit         // @set
maxChannelCount: t => int          // @get
dispose: t => t
asAudioNode: t => ToneJs_AudioNode.t
```

### AudioNode

Module: `ToneJs_AudioNode`

Base type for all audio-processing nodes. Use `asAudioNode` on any module to access these methods.

```rescript
// Routing
connect: (t, t) => t
connectWithOutput: (t, t, ~outputNum: int) => t
connectWithOutputInput: (t, t, ~outputNum: int, ~inputNum: int) => t
disconnect: t => t
disconnectFrom: (t, t) => t
toDestination: t => t
chain: (t, array<t>) => t         // @variadic
fan: (t, array<t>) => t           // @variadic
dispose: t => t

// Properties
numberOfInputs: t => int          // @get
numberOfOutputs: t => int         // @get
channelCount: t => int            // @get
setChannelCount: (t, int) => unit // @set
```

### Param

Module: `ToneJs_Param`

Automatable audio parameters (used by volume, frequency, BPM, etc.).

```rescript
// Value
getValue: t => float              // @get
setValue: (t, float) => unit       // @set

// Scheduling
setValueAtTime: (t, float, time) => t
getValueAtTime: (t, time) => float
linearRampToValueAtTime: (t, float, time) => t
exponentialRampToValueAtTime: (t, float, time) => t
linearRampTo: (t, float, time) => t
linearRampToFrom: (t, float, time, ~startTime: time=?) => t
exponentialRampTo: (t, float, time) => t
exponentialRampToFrom: (t, float, time, ~startTime: time=?) => t
targetRampTo: (t, float, time) => t
targetRampToFrom: (t, float, time, ~startTime: time=?) => t
rampTo: (t, float, time) => t
rampToFrom: (t, float, time, ~startTime: time=?) => t
setRampPoint: (t, time) => t
setTargetAtTime: (t, float, time, float) => t
cancelScheduledValues: (t, time) => t
cancelAndHoldAtTime: (t, time) => t
```

---

## Instruments

All instruments share this common interface:

```rescript
// Constructors
make: unit => t
makeWithOptions: options => t

// Trigger methods
triggerAttack: (t, frequency) => t
triggerAttackAt: (t, frequency, ~time: time=?) => t
triggerAttackAtVel: (t, frequency, ~time: time=?, ~velocity: normalRange=?) => t
triggerRelease: (t, ~time: time=?) => t
triggerAttackRelease: (t, frequency, time) => t
triggerAttackReleaseAt: (t, frequency, time, ~time: time=?) => t
triggerAttackReleaseAtVel: (t, frequency, time, ~time: time=?, ~velocity: normalRange=?) => t

// Properties
volume: t => ToneJs_Param.t
frequency: t => ToneJs_Param.t
detune: t => ToneJs_Param.t

// Lifecycle
dispose: t => t
sync: t => t
unsync: t => t
asAudioNode: t => ToneJs_AudioNode.t
```

### Synth

Module: `ToneJs_Synth`

A basic monophonic synthesizer with an oscillator and amplitude envelope.

```rescript
type options = {
  oscillator?: oscillatorOptions,
  envelope?: envelopeOptions,
  volume?: decibels,
}
```

### AMSynth

Module: `ToneJs_AMSynth`

Amplitude modulation synthesis.

```rescript
type options = {
  harmonicity?: positive,
  oscillator?: oscillatorOptions,
  modulation?: oscillatorOptions,
  envelope?: envelopeOptions,
  modulationEnvelope?: envelopeOptions,
  volume?: decibels,
}
```

### FMSynth

Module: `ToneJs_FMSynth`

Frequency modulation synthesis.

```rescript
type options = {
  harmonicity?: positive,
  modulationIndex?: positive,
  oscillator?: oscillatorOptions,
  modulation?: oscillatorOptions,
  envelope?: envelopeOptions,
  modulationEnvelope?: envelopeOptions,
  volume?: decibels,
}
```

### MonoSynth

Module: `ToneJs_MonoSynth`

Monophonic synthesizer with a filter and filter envelope.

```rescript
type options = {
  oscillator?: oscillatorOptions,
  envelope?: envelopeOptions,
  filterEnvelope?: filterEnvelopeOptions,
  filter?: filterOptions,
  volume?: decibels,
}
```

### PolySynth

Module: `ToneJs_PolySynth`

Polyphonic synthesizer that manages multiple voices.

```rescript
type options = {
  maxPolyphony?: int,
  volume?: decibels,
}
```

Additional methods beyond the common instrument interface:

```rescript
// Array-based triggers (play chords)
triggerAttack: (t, array<frequency>) => t
triggerAttackNote: (t, frequency) => t
triggerRelease: (t, array<frequency>) => t
triggerReleaseNote: (t, frequency) => t
triggerAttackRelease: (t, array<frequency>, time) => t
triggerAttackReleaseNote: (t, frequency, time) => t
releaseAll: (t, ~time: time=?) => t

// Properties
activeVoices: t => int             // @get
maxPolyphony: t => int             // @get
setMaxPolyphony: (t, int) => unit  // @set
```

---

## Sources

### Oscillator

Module: `ToneJs_Oscillator`

A waveform oscillator.

```rescript
type options = {
  frequency?: frequency,
  "type"?: oscillatorType,
  detune?: cents,
  phase?: degrees,
  volume?: decibels,
}

// Constructors
make: unit => t
makeWithOptions: options => t
makeWithFreq: (frequency, oscillatorType) => t

// Lifecycle
start: (t, ~time: time=?) => t
stop: (t, ~time: time=?) => t
restart: (t, ~time: time=?) => t
dispose: t => t

// Properties
frequency: t => ToneJs_Param.t
detune: t => ToneJs_Param.t
volume: t => ToneJs_Param.t
getType: t => oscillatorType           // @get "type"
setType: (t, oscillatorType) => unit   // @set "type"
phase: t => degrees                    // @get
setPhase: (t, degrees) => unit         // @set
partialCount: t => int                 // @get
setPartialCount: (t, int) => unit      // @set
partials: t => array<float>            // @get
setPartials: (t, array<float>) => unit // @set

// Frequency sync
syncFrequency: t => t
unsyncFrequency: t => t
sync: t => t
unsync: t => t
asAudioNode: t => ToneJs_AudioNode.t
```

### Player

Module: `ToneJs_Player`

Audio file playback.

```rescript
type options = {
  url?: string,
  loop?: bool,
  autostart?: bool,
  playbackRate?: positive,
  loopStart?: time,
  loopEnd?: time,
  reverse?: bool,
  fadeIn?: time,
  fadeOut?: time,
  volume?: decibels,
}

// Constructors
make: string => t                    // from URL
makeWithOptions: options => t

// Playback
start: (t, ~time: time=?) => t
startWithOffset: (t, ~time: time=?, ~offset: time=?) => t
startWithOffsetDuration: (t, ~time: time=?, ~offset: time=?, ~duration: time=?) => t
stop: (t, ~time: time=?) => t
restart: (t, ~time: time=?) => t
seek: (t, time) => t
seekAt: (t, time, ~when_: time=?) => t
dispose: t => t

// Loading
load: (t, string) => promise<t>

// Properties
volume: t => ToneJs_Param.t
loaded: t => bool
loop / setLoop: bool
loopStart / setLoopStart: time
loopEnd / setLoopEnd: time
setLoopPoints: (t, time, time) => t
playbackRate / setPlaybackRate: positive
reverse / setReverse: bool
autostart / setAutostart: bool
fadeIn / setFadeIn: time
fadeOut / setFadeOut: time
sync: t => t
unsync: t => t
asAudioNode: t => ToneJs_AudioNode.t
```

### Noise

Module: `ToneJs_Noise`

Noise generator (white, brown, or pink).

```rescript
type options = {
  "type"?: noiseType,
  playbackRate?: positive,
  fadeIn?: time,
  fadeOut?: time,
  volume?: decibels,
}

// Constructors
make: noiseType => t
makeWithOptions: options => t

// Lifecycle
start: (t, ~time: time=?) => t
stop: (t, ~time: time=?) => t
restart: (t, ~time: time=?) => t
dispose: t => t

// Properties
volume: t => ToneJs_Param.t
getType / setType: noiseType
playbackRate / setPlaybackRate: positive
fadeIn / setFadeIn: time
fadeOut / setFadeOut: time
sync: t => t
unsync: t => t
asAudioNode: t => ToneJs_AudioNode.t
```

---

## Effects

All effects share a common base:

```rescript
wet: t => ToneJs_Param.t              // dry/wet mix (0 = dry, 1 = wet)
dispose: t => t
asAudioNode: t => ToneJs_AudioNode.t
```

### Reverb

Module: `ToneJs_Reverb`

Convolution reverb.

```rescript
type options = { decay?: seconds, preDelay?: seconds, wet?: normalRange }

make: unit => t
makeWithDecay: seconds => t
makeWithOptions: options => t

decay / setDecay: time
preDelay / setPreDelay: time
wet: t => ToneJs_Param.t
ready: t => promise<unit>
generate: t => promise<t>
```

### FeedbackDelay

Module: `ToneJs_FeedbackDelay`

Delay with feedback loop.

```rescript
type options = { delayTime?: time, maxDelay?: time, feedback?: normalRange, wet?: normalRange }

make: unit => t
makeWithTime: time => t
makeWithTimeFeedback: (time, normalRange) => t
makeWithOptions: options => t

delayTime: t => ToneJs_Param.t
feedback: t => ToneJs_Param.t
wet: t => ToneJs_Param.t
```

### Chorus

Module: `ToneJs_Chorus`

Chorus effect with LFO modulation.

```rescript
type options = {
  frequency?: frequency, delayTime?: milliseconds, depth?: normalRange,
  "type"?: oscillatorType, spread?: degrees, feedback?: normalRange, wet?: normalRange,
}

make: unit => t
makeWithArgs: (frequency, milliseconds, normalRange) => t
makeWithOptions: options => t

frequency: t => ToneJs_Param.t
depth / setDepth: normalRange
delayTime / setDelayTime: milliseconds
getType / setType: oscillatorType
spread / setSpread: degrees
wet: t => ToneJs_Param.t
start: (t, ~time: time=?) => t
stop: (t, ~time: time=?) => t
sync: t => t
unsync: t => t
```

### Distortion

Module: `ToneJs_Distortion`

Waveshaping distortion.

```rescript
type options = { distortion?: float, oversample?: oversampleType, wet?: normalRange }

make: unit => t
makeWithAmount: float => t
makeWithOptions: options => t

distortion / setDistortion: float
oversample / setOversample: oversampleType
wet: t => ToneJs_Param.t
```

### AutoFilter

Module: `ToneJs_AutoFilter`

LFO-controlled filter.

```rescript
type options = {
  frequency?: frequency, "type"?: oscillatorType, depth?: normalRange,
  baseFrequency?: frequency, octaves?: positive, filter?: filterOptions, wet?: normalRange,
}

make: unit => t
makeWithOptions: options => t

frequency: t => ToneJs_Param.t
depth: t => ToneJs_Param.t
wet: t => ToneJs_Param.t
octaves / setOctaves: positive
baseFrequency / setBaseFrequency: frequency
start: (t, ~time: time=?) => t
stop: (t, ~time: time=?) => t
sync: t => t
unsync: t => t
```

### AutoPanner

Module: `ToneJs_AutoPanner`

LFO-controlled panning.

```rescript
type options = { frequency?: frequency, "type"?: oscillatorType, depth?: normalRange, wet?: normalRange }

make: unit => t
makeWithOptions: options => t

frequency: t => ToneJs_Param.t
depth: t => ToneJs_Param.t
wet: t => ToneJs_Param.t
start: (t, ~time: time=?) => t
stop: (t, ~time: time=?) => t
sync: t => t
unsync: t => t
```

### AutoWah

Module: `ToneJs_AutoWah`

Envelope-follower controlled filter.

```rescript
type options = {
  baseFrequency?: frequency, octaves?: positive, sensitivity?: decibels,
  q?: positive, gain?: float, follower?: float, wet?: normalRange,
}

make: unit => t
makeWithOptions: options => t

gain: t => ToneJs_Param.t
q: t => ToneJs_Param.t
wet: t => ToneJs_Param.t
octaves / setOctaves: positive
baseFrequency / setBaseFrequency: frequency
sensitivity / setSensitivity: decibels
```

### BitCrusher

Module: `ToneJs_BitCrusher`

Bit depth reduction.

```rescript
type options = { bits?: positive, wet?: normalRange }

make: unit => t
makeWithBits: positive => t
makeWithOptions: options => t

bits: t => ToneJs_Param.t
wet: t => ToneJs_Param.t
```

### Chebyshev

Module: `ToneJs_Chebyshev`

Chebyshev waveshaping distortion.

```rescript
type options = { order?: int, oversample?: oversampleType, wet?: normalRange }

make: unit => t
makeWithOrder: int => t
makeWithOptions: options => t

order / setOrder: int
oversample / setOversample: oversampleType
wet: t => ToneJs_Param.t
```

### Freeverb

Module: `ToneJs_Freeverb`

Freeverb algorithm reverb.

```rescript
type options = { roomSize?: normalRange, dampening?: frequency, wet?: normalRange }

make: unit => t
makeWithOptions: options => t

roomSize: t => ToneJs_Param.t
dampening: t => ToneJs_Param.t
wet: t => ToneJs_Param.t
```

### JCReverb

Module: `ToneJs_JCReverb`

JC-120 style reverb.

```rescript
type options = { roomSize?: normalRange, wet?: normalRange }

make: unit => t
makeWithOptions: options => t

roomSize: t => ToneJs_Param.t
wet: t => ToneJs_Param.t
```

### Phaser

Module: `ToneJs_Phaser`

Phaser effect.

```rescript
type options = {
  frequency?: frequency, octaves?: positive, stages?: int,
  q?: positive, baseFrequency?: frequency, wet?: normalRange,
}

make: unit => t
makeWithOptions: options => t

frequency: t => ToneJs_Param.t
octaves / setOctaves: positive
q: t => ToneJs_Param.t
baseFrequency / setBaseFrequency: frequency
wet: t => ToneJs_Param.t
```

### PingPongDelay

Module: `ToneJs_PingPongDelay`

Stereo ping-pong delay.

```rescript
type options = { delayTime?: time, maxDelay?: time, feedback?: normalRange, wet?: normalRange }

make: unit => t
makeWithTime: time => t
makeWithTimeFeedback: (time, normalRange) => t
makeWithOptions: options => t

delayTime: t => ToneJs_Param.t
feedback: t => ToneJs_Param.t
wet: t => ToneJs_Param.t
```

### PitchShift

Module: `ToneJs_PitchShift`

Pitch shifting effect.

```rescript
type options = {
  pitch?: float, windowSize?: seconds, delayTime?: time,
  feedback?: normalRange, wet?: normalRange,
}

make: unit => t
makeWithOptions: options => t

pitch / setPitch: float           // semitones
windowSize / setWindowSize: seconds
delayTime: t => ToneJs_Param.t
feedback: t => ToneJs_Param.t
wet: t => ToneJs_Param.t
```

### Tremolo

Module: `ToneJs_Tremolo`

LFO-controlled amplitude modulation.

```rescript
type options = {
  frequency?: frequency, "type"?: oscillatorType,
  depth?: normalRange, spread?: degrees, wet?: normalRange,
}

make: unit => t
makeWithOptions: options => t

frequency: t => ToneJs_Param.t
depth: t => ToneJs_Param.t
getType / setType: oscillatorType
spread / setSpread: degrees
wet: t => ToneJs_Param.t
start: (t, ~time: time=?) => t
stop: (t, ~time: time=?) => t
sync: t => t
unsync: t => t
```

### Vibrato

Module: `ToneJs_Vibrato`

LFO-controlled pitch modulation.

```rescript
type options = {
  frequency?: frequency, "type"?: oscillatorType,
  depth?: normalRange, maxDelay?: seconds, wet?: normalRange,
}

make: unit => t
makeWithOptions: options => t

frequency: t => ToneJs_Param.t
depth: t => ToneJs_Param.t
getType / setType: oscillatorType
wet: t => ToneJs_Param.t
```

### FrequencyShifter

Module: `ToneJs_FrequencyShifter`

Frequency shifting effect.

```rescript
type options = { frequency?: frequency, wet?: normalRange }

make: unit => t
makeWithOptions: options => t

frequency: t => ToneJs_Param.t
wet: t => ToneJs_Param.t
```

### StereoWidener

Module: `ToneJs_StereoWidener`

Stereo width control.

```rescript
type options = { width?: normalRange, wet?: normalRange }

make: unit => t
makeWithOptions: options => t

width: t => ToneJs_Param.t
wet: t => ToneJs_Param.t
```

---

## Components

### Compressor

Module: `ToneJs_Compressor`

Dynamic range compressor.

```rescript
type options = {
  threshold?: decibels, ratio?: positive,
  attack?: time, release?: time, knee?: decibels,
}

make: unit => t
makeWithThreshold: decibels => t
makeWithThresholdRatio: (decibels, positive) => t
makeWithOptions: options => t

threshold: t => ToneJs_Param.t
ratio: t => ToneJs_Param.t
attack: t => ToneJs_Param.t
release: t => ToneJs_Param.t
knee: t => ToneJs_Param.t
reduction: t => decibels              // @get (read-only)
dispose: t => t
asAudioNode: t => ToneJs_AudioNode.t
```

### Limiter

Module: `ToneJs_Limiter`

Peak limiter.

```rescript
type options = { threshold?: decibels }

make: unit => t
makeWithThreshold: decibels => t
makeWithOptions: options => t

threshold: t => ToneJs_Param.t
reduction: t => decibels               // @get (read-only)
dispose: t => t
asAudioNode: t => ToneJs_AudioNode.t
```

### Gate

Module: `ToneJs_Gate`

Noise gate.

```rescript
type options = { threshold?: decibels, smoothing?: time }

make: unit => t
makeWithThreshold: decibels => t
makeWithOptions: options => t

threshold: t => ToneJs_Param.t
smoothing / setSmoothing: time
dispose: t => t
asAudioNode: t => ToneJs_AudioNode.t
```

### Filter

Module: `ToneJs_Filter`

Multi-type biquad filter.

```rescript
type filterType = Lowpass | Highpass | Bandpass | Lowshelf | Highshelf | Notch | Allpass | Peaking
type rolloff = R12 | R24 | R48 | R96   // -12, -24, -48, -96 dB/octave

type options = {
  frequency?: frequency, "type"?: filterType,
  rolloff?: rolloff, q?: positive, gain?: float,
}

make: unit => t
makeWithFreq: frequency => t
makeWithOptions: options => t

frequency: t => ToneJs_Param.t
q: t => ToneJs_Param.t
gain: t => ToneJs_Param.t
detune: t => ToneJs_Param.t
getType / setType: filterType
rolloff / setRolloff: rolloff
getFrequencyResponse: (t, int) => array<float>
dispose: t => t
asAudioNode: t => ToneJs_AudioNode.t
```

### EQ3

Module: `ToneJs_EQ3`

3-band equalizer.

```rescript
type options = {
  low?: decibels, mid?: decibels, high?: decibels,
  lowFrequency?: frequency, highFrequency?: frequency,
}

make: unit => t
makeWithOptions: options => t

low: t => ToneJs_Param.t
mid: t => ToneJs_Param.t
high: t => ToneJs_Param.t
lowFrequency: t => ToneJs_Param.t
highFrequency: t => ToneJs_Param.t
dispose: t => t
asAudioNode: t => ToneJs_AudioNode.t
```

### Panner

Module: `ToneJs_Panner`

Stereo panning.

```rescript
type options = { pan?: audioRange, channelCount?: int }

make: unit => t
makeWithPan: audioRange => t
makeWithOptions: options => t

pan: t => ToneJs_Param.t              // -1.0 (left) to 1.0 (right)
dispose: t => t
asAudioNode: t => ToneJs_AudioNode.t
```

---

## Signal & Channel

### Signal

Module: `ToneJs_Signal`

A schedulable signal that can be connected in the audio graph.

```rescript
type options = { value?: float, units?: string }

make: unit => t
makeWithValue: float => t
makeWithOptions: options => t

// Value
getValue / setValue: float
overridden / setOverridden: bool
maxValue: t => float
minValue: t => float
units: t => string
convert / setConvert: bool

// Scheduling (same as Param)
setValueAtTime: (t, float, time) => t
getValueAtTime: (t, time) => float
linearRampToValueAtTime / exponentialRampToValueAtTime: (t, float, time) => t
linearRampTo / exponentialRampTo / targetRampTo / rampTo: (t, float, time) => t
// ...From variants with ~startTime: time=?
setRampPoint: (t, time) => t
setTargetAtTime: (t, float, time, float) => t
cancelScheduledValues / cancelAndHoldAtTime: (t, time) => t

// Routing
connect: (t, ToneJs_AudioNode.t) => t
dispose: t => t
asAudioNode: t => ToneJs_AudioNode.t
asParam: t => ToneJs_Param.t
```

### Volume

Module: `ToneJs_Volume`

Volume control with mute.

```rescript
type options = { volume?: decibels, mute?: bool }

make: unit => t
makeWithVolume: decibels => t
makeWithOptions: options => t

volume: t => ToneJs_Param.t
mute / setMute: bool
dispose: t => t
asAudioNode: t => ToneJs_AudioNode.t
```

### Gain

Module: `ToneJs_Gain`

Basic gain node.

```rescript
type options = { gain?: gainFactor, units?: string }

make: unit => t
makeWithGain: gainFactor => t
makeWithOptions: options => t

gain: t => ToneJs_Param.t
dispose: t => t
asAudioNode: t => ToneJs_AudioNode.t
```

### Channel

Module: `ToneJs_Channel`

Audio channel with pan, volume, solo, mute, and bus routing.

```rescript
type options = {
  pan?: audioRange, volume?: decibels,
  solo?: bool, mute?: bool, channelCount?: int,
}

make: unit => t
makeWithVolume: decibels => t
makeWithVolumePan: (decibels, audioRange) => t
makeWithOptions: options => t

pan: t => ToneJs_Param.t
volume: t => ToneJs_Param.t
solo / setSolo: bool
mute / setMute: bool
muted: t => bool                   // @get (read-only, true when solo'd out)

// Bus routing
send: (t, string) => ToneJs_Gain.t
sendWithVolume: (t, string, ~volume: decibels=?) => ToneJs_Gain.t
receive: (t, string) => t

dispose: t => t
asAudioNode: t => ToneJs_AudioNode.t
```

### CrossFade

Module: `ToneJs_CrossFade`

Crossfade between two inputs.

```rescript
type options = { fade?: normalRange }

make: unit => t
makeWithFade: normalRange => t
makeWithOptions: options => t

fade: t => ToneJs_Param.t             // 0 = input A, 1 = input B
a: t => ToneJs_Gain.t
b: t => ToneJs_Gain.t
dispose: t => t
asAudioNode: t => ToneJs_AudioNode.t
```

---

## Scheduling

All scheduling modules work with the Transport. Start the transport to begin playback.

### Loop

Module: `ToneJs_Loop`

Repeating callback at a set interval.

```rescript
type options = {
  callback?: seconds => unit, interval?: time,
  playbackRate?: positive, iterations?: int,
  probability?: normalRange, mute?: bool, humanize?: bool,
}

make: (seconds => unit, time) => t
makeWithOptions: options => t

// Lifecycle
start: (t, ~time: transportTime=?) => t
stop: (t, ~time: transportTime=?) => t
cancel: (t, ~time: transportTime=?) => t
dispose: t => t

// Properties
state: t => basicPlaybackState
progress: t => normalRange
interval / setInterval: time
playbackRate / setPlaybackRate: positive
humanize / setHumanize: bool
probability / setProbability: normalRange
mute / setMute: bool
iterations / setIterations: int
callback / setCallback: seconds => unit
```

### Event

Module: `ToneJs_Event`

A single schedulable event.

```rescript
make: ((seconds, 'a) => unit, 'a) => t

// Lifecycle
start: (t, ~time: transportTime=?) => t
stop: (t, ~time: transportTime=?) => t
cancel: (t, ~time: transportTime=?) => t
dispose: t => t

// Properties
state: t => basicPlaybackState
progress: t => normalRange
loop / setLoop: bool
loopEnd / setLoopEnd: time
loopStart / setLoopStart: time
playbackRate / setPlaybackRate: positive
probability / setProbability: normalRange
mute / setMute: bool
humanize / setHumanize: bool
```

### Part

Module: `ToneJs_Part`

A collection of events on a timeline.

```rescript
make: ((seconds, 'a) => unit, array<'a>) => t

// Lifecycle
start: (t, ~time: transportTime=?) => t
startWithOffset: (t, ~time: transportTime=?, ~offset: time=?) => t
stop: (t, ~time: transportTime=?) => t
cancel: (t, ~time: transportTime=?) => t
clear: t => t
dispose: t => t

// Event management
add: (t, time, 'a) => t
remove: (t, time, 'a) => t
at: (t, time) => Null.t<ToneJs_Event.t>

// Properties
state: t => basicPlaybackState
progress: t => normalRange
length: t => int
loop / setLoop: bool
setLoopCount: (t, int) => unit
loopEnd / setLoopEnd: time
loopStart / setLoopStart: time
playbackRate / setPlaybackRate: positive
probability / setProbability: normalRange
mute / setMute: bool
humanize / setHumanize: bool
```

### Sequence

Module: `ToneJs_Sequence`

An ordered series of events played at a subdivision.

```rescript
make: ((seconds, 'a) => unit, array<'a>) => t
makeWithSubdivision: ((seconds, 'a) => unit, array<'a>, time) => t

// Lifecycle
start: (t, ~time: transportTime=?) => t
startWithOffset: (t, ~time: transportTime=?, ~offset: int=?) => t
stop: (t, ~time: transportTime=?) => t
clear: t => t
dispose: t => t

// Properties
events / setEvents: array<'a>
subdivision: t => seconds
state: t => basicPlaybackState
progress: t => normalRange
length: t => int
loop / setLoop: bool
setLoopCount: (t, int) => unit
loopEnd / setLoopEnd: int             // index-based
loopStart / setLoopStart: int         // index-based
playbackRate / setPlaybackRate: positive
probability / setProbability: normalRange
mute / setMute: bool
humanize / setHumanize: bool
```
