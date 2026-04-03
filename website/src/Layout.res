open Xote

// ---- Theme integration via Basefn ----
let _ = {
  // Initialize basefn theme with dark default
  let stored: option<string> = %raw(`localStorage.getItem('basefn-theme')`)
  switch stored {
  | Some(_) => Basefn.Theme.init()
  | None => {
      Basefn.Theme.applyTheme(Dark)
      Signal.set(Basefn.Theme.currentTheme, Dark)
    }
  }
}

let toggleTheme = () => Basefn.Theme.toggleTheme()

// ---- Search data ----
type searchItem = {
  title: string,
  section: string,
  path: string,
}

let searchItems: array<searchItem> = [
  {title: "Installation", section: "Getting Started", path: "/getting-started"},
  {title: "Core & Transport", section: "API Reference", path: "/api/core"},
  {title: "Instruments", section: "API Reference", path: "/api/instruments"},
  {title: "Effects", section: "API Reference", path: "/api/effects"},
  {title: "Sources", section: "API Reference", path: "/api/sources"},
  {title: "Components", section: "API Reference", path: "/api/components"},
  {title: "Signal & Gain", section: "API Reference", path: "/api/signals"},
  {title: "Scheduling", section: "API Reference", path: "/api/scheduling"},
  {title: "Examples", section: "Resources", path: "/examples"},
]

// ---- Search modal ----
let searchOpen = Signal.make(false)
let searchQuery = Signal.make("")
let searchIndex = Signal.make(0)

let filteredItems = Computed.make(() => {
  let q = Signal.get(searchQuery)->String.toLowerCase
  if q == "" {
    searchItems
  } else {
    searchItems->Array.filter(item =>
      item.title->String.toLowerCase->String.includes(q) ||
        item.section->String.toLowerCase->String.includes(q)
    )
  }
})

let navigateToResult = () => {
  let items = Signal.get(filteredItems)
  let idx = Signal.get(searchIndex)
  switch items->Array.get(idx) {
  | Some(item) => {
      Router.push(item.path, ())
      Signal.set(searchOpen, false)
      Signal.set(searchQuery, "")
      Signal.set(searchIndex, 0)
    }
  | None => ()
  }
}

// ---- Search Modal Component ----
module SearchModal = {
  type props = {}

