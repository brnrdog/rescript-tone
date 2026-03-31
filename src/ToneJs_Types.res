// Tone.js unit types
// All of these are represented as floats or strings in JavaScript

type seconds = float
type milliseconds = float
type decibels = float
type normalRange = float
type audioRange = float
type frequency = float
type hertz = float
type cents = float
type bpm = float
type ticks = float
type degrees = float
type positive = float
type gainFactor = float
type samples = float

// Time can be a number (seconds), a string notation ("4n", "8t", "1:2:3"), or a subdivision
type time
type transportTime = time

// Playback state
type playbackState =
  | @as("started") Started
  | @as("stopped") Stopped
  | @as("paused") Paused

type basicPlaybackState =
  | @as("started") Started
  | @as("stopped") Stopped

// Oscillator types
type oscillatorType =
  | @as("sine") Sine
  | @as("square") Square
  | @as("triangle") Triangle
  | @as("sawtooth") Sawtooth
  | @as("custom") Custom

// Noise types
type noiseType =
  | @as("white") White
  | @as("brown") Brown
  | @as("pink") Pink

// Oversampling for distortion
type oversampleType =
  | @as("none") None
  | @as("2x") TwoX
  | @as("4x") FourX

// Common option types shared across modules
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

type oscillatorOptions = {\"type"?: oscillatorType}

type filterOptions = {
  \"type"?: string,
  frequency?: frequency,
  rolloff?: int,
  q?: positive,
}

// Helpers to create time values
module Time = {
  external fromFloat: float => time = "%identity"
  external fromString: string => time = "%identity"
  external toFloat: time => float = "%identity"

  let seconds = (s: float): time => fromFloat(s)
  let notation = (s: string): time => fromString(s)
}

// Helpers to create frequency values
module Frequency = {
  let hz = (f: float): frequency => f
  external fromNotation: string => frequency = "%identity"
}
