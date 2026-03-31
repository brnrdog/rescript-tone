open Xote

type props = {}

let make = (_props: props) => {
  <article class="docs-article">
    <h1 id="core-transport"> {Component.text("Core & Transport")} </h1>

    <h2 id="core"> {Component.text("Core")} </h2>
    <p>
      {Component.text(
        "The Core module provides top-level Tone.js functions for managing the audio context.",
      )}
    </p>

    <h3> {Component.text("Functions")} </h3>
    <CodeBlock
      code={`// Start the audio context (must be called from a user gesture)
Core.start() // promise<unit>

// Get the current audio time
Core.now() // seconds

// Get the most recent audio time
Core.immediate() // seconds

// Get references to global singletons
Core.getContext() // Context.t
Core.getTransport() // Transport.t
Core.getDestination() // Destination.t

// Wait for all audio buffers to load
Core.loaded() // promise<unit>

// Check Web Audio API support
Core.supported() // bool

// Get the Tone.js version string
Core.version // string`}
    />

    <h2 id="context"> {Component.text("Context")} </h2>
    <p>
      {Component.text(
        "The Context wraps the native Web Audio AudioContext and provides additional features.",
      )}
    </p>
    <CodeBlock
      code={`// Create a new context
let ctx = Context.make()

// Properties
ctx->Context.currentTime // seconds
ctx->Context.state // audioContextState
ctx->Context.sampleRate // float
ctx->Context.lookAhead // seconds
ctx->Context.setLookAhead(0.1)
ctx->Context.latencyHint // string

// Lifecycle
ctx->Context.resume() // promise<unit>
ctx->Context.close() // promise<unit>
ctx->Context.dispose()`}
    />

    <h2 id="transport"> {Component.text("Transport")} </h2>
    <p>
      {Component.text(
        "The Transport is Tone.js's main timekeeper. It provides scheduling, tempo, time signature, and looping.",
      )}
    </p>

    <h3> {Component.text("Playback")} </h3>
    <CodeBlock
      code={`let transport = Core.getTransport()

transport->Transport.start()
transport->Transport.startAt(~time="0")
transport->Transport.stop()
transport->Transport.pause()
transport->Transport.toggle()
transport->Transport.cancel()`}
    />

    <h3> {Component.text("Scheduling")} </h3>
    <CodeBlock
      code={`// Schedule a one-time event
let id = transport->Transport.schedule(time => {
  Console.log2("event at", time)
}, "0:0:0")

// Schedule a repeating event
let id2 = transport->Transport.scheduleRepeat(time => {
  Console.log2("repeat at", time)
}, "4n")

// Schedule a one-time event that auto-clears
let _ = transport->Transport.scheduleOnce(_time => {
  Console.log("once!")
}, "1m")

// Clear a scheduled event
transport->Transport.clear(id)`}
    />

    <h3> {Component.text("Tempo & Time")} </h3>
    <CodeBlock
      code={`// BPM (returns Param.t for automation)
transport->Transport.bpm

// Position
transport->Transport.position // "0:0:0"
transport->Transport.setPosition("1:0:0")
transport->Transport.seconds // float
transport->Transport.ticks // int
transport->Transport.state // "started" | "stopped" | "paused"

// Time signature
transport->Transport.timeSignature // int
transport->Transport.setTimeSignature(4)

// Swing
transport->Transport.swing // normalRange
transport->Transport.setSwing(0.5)`}
    />

    <h3> {Component.text("Looping")} </h3>
    <CodeBlock
      code={`transport->Transport.setLoop(true)
transport->Transport.setLoopStart("0:0:0")
transport->Transport.setLoopEnd("4:0:0")

// Or set both at once
transport->Transport.setLoopPoints("0:0:0", "4:0:0")`}
    />

    <h2 id="destination"> {Component.text("Destination")} </h2>
    <p>
      {Component.text(
        "Destination represents the master output. All audio is routed here by default.",
      )}
    </p>
    <CodeBlock
      code={`let dest = Core.getDestination()

dest->Destination.volume // Param.t
dest->Destination.mute // bool
dest->Destination.setMute(true)`}
    />

    <h2 id="audionode"> {Component.text("AudioNode")} </h2>
    <p>
      {Component.text(
        "AudioNode is the base type for all audio-producing and audio-processing nodes.",
      )}
    </p>
    <CodeBlock
      code={`// Connect nodes together
nodeA->AudioNode.connect(nodeB)
nodeA->AudioNode.disconnect()
nodeA->AudioNode.disconnectFrom(nodeB)

// Connect to the speakers
node->AudioNode.toDestination()

// Chain multiple nodes: A -> B -> C -> ...
nodeA->AudioNode.chain([nodeB, nodeC])

// Fan out: A -> B, A -> C
nodeA->AudioNode.fan([nodeB, nodeC])

// Properties
node->AudioNode.numberOfInputs // int
node->AudioNode.numberOfOutputs // int
node->AudioNode.channelCount // int

// Cleanup
node->AudioNode.dispose()`}
    />
  </article>
}
