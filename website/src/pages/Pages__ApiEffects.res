open Xote

type props = {}

let make = (_props: props) => {
  <article class="docs-article">
    <h1 id="effects"> {Component.text("Effects")} </h1>
    <p>
      {Component.text(
        "Effects process audio signals. Connect them between a source and the destination to modify the sound. All effects have a wet property to control the mix.",
      )}
    </p>

    <h2 id="reverb"> {Component.text("Reverb")} </h2>
    <CodeBlock
      code={`let reverb = Reverb.make()
let reverb2 = Reverb.makeWithDecay(3.0)
let reverb3 = Reverb.makeWithOptions({
  decay: 2.5,
  preDelay: 0.01,
  wet: 0.8,
})

reverb->Reverb.decay // time
reverb->Reverb.setDecay(4.0)
reverb->Reverb.preDelay // time
reverb->Reverb.wet // Param.t
reverb->Reverb.ready // promise<unit>
reverb->Reverb.generate() // promise<t>`}
    />

    <h2 id="freeverb"> {Component.text("Freeverb")} </h2>
    <CodeBlock
      code={`let verb = Freeverb.make()
let verb2 = Freeverb.makeWithOptions({
  roomSize: 0.8,
  dampening: 3000.0,
})

verb->Freeverb.roomSize // Param.t
verb->Freeverb.dampening // Param.t`}
    />

    <h2 id="delay"> {Component.text("FeedbackDelay")} </h2>
    <CodeBlock
      code={`let delay = FeedbackDelay.make()
let delay2 = FeedbackDelay.makeWithOptions({
  delayTime: "8n",
  feedback: 0.3,
  wet: 0.5,
})

delay->FeedbackDelay.delayTime // Param.t
delay->FeedbackDelay.feedback // Param.t`}
    />

    <h2 id="pingpong"> {Component.text("PingPongDelay")} </h2>
    <CodeBlock
      code={`let ppd = PingPongDelay.make()
let ppd2 = PingPongDelay.makeWithOptions({
  delayTime: "4n",
  feedback: 0.4,
})`}
    />

    <h2 id="chorus"> {Component.text("Chorus")} </h2>
    <CodeBlock
      code={`let chorus = Chorus.make()
let chorus2 = Chorus.makeWithOptions({
  frequency: 1.5,
  delayTime: 3.5,
  depth: 0.7,
})

chorus->Chorus.frequency // Param.t
chorus->Chorus.delayTime // float
chorus->Chorus.depth // float
chorus->Chorus.start()`}
    />

    <h2 id="distortion"> {Component.text("Distortion")} </h2>
    <CodeBlock
      code={`let dist = Distortion.make()
let dist2 = Distortion.makeWithOptions({
  distortion: 0.8,
  oversample: "4x",
})

dist->Distortion.distortion // float
dist->Distortion.setDistortion(0.5)`}
    />

    <h2 id="phaser"> {Component.text("Phaser")} </h2>
    <CodeBlock
      code={`let phaser = Phaser.make()
let phaser2 = Phaser.makeWithOptions({
  frequency: 0.5,
  octaves: 3,
  baseFrequency: 350.0,
})`}
    />

    <h2 id="tremolo"> {Component.text("Tremolo & Vibrato")} </h2>
    <CodeBlock
      code={`let trem = Tremolo.make()
trem->Tremolo.start()
trem->Tremolo.frequency // Param.t
trem->Tremolo.depth // Param.t

let vib = Vibrato.make()
vib->Vibrato.frequency // Param.t
vib->Vibrato.depth // Param.t`}
    />

    <h2 id="other"> {Component.text("Other Effects")} </h2>
    <p>
      {Component.text(
        "Additional effects include AutoFilter, AutoPanner, AutoWah, BitCrusher, Chebyshev, FrequencyShifter, JCReverb, PitchShift, and StereoWidener. They all follow the same pattern:",
      )}
    </p>
    <CodeBlock
      code={`// All effects follow this pattern:
let effect = SomeEffect.make()
// or
let effect = SomeEffect.makeWithOptions({...})

// Connect in a chain
synth->Synth.asAudioNode
->AudioNode.connect(effect->SomeEffect.asAudioNode)
->AudioNode.toDestination

// Control wet/dry mix
effect->SomeEffect.wet // Param.t

// Cleanup
effect->SomeEffect.dispose()`}
    />
  </article>
}
