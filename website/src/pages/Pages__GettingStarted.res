open Xote

type props = {}

let make = (_props: props) => {
  <article class="docs-article">
    <h1 id="getting-started"> {Component.text("Getting Started")} </h1>

    <h2 id="installation"> {Component.text("Installation")} </h2>
    <p>
      {Component.text(
        "Install rescript-tone and its peer dependency tone via your package manager:",
      )}
    </p>
    <CodeBlock code="npm install rescript-tone tone" />
    <p> {Component.text("Or with yarn:")} </p>
    <CodeBlock code="yarn add rescript-tone tone" />

    <h2 id="configuration"> {Component.text("ReScript Configuration")} </h2>
    <p>
      {Component.text(
        "Add rescript-tone to your bs-dependencies in rescript.json:",
      )}
    </p>
    <CodeBlock
      code={`{
  "bs-dependencies": [
    "rescript-tone"
  ]
}`}
    />

    <h2 id="first-sound"> {Component.text("Your First Sound")} </h2>
    <p>
      {Component.text(
        "All Tone.js modules are available under the Tone namespace. Here's how to play a simple note:",
      )}
    </p>
    <CodeBlock
      code={`open Tone

// Create a synth and connect it to the speakers
let synth = Synth.make()
synth->Synth.asAudioNode->AudioNode.toDestination

// Tone.js requires a user gesture to start audio
let startAudio = async () => {
  await Core.start()
  synth->Synth.triggerAttackRelease("C4", "8n")
}`}
    />

    <div class="callout callout-note">
      <div class="callout-title"> {Component.text("Note")} </div>
      <p>
        {Component.text(
          "Browsers require a user interaction (click, tap) before audio can play. Always call Core.start() inside an event handler.",
        )}
      </p>
    </div>

    <h2 id="core-concepts"> {Component.text("Core Concepts")} </h2>

    <h3> {Component.text("Audio Nodes")} </h3>
    <p>
      {Component.text(
        "Every sound-producing or sound-modifying module in Tone.js is an AudioNode. Nodes can be connected together to form a signal chain:",
      )}
    </p>
    <CodeBlock
      code={`// Synth -> Reverb -> Destination
let synth = Synth.make()
let reverb = Reverb.make()

synth->Synth.asAudioNode
->AudioNode.connect(reverb->Reverb.asAudioNode)
->AudioNode.toDestination`}
    />

    <h3> {Component.text("The asAudioNode Pattern")} </h3>
    <p>
      {Component.text(
        "Each module provides an asAudioNode function to cast its type to AudioNode.t. This is the common interface for connecting, disconnecting, and routing audio:",
      )}
    </p>
    <CodeBlock
      code={`// Every module can be cast to AudioNode.t
synth->Synth.asAudioNode->AudioNode.connect(...)
reverb->Reverb.asAudioNode->AudioNode.connect(...)
delay->FeedbackDelay.asAudioNode->AudioNode.connect(...)`}
    />

    <h3> {Component.text("Transport")} </h3>
    <p>
      {Component.text(
        "The Transport is Tone.js's main timekeeper. Use it to schedule events, set tempo, and control playback:",
      )}
    </p>
    <CodeBlock
      code={`// Set BPM and start the transport
Transport.setBpm(120.0)
Transport.start()

// Schedule a callback
Transport.schedule(~callback=_time => {
  synth->Synth.triggerAttackRelease("C4", "8n")
}, ~time="0")`}
    />

    <h2 id="requirements"> {Component.text("Requirements")} </h2>
    <ul>
      <li> {Component.text("ReScript >= 12.0.0")} </li>
      <li> {Component.text("Tone.js >= 15.0.0")} </li>
      <li> {Component.text("A browser with Web Audio API support")} </li>
    </ul>
  </article>
}
