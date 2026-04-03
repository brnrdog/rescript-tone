open Xote

@val external navigator: {..} = "navigator"
@val external setTimeout: (unit => unit, int) => unit = "setTimeout"

type props = {code: string}

let make = (props: props) => {
  let copied = Signal.make(false)

  let copyCode = () => {
    let _ = navigator["clipboard"]["writeText"](props.code)
    Signal.set(copied, true)
    setTimeout(() => Signal.set(copied, false), 2000)
  }

  <div class="code-block">
    <div class="code-block-header">
      {Component.element(
        "button",
        ~attrs=[
          Component.attr("class", "code-block-copy"),
          Component.attr("title", "Copy to clipboard"),
        ],
        ~events=[("click", _ => copyCode())],
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
    <pre class="code-block-pre">
      <code class="code-block-code">
        {SyntaxHighlight.highlight(props.code)}
      </code>
    </pre>
  </div>
}
