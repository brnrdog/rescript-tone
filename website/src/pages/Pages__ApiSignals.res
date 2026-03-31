open Xote

type props = {}

let make = (_props: props) => {
  <article class="docs-article">
    <h1 id="signals"> {Component.text("Signal & Gain")} </h1>
    <p>
      {Component.text(
        "Signal, Param, Gain, Volume, and Channel provide low-level control over audio signal flow and parameter automation.",
      )}
    </p>

    <h2 id="param"> {Component.text("Param")} </h2>
    <p>
      {Component.text(
        "Param represents an automatable audio parameter. Many properties on instruments, effects, and components return Param.t values.",
      )}
    </p>
    <CodeBlock
      code={`// Param is returned by many properties:
let vol = synth->Synth.volume // Param.t

// Get/set value
vol->Param.getValue() // float
vol->Param.setValue(-12.0)

// Automation
vol->Param.linearRampTo(-6.0, "1m")
vol->Param.exponentialRampTo(0.0, "2m")
vol->Param.rampTo(-3.0, "500ms")
vol->Param.setValueAtTime(-12.0, "0:0:0")

// Advanced scheduling
vol->Param.linearRampToValueAtTime(0.0, "4m")
vol->Param.exponentialRampToValueAtTime(-6.0, "2m")
vol->Param.setTargetAtTime(-12.0, "0", 0.5)
vol->Param.cancelScheduledValues("0")
vol->Param.cancelAndHoldAtTime("1m")
vol->Param.setRampPoint("0")`}
    />

    <h2 id="signal"> {Component.text("Signal")} </h2>
    <p>
      {Component.text(
        "A schedulable signal value. Like Param but can be connected to other nodes.",
      )}
    </p>
    <CodeBlock
      code={`let sig = Signal.make()
let sig2 = Signal.makeWithValue(0.5)
let sig3 = Signal.makeWithOptions({
  value: 1.0,
  units: "number",
})

sig->Signal.getValue() // float
sig->Signal.setValue(0.75)
sig->Signal.maxValue // float
sig->Signal.minValue // float

// Same scheduling as Param
sig->Signal.linearRampTo(1.0, "1m")
sig->Signal.rampTo(0.5, "2m")

// Connect to other nodes
sig->Signal.connect(node->AudioNode.t)

// Cast to Param or AudioNode
sig->Signal.asParam // Param.t
sig->Signal.asAudioNode // AudioNode.t`}
    />

    <h2 id="gain"> {Component.text("Gain")} </h2>
    <CodeBlock
      code={`let gain = Gain.make()
let gain2 = Gain.makeWithGain(0.5)
let gain3 = Gain.makeWithOptions({gain: 0.8})

gain->Gain.gain // Param.t`}
    />

    <h2 id="volume"> {Component.text("Volume")} </h2>
    <CodeBlock
      code={`let vol = Volume.make()
let vol2 = Volume.makeWithVolume(-12.0)
let vol3 = Volume.makeWithOptions({volume: -6.0, mute: false})

vol->Volume.volume // Param.t
vol->Volume.mute // bool
vol->Volume.setMute(true)`}
    />

    <h2 id="channel"> {Component.text("Channel")} </h2>
    <CodeBlock
      code={`let ch = Channel.make()
let ch2 = Channel.makeWithOptions({
  volume: -6.0,
  pan: 0.0,
  mute: false,
  solo: false,
})

ch->Channel.volume // Param.t
ch->Channel.pan // Param.t
ch->Channel.mute // bool
ch->Channel.solo // bool
ch->Channel.send("bus-name", -12.0) // returns Gain.t
ch->Channel.receive("bus-name")`}
    />

    <h2 id="crossfade"> {Component.text("CrossFade")} </h2>
    <CodeBlock
      code={`let xfade = CrossFade.make()

xfade->CrossFade.fade // Param.t
xfade->CrossFade.a // Gain.t
xfade->CrossFade.b // Gain.t`}
    />
  </article>
}