  let make = (_props: props) => {
    // The modal show/hide is fine with signalFragment since the whole modal
    // is either present or absent. But the inner results list must NOT
    // use signalFragment - use computedAttr for the active class instead.
    let searchContent = Computed.make(() => {
      if Signal.get(searchOpen) {
        [
          <div class="search-overlay">
            <div class="search-modal">
              <div class="search-input-wrapper">
                <Basefn.Icon name={Search} size={Sm} />
                {Component.element(
                  "input",
                  ~attrs=[
                    Component.attr("type", "text"),
                    Component.attr("class", "search-input"),
                    Component.attr("placeholder", "Search documentation..."),
                    Component.attr("autofocus", "true"),
                  ],
                  ~events=[
                    ("input", evt => {
                      let target: {..} = Obj.magic(evt)["target"]
                      Signal.set(searchQuery, target["value"])
                      Signal.set(searchIndex, 0)
                    }),
                    ("keydown", evt => {
                      let key: string = Obj.magic(evt)["key"]
                      switch key {
                      | "ArrowDown" => {
                          let _ = Obj.magic(evt)["preventDefault"]()
                          let len = Signal.get(filteredItems)->Array.length
                          let cur = Signal.get(searchIndex)
                          if cur < len - 1 {
                            Signal.set(searchIndex, cur + 1)
                          }
                        }
                      | "ArrowUp" => {
                          let _ = Obj.magic(evt)["preventDefault"]()
                          let cur = Signal.get(searchIndex)
                          if cur > 0 {
                            Signal.set(searchIndex, cur - 1)
                          }
                        }
                      | "Enter" => navigateToResult()
                      | "Escape" => {
                          Signal.set(searchOpen, false)
                          Signal.set(searchQuery, "")
                          Signal.set(searchIndex, 0)
                        }
                      | _ => ()
                      }
                    }),
                  ],
                  (),
                )}
                <span class="search-shortcut"> {Component.text("ESC")} </span>
              </div>
              <div class="search-results">
                // Use signalFragment only for the filtered list (which changes structurally),
                // but use computedAttr for the active highlight (no DOM recreation).
                {Component.signalFragment(
                  Computed.make(() => {
                    let items = Signal.get(filteredItems)
                    if Array.length(items) == 0 {
                      [
                        <div class="search-empty">
                          {Component.text("No results found.")}
                        </div>,
                      ]
                    } else {
                      items->Array.mapWithIndex((item, i) => {
                        Component.element(
                          "div",
                          ~attrs=[
                            Component.computedAttr("class", () =>
                              "search-result-item" ++
                              (Signal.get(searchIndex) == i ? " active" : "")
                            ),
                          ],
                          ~events=[
                            ("click", _ => {
                              Signal.set(searchIndex, i)
                              navigateToResult()
                            }),
                          ],
                          ~children=[
                            <span class="search-result-section">
                              {Component.text(item.section)}
                            </span>,
                            <span class="search-result-title">
                              {Component.text(item.title)}
                            </span>,
                          ],
                          (),
                        )
                      })
                    }
                  }),
                )}
              </div>
              <div class="search-footer">
                {Component.text("Use arrow keys to navigate, Enter to select, Esc to close")}
              </div>
            </div>
            {Component.element(
              "div",
              ~attrs=[Component.attr("class", "search-backdrop")],
              ~events=[
                ("click", _ => {
                  Signal.set(searchOpen, false)
                  Signal.set(searchQuery, "")
                  Signal.set(searchIndex, 0)
                }),
              ],
              (),
            )}
          </div>,
        ]
      } else {
        []
      }
    })
    Component.signalFragment(searchContent)
  }
}

// ---- Header ----
module Header = {
  type props = {}

  let make = (_props: props) => {
    <header class="header">
      <div class="header-inner">
        <div class="header-left">
          {Router.link(
            ~to="/",
            ~attrs=[Component.attr("class", "header-logo")],
            ~children=[Component.text("rescript-tone")],
            (),
          )}
          <nav class="header-nav">
            {Router.link(
              ~to="/getting-started",
              ~children=[Component.text("Docs")],
              (),
            )}
            {Router.link(
              ~to="/api/core",
              ~children=[Component.text("API")],
              (),
            )}
            {Router.link(
              ~to="/examples",
              ~children=[Component.text("Examples")],
              (),
            )}
          </nav>
        </div>
        <div class="header-right">
          {Component.element(
            "button",
            ~attrs=[
              Component.attr("class", "search-trigger"),
              Component.attr("title", "Search"),
            ],
            ~events=[("click", _ => Signal.set(searchOpen, true))],
            ~children=[
              Basefn.Icon.make({name: Search, size: Sm}),
              <span class="search-trigger-text"> {Component.text("Search docs...")} </span>,
              <div class="search-trigger-keys">
                <kbd> {Component.text("\u2318")} </kbd>
                <kbd> {Component.text("K")} </kbd>
              </div>,
            ],
            (),
          )}
          {Component.element(
            "a",
            ~attrs=[
              Component.attr("class", "header-icon-btn"),
              Component.attr("href", "https://github.com/brnrdog/rescript-tone"),
              Component.attr("target", "_blank"),
              Component.attr("rel", "noopener noreferrer"),
              Component.attr("title", "GitHub"),
            ],
            ~children=[Basefn.Icon.make({name: GitHub, size: Sm})],
            (),
          )}
          // Theme toggle: render BOTH icons, toggle visibility via style
          // to avoid signalFragment destroying/recreating DOM nodes
          {Component.element(
            "button",
            ~attrs=[
              Component.attr("class", "header-icon-btn"),
              Component.attr("title", "Toggle theme"),
            ],
            ~events=[("click", _ => toggleTheme())],
            ~children=[
              Component.element(
                "span",
                ~attrs=[
                  Component.computedAttr("style", () =>
                    Signal.get(Basefn.Theme.currentTheme) == Dark
                      ? "display: inline-flex"
                      : "display: none"
                  ),
                ],
                ~children=[Basefn.Icon.make({name: Sun, size: Sm})],
                (),
              ),
              Component.element(
                "span",
                ~attrs=[
                  Component.computedAttr("style", () =>
                    Signal.get(Basefn.Theme.currentTheme) == Dark
                      ? "display: none"
                      : "display: inline-flex"
                  ),
                ],
                ~children=[Basefn.Icon.make({name: Moon, size: Sm})],
                (),
              ),
            ],
            (),
          )}
          {Component.element(
            "button",
            ~attrs=[
              Component.attr("class", "header-icon-btn mobile-menu-btn"),
              Component.attr("title", "Menu"),
            ],
            ~events=[("click", _ => Signal.set(searchOpen, true))],
            ~children=[Basefn.Icon.make({name: Menu, size: Sm})],
            (),
          )}
        </div>
      </div>
    </header>
  }
}

