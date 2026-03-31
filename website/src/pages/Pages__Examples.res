open Xote

type props = {}

let make = (_props: props) => {
  <article class="docs-article">
    <h1 id="examples"> {Component.text("Examples")} </h1>

    <h2 id="simple-melody"> {Component.text("Simple Melody")} </h2>
    <p>
      {Component.text(
        "Play a sequence of notes using Sequence and the Transport.",
      )}
    </p>
    <CodeBlock
      code={`open Tone

let synth = Synth.makeWithOptions({
  oscillator: {\"type": "triangle"},
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

    <h2 id="effects-chain"> {Component.text("Effects Chain")} </h2>
    <p>
      {Component.text(
        "Build a signal chain with multiple effects.",
      )}
    </p>
    <CodeBlock
      code={`open Tone

let synth = FMSynth.makeWithOptions({
  harmonicity: 3.0,
  modulationIndex: 10.0,
})

let chorus = Chorus.makeWithOptions({
  frequency: 1.5,
  delayTime: 3.5,
  depth: 0.7,
})

let reverb = Reverb.makeWithOptions({
  decay: 3.0,
  wet: 0.6,
})

let delay = FeedbackDelay.makeWithOptions({
  delayTime: "8n.",
  feedback: 0.3,
  wet: 0.4,
})

// Chain: Synth -> Chorus -> Delay -> Reverb -> Speakers
synth->FMSynth.asAudioNode->AudioNode.chain([
  chorus->Chorus.asAudioNode,
  delay->FeedbackDelay.asAudioNode,
  reverb->Reverb.asAudioNode,
])
reverb->Reverb.asAudioNode->AudioNode.toDestination

chorus->Chorus.start()`}
    />

    <h2 id="drum-pattern"> {Component.text("Drum Pattern")} </h2>
    <p>
      {Component.text(
        "Use Loop and Transport to create a repeating drum pattern.",
      )}
    </p>
    <CodeBlock
      code={`open Tone

let kick = Synth.makeWithOptions({
  oscillator: {\"type": "sine"},
  envelope: {attack: 0.001, decay: 0.2, sustain: 0.0, release: 0.2},
})
kick->Synth.asAudioNode->AudioNode.toDestination

let hihat = Noise.makeWithOptions({
  \"type": "white",
  volume: -20.0,
})
let hihatEnv = Volume.makeWithVolume(-20.0)
hihat->Noise.asAudioNode
->AudioNode.connect(hihatEnv->Volume.asAudioNode)
->AudioNode.toDestination

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

    <h2 id="parameter-automation"> {Component.text("Parameter Automation")} </h2>
    <p>
      {Component.text(
        "Automate parameters over time for expressive control.",
      )}
    </p>
    <CodeBlock
      code={`open Tone

let osc = Oscillator.makeWithOptions({
  frequency: 200.0,
  \"type": "sawtooth",
})

let filter = Filter.makeWithOptions({
  frequency: 500.0,
  \"type": "lowpass",
  rolloff: -24,
})

osc->Oscillator.asAudioNode
->AudioNode.connect(filter->Filter.asAudioNode)
->AudioNode.toDestination

// Automate filter cutoff
let cutoff = filter->Filter.frequency
cutoff->Param.rampTo(2000.0, "2m")

// Automate volume
let vol = osc->Oscillator.volume
vol->Param.setValueAtTime(-20.0, "0")
vol->Param.linearRampToValueAtTime(-6.0, "1m")
vol->Param.exponentialRampToValueAtTime(-20.0, "2m")

osc->Oscillator.start()`}
    />
  </article>
}
