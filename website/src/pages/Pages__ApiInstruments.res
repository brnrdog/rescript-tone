open Xote

type props = {}

let make = (_props: props) => {
  <article class="docs-article">
    <h1 id="instruments"> {Component.text("Instruments")} </h1>
    <p>
      {Component.text(
        "Instruments are sound sources that can be triggered with notes. All instruments share a common interface for triggering attacks and releases.",
      )}
    </p>

    <h2 id="synth"> {Component.text("Synth")} </h2>
    <p>
      {Component.text(
        "A basic synthesizer with an oscillator and an ADSR envelope.",
      )}
    </p>
    <CodeBlock
      code={`let synth = Synth.make()
let synth2 = Synth.makeWithOptions({
  oscillator: {\"type": "square"},
  envelope: {attack: 0.1, decay: 0.2, sustain: 0.5, release: 0.8},
  volume: -6.0,
})

synth->Synth.asAudioNode->AudioNode.toDestination

// Trigger a note
synth->Synth.triggerAttack("C4")
synth->Synth.triggerRelease()

// Trigger attack and release in one call
synth->Synth.triggerAttackRelease("C4", "8n")

// With time and velocity
synth->Synth.triggerAttackReleaseAtVel("E4", "4n", ~velocity=0.8)

// Properties
synth->Synth.volume // Param.t
synth->Synth.frequency // Param.t
synth->Synth.detune // Param.t

// Lifecycle
synth->Synth.dispose()
synth->Synth.sync()
synth->Synth.unsync()`}
    />

    <h2 id="fmsynth"> {Component.text("FMSynth")} </h2>
    <p>
      {Component.text(
        "A frequency modulation synthesizer. Same trigger interface as Synth, plus modulation controls.",
      )}
    </p>
    <CodeBlock
      code={`let fm = FMSynth.make()
let fm2 = FMSynth.makeWithOptions({
  modulationIndex: 10.0,
  harmonicity: 3.0,
})

fm->FMSynth.asAudioNode->AudioNode.toDestination
fm->FMSynth.triggerAttackRelease("A3", "2n")

// FM-specific properties
fm->FMSynth.harmonicity // Param.t
fm->FMSynth.modulationIndex // Param.t`}
    />

    <h2 id="amsynth"> {Component.text("AMSynth")} </h2>
    <p>
      {Component.text(
        "An amplitude modulation synthesizer.",
      )}
    </p>
    <CodeBlock
      code={`let am = AMSynth.make()
am->AMSynth.asAudioNode->AudioNode.toDestination
am->AMSynth.triggerAttackRelease("G3", "4n")

am->AMSynth.harmonicity // Param.t`}
    />

    <h2 id="monosynth"> {Component.text("MonoSynth")} </h2>
    <p>
      {Component.text(
        "A monophonic synthesizer with one oscillator, a filter, and two envelopes.",
      )}
    </p>
    <CodeBlock
      code={`let mono = MonoSynth.make()
let mono2 = MonoSynth.makeWithOptions({
  oscillator: {\"type": "sawtooth"},
  filterEnvelope: {
    attack: 0.01,
    decay: 0.3,
    sustain: 0.2,
    release: 0.5,
    baseFrequency: 200.0,
    octaves: 4.0,
  },
})

mono->MonoSynth.asAudioNode->AudioNode.toDestination
mono->MonoSynth.triggerAttackRelease("D3", "8n")`}
    />

    <h2 id="polysynth"> {Component.text("PolySynth")} </h2>
    <p>
      {Component.text(
        "A polyphonic synthesizer that can play multiple notes simultaneously.",
      )}
    </p>
    <CodeBlock
      code={`let poly = PolySynth.make()
poly->PolySynth.asAudioNode->AudioNode.toDestination

// Play a chord
poly->PolySynth.triggerAttack(["C4", "E4", "G4"])
poly->PolySynth.triggerRelease(["C4", "E4", "G4"])

poly->PolySynth.triggerAttackRelease(["C4", "E4", "G4"], "2n")

// Set max polyphony
poly->PolySynth.maxPolyphony // int
poly->PolySynth.releaseAll()`}
    />
  </article>
}
