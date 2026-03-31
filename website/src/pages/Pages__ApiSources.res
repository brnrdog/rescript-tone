open Xote

type props = {}

let make = (_props: props) => {
  <article class="docs-article">
    <h1 id="sources"> {Component.text("Sources")} </h1>
    <p>
      {Component.text(
        "Sources are audio-producing nodes that generate or play back sound. Unlike instruments, they don't respond to note triggers.",
      )}
    </p>

    <h2 id="oscillator"> {Component.text("Oscillator")} </h2>
    <p>
      {Component.text(
        "Generates a periodic waveform. Supports sine, square, sawtooth, and triangle types.",
      )}
    </p>
    <CodeBlock
      code={`let osc = Oscillator.make()
let osc2 = Oscillator.makeWithOptions({
  frequency: 440.0,
  \"type": "sawtooth",
  detune: 0.0,
  phase: 0.0,
  volume: -12.0,
})
let osc3 = Oscillator.makeWithFreq(440.0, "sine")

osc->Oscillator.asAudioNode->AudioNode.toDestination

// Start/stop
osc->Oscillator.start()
osc->Oscillator.stop()
osc->Oscillator.restart()

// Properties
osc->Oscillator.frequency // Param.t
osc->Oscillator.detune // Param.t
osc->Oscillator.volume // Param.t
osc->Oscillator.getType() // oscillatorType
osc->Oscillator.setType("square")
osc->Oscillator.phase // degrees
osc->Oscillator.partialCount // int
osc->Oscillator.partials // array<float>

// Frequency sync
osc->Oscillator.syncFrequency()
osc->Oscillator.unsyncFrequency()`}
    />

    <h2 id="player"> {Component.text("Player")} </h2>
    <p>
      {Component.text(
        "Plays an audio file. Supports loading from URL and various playback controls.",
      )}
    </p>
    <CodeBlock
      code={`let player = Player.make("path/to/audio.mp3")
let player2 = Player.makeWithOptions({
  url: "path/to/audio.mp3",
  loop: true,
  playbackRate: 1.0,
  autostart: false,
})

player->Player.asAudioNode->AudioNode.toDestination

// Playback
player->Player.start()
player->Player.stop()
player->Player.restart()
player->Player.seek("0:2:0")

// Properties
player->Player.loop // bool
player->Player.setLoop(true)
player->Player.playbackRate // Param.t
player->Player.reverse // bool
player->Player.setReverse(true)
player->Player.loaded // bool
player->Player.buffer // ToneAudioBuffer.t`}
    />

    <h2 id="noise"> {Component.text("Noise")} </h2>
    <p>
      {Component.text(
        "Generates noise. Supports white, pink, and brown noise types.",
      )}
    </p>
    <CodeBlock
      code={`let noise = Noise.make()
let noise2 = Noise.makeWithType("pink")
let noise3 = Noise.makeWithOptions({
  \"type": "brown",
  volume: -20.0,
  playbackRate: 1.0,
})

noise->Noise.asAudioNode->AudioNode.toDestination
noise->Noise.start()
noise->Noise.stop()

noise->Noise.getType() // "white" | "pink" | "brown"
noise->Noise.setType("pink")`}
    />
  </article>
}
