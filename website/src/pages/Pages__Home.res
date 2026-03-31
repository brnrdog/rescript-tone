open Xote

// ---- Clipboard binding ----
@val external navigator: {..} = "navigator"
@val external setTimeout: (unit => unit, int) => unit = "setTimeout"

// ---- Feature data ----
type feature = {
  icon: string,
  title: string,
  description: string,
}

let features: array<feature> = [
  {
    icon: "\u{1F3B9}",
    title: "Full Tone.js Coverage",
    description: "Bindings for synths, effects, sources, scheduling, and more.",
  },
  {
    icon: "\u{1F512}",
    title: "Type-Safe by Default",
    description: "Catch errors at compile time with ReScript's powerful type system.",
  },
  {
    icon: "\u{1F3A7}",
    title: "Web Audio Made Easy",
    description: "Create interactive music in the browser with a simple, expressive API.",
  },
  {
    icon: "\u26A1",
    title: "Zero Runtime Overhead",
    description: "Direct bindings to Tone.js with no wrapper layer or performance cost.",
  },
  {
    icon: "\u{1F4E6}",
    title: "Modular Design",
    description: "Import only what you need. Each module maps directly to Tone.js classes.",
  },
  {
    icon: "\u{1F680}",
    title: "Easy to Get Started",
    description: "Add to your ReScript project in minutes. Works with existing Tone.js knowledge.",
  },
]

// ---- Feature Card ----
module FeatureCard = {
  type props = {feature: feature}

  let make = (props: props) => {
    let {feature} = props
    <div class="feature-card">
      <div class="feature-icon"> {Component.text(feature.icon)} </div>
      <h3 class="feature-title"> {Component.text(feature.title)} </h3>
      <p class="feature-desc"> {Component.text(feature.description)} </p>
    </div>
  }
}

// ---- Hero ----
module Hero = {
  type props = {}

  let make = (_props: props) => {
    <section class="hero">
      <div class="hero-backdrop" />
      <div class="hero-content">
        <h1 class="hero-title">
          <span class="hero-title-accent"> {Component.text("rescript-tone")} </span>
        </h1>
        <p class="hero-subtitle">
          {Component.text(
            "Type-safe ReScript bindings for Tone.js. Build interactive music and audio applications in the browser.",
          )}
        </p>
        <div class="hero-actions">
          {Router.link(
            ~to="/getting-started",
            ~attrs=[Component.attr("class", "btn btn-primary")],
            ~children=[Component.text("Get Started")],
            (),
          )}
          {Router.link(
            ~to="/api/core",
            ~attrs=[Component.attr("class", "btn btn-secondary")],
            ~children=[Component.text("API Reference")],
            (),
          )}
        </div>
        <div class="hero-install">
          <code> {Component.text("npm install rescript-tone tone")} </code>
        </div>
      </div>
    </section>
  }
}

// ---- Features Grid ----
module Features = {
  type props = {}

  let make = (_props: props) => {
    <section class="features-section">
      <h2 class="section-title"> {Component.text("Why rescript-tone?")} </h2>
      <div class="features-grid">
        {Component.fragment(
          features->Array.map(f => <FeatureCard feature=f />),
        )}
      </div>
    </section>
  }
}

// ---- Code Demo ----
module CodeDemo = {
  type props = {}

