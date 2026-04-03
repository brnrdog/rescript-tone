open Xote

type props = {}

let make = (_props: props) => {
  <article class="docs-article">
    <h1 id="components"> {Component.text("Components")} </h1>
    <p>
      {Component.text(
        "Components are audio-processing nodes for dynamics, filtering, and routing.",
      )}
    </p>

    <h2 id="compressor"> {Component.text("Compressor")} </h2>
    <CodeBlock
      code={`let comp = Compressor.make()
let comp2 = Compressor.makeWithThreshold(-24.0)
let comp3 = Compressor.makeWithOptions({
  threshold: -24.0,
  ratio: 4.0,
  attack: 0.003,
  release: 0.25,
  knee: 30.0,
})

comp->Compressor.threshold // Param.t
comp->Compressor.ratio // Param.t
comp->Compressor.attack // Param.t
comp->Compressor.release // Param.t
comp->Compressor.knee // Param.t
comp->Compressor.reduction // decibels`}
    />

    <h2 id="limiter"> {Component.text("Limiter")} </h2>
    <CodeBlock
      code={`let limiter = Limiter.make()
let limiter2 = Limiter.makeWithThreshold(-6.0)

limiter->Limiter.threshold // Param.t
limiter->Limiter.reduction // decibels`}
    />

    <h2 id="gate"> {Component.text("Gate")} </h2>
    <CodeBlock
      code={`let gate = Gate.make()
let gate2 = Gate.makeWithOptions({
  threshold: -40.0,
  smoothing: 0.1,
})

gate->Gate.threshold // decibels
gate->Gate.smoothing // float`}
    />

    <h2 id="filter"> {Component.text("Filter")} </h2>
    <CodeBlock
      code={`let filter = Filter.make()
let filter2 = Filter.makeWithOptions({
  frequency: 1000.0,
  \"type": "lowpass",
  rolloff: -12,
  q: 1.0,
})

filter->Filter.frequency // Param.t
filter->Filter.detune // Param.t
filter->Filter.gain // Param.t
filter->Filter.q // Param.t
filter->Filter.getType() // filterType
filter->Filter.setType("highpass")
filter->Filter.rolloff // int`}
    />

    <h2 id="eq3"> {Component.text("EQ3")} </h2>
    <CodeBlock
      code={`let eq = EQ3.make()
let eq2 = EQ3.makeWithOptions({
  low: -6.0,
  mid: 0.0,
  high: 3.0,
  lowFrequency: 400.0,
  highFrequency: 2500.0,
})

eq->EQ3.low // Param.t
eq->EQ3.mid // Param.t
eq->EQ3.high // Param.t`}
    />

    <h2 id="panner"> {Component.text("Panner")} </h2>
    <CodeBlock
      code={`let panner = Panner.make()
let panner2 = Panner.makeWithPan(0.5)

panner->Panner.pan // Param.t`}
    />
  </article>
}