// ---- Footer ----
module Footer = {
  type props = {}

  let make = (_props: props) => {
    <footer class="footer">
      <div class="footer-inner">
        <div class="footer-col footer-brand-col">
          <div class="footer-brand"> {Component.text("rescript-tone")} </div>
          <p class="footer-tagline">
            {Component.text("Type-safe Tone.js bindings for ReScript")}
          </p>
        </div>
        <div class="footer-col">
          <div class="footer-col-title"> {Component.text("Docs")} </div>
          {Router.link(~to="/getting-started", ~children=[Component.text("Getting Started")], ())}
          {Router.link(~to="/api/core", ~children=[Component.text("API Reference")], ())}
          {Router.link(~to="/examples", ~children=[Component.text("Examples")], ())}
        </div>
        <div class="footer-col">
          <div class="footer-col-title"> {Component.text("Links")} </div>
          {Component.element(
            "a",
            ~attrs=[
              Component.attr("href", "https://github.com/brnrdog/rescript-tone"),
              Component.attr("target", "_blank"),
              Component.attr("rel", "noopener noreferrer"),
            ],
            ~children=[Component.text("GitHub")],
            (),
          )}
          {Component.element(
            "a",
            ~attrs=[
              Component.attr("href", "https://www.npmjs.com/package/rescript-tone"),
              Component.attr("target", "_blank"),
              Component.attr("rel", "noopener noreferrer"),
            ],
            ~children=[Component.text("npm")],
            (),
          )}
          {Component.element(
            "a",
            ~attrs=[
              Component.attr("href", "https://tonejs.github.io/"),
              Component.attr("target", "_blank"),
              Component.attr("rel", "noopener noreferrer"),
            ],
            ~children=[Component.text("Tone.js")],
            (),
          )}
        </div>
      </div>
      <div class="footer-bottom">
        {Component.text("MIT License. Built with ReScript + Xote.")}
      </div>
    </footer>
  }
}

// ---- Global keyboard shortcut ----
@val external document: {..} = "document"

let _ = Effect.run(() => {
  let handler = evt => {
    let e: {..} = Obj.magic(evt)
    let key: string = e["key"]
    let meta: bool = e["metaKey"]
    let ctrl: bool = e["ctrlKey"]
    if key == "k" && (meta || ctrl) {
      let _ = e["preventDefault"]()
      let isOpen = Signal.get(searchOpen)
      Signal.set(searchOpen, !isOpen)
      if isOpen {
        Signal.set(searchQuery, "")
        Signal.set(searchIndex, 0)
      }
    }
  }
  let _ = document["addEventListener"]("keydown", handler)
  None
})

// ---- Layout ----
type props = {children: Component.node}

let make = (props: props) => {
  <>
    <Header />
    <SearchModal />
    <main id="main-content"> {props.children} </main>
    <Footer />
  </>
}