  let make = (_props: props) => {
    let activeTab = Signal.make("synth")
    let copied = Signal.make(false)

    let synthCode = `open Tone

let synth = Synth.make()
synth->Synth.asAudioNode->AudioNode.toDestination

// Play a note
synth->Synth.triggerAttackRelease("C4", "8n")`

    let effectsCode = `open Tone

let synth = FMSynth.make()
let reverb = Reverb.makeWithOptions({decay: 2.5})
let delay = FeedbackDelay.makeWithOptions({
  delayTime: "8n",
  feedback: 0.3,
})

synth->FMSynth.asAudioNode
->AudioNode.connect(reverb->Reverb.asAudioNode)
->AudioNode.connect(delay->FeedbackDelay.asAudioNode)
->AudioNode.toDestination`

    let schedulingCode = `open Tone

let synth = Synth.make()
synth->Synth.asAudioNode->AudioNode.toDestination

// Schedule a repeating pattern
let _loop = Loop.makeWithCallback(~callback=_time => {
  synth->Synth.triggerAttackRelease("C4", "8n")
}, ~interval="4n")

Transport.start()`

    let getCode = () => {
      switch Signal.get(activeTab) {
      | "effects" => effectsCode
      | "scheduling" => schedulingCode
      | _ => synthCode
      }
    }

    let copyToClipboard = () => {
      let code = getCode()
      let _ = navigator["clipboard"]["writeText"](code)
      Signal.set(copied, true)
      setTimeout(() => Signal.set(copied, false), 2000)
    }

    <section class="code-demo-section">
      <h2 class="section-title"> {Component.text("Expressive & Type-Safe")} </h2>
      <div class="code-demo">
        <div class="code-demo-tabs">
          {Component.element(
            "button",
            ~attrs=[
              Component.computedAttr("class", () =>
                "code-tab" ++ (Signal.get(activeTab) == "synth" ? " active" : "")
              ),
            ],
            ~events=[("click", _ => Signal.set(activeTab, "synth"))],
            ~children=[Component.text("Synth")],
            (),
          )}
          {Component.element(
            "button",
            ~attrs=[
              Component.computedAttr("class", () =>
                "code-tab" ++ (Signal.get(activeTab) == "effects" ? " active" : "")
              ),
            ],
            ~events=[("click", _ => Signal.set(activeTab, "effects"))],
            ~children=[Component.text("Effects Chain")],
            (),
          )}
          {Component.element(
            "button",
            ~attrs=[
              Component.computedAttr("class", () =>
                "code-tab" ++ (Signal.get(activeTab) == "scheduling" ? " active" : "")
              ),
            ],
            ~events=[("click", _ => Signal.set(activeTab, "scheduling"))],
            ~children=[Component.text("Scheduling")],
            (),
          )}
          {Component.element(
            "button",
            ~attrs=[
              Component.attr("class", "code-copy-btn"),
              Component.attr("title", "Copy code"),
            ],
            ~events=[("click", _ => copyToClipboard())],
            ~children=[
              Component.textSignal(() =>
                if Signal.get(copied) {
                  "Copied!"
                } else {
                  "Copy"
                }
              ),
            ],
            (),
          )}
        </div>
        <div class="code-demo-content">
          {Component.signalFragment(
            Computed.make(() => [<CodeBlock code={getCode()} />])
          )}
        </div>
      </div>
    </section>
  }
}

// ---- Community CTA ----
module Community = {
  type props = {}

  let make = (_props: props) => {
    <section class="community-section">
      <h2 class="section-title"> {Component.text("Start Building")} </h2>
      <p class="community-desc">
        {Component.text(
          "Add rescript-tone to your project and start creating audio experiences with the safety of ReScript.",
        )}
      </p>
      <div class="community-links">
        {Router.link(
          ~to="/getting-started",
          ~attrs=[Component.attr("class", "btn btn-primary")],
          ~children=[Component.text("Read the Docs")],
          (),
        )}
        {Component.element(
          "a",
          ~attrs=[
            Component.attr("class", "btn btn-secondary"),
            Component.attr("href", "https://github.com/brnrdog/rescript-tone"),
            Component.attr("target", "_blank"),
            Component.attr("rel", "noopener noreferrer"),
          ],
          ~children=[Component.text("View on GitHub")],
          (),
        )}
        {Component.element(
          "a",
          ~attrs=[
            Component.attr("class", "btn btn-secondary"),
            Component.attr("href", "https://www.npmjs.com/package/rescript-tone"),
            Component.attr("target", "_blank"),
            Component.attr("rel", "noopener noreferrer"),
          ],
          ~children=[Component.text("npm")],
          (),
        )}
      </div>
    </section>
  }
}

// ---- Page ----
type props = {}

let make = (_props: props) => {
  <Layout>
    <Hero />
    <Features />
    <CodeDemo />
    <Community />
  </Layout>
}
