open Xote

// ---- Navigation data ----
type docItem = {
  title: string,
  path: string,
}

type docCategory = {
  label: string,
  items: array<docItem>,
}

let docsNav: array<docCategory> = [
  {
    label: "Getting Started",
    items: [{title: "Installation & Setup", path: "/getting-started"}],
  },
  {
    label: "API Reference",
    items: [
      {title: "Core & Transport", path: "/api/core"},
      {title: "Instruments", path: "/api/instruments"},
      {title: "Sources", path: "/api/sources"},
      {title: "Effects", path: "/api/effects"},
      {title: "Components", path: "/api/components"},
      {title: "Signal & Gain", path: "/api/signals"},
      {title: "Scheduling", path: "/api/scheduling"},
    ],
  },
  {
    label: "Resources",
    items: [
      {title: "Examples", path: "/examples"},
    ],
  },
]

// Flatten for prev/next
let flatItems = docsNav->Array.flatMap(cat => cat.items)

// Find prev/next
let getPrevNext = (currentPath: string) => {
  let idx = flatItems->Array.findIndex(item => item.path == currentPath)
  let prev = if idx > 0 {
    flatItems->Array.get(idx - 1)
  } else {
    None
  }
  let next = if idx >= 0 && idx < Array.length(flatItems) - 1 {
    flatItems->Array.get(idx + 1)
  } else {
    None
  }
  (prev, next)
}

// Find category + title for breadcrumb
let getCategoryAndTitle = (currentPath: string) => {
  let result = ref(("", ""))
  docsNav->Array.forEach(cat => {
    cat.items->Array.forEach(item => {
      if item.path == currentPath {
        result := (cat.label, item.title)
      }
    })
  })
  result.contents
}

// ---- Sidebar ----
module Sidebar = {
  type props = {currentPath: string}

  let make = (props: props) => {
    let {currentPath} = props
    <aside class="docs-sidebar">
      {Component.fragment(
        docsNav->Array.map(category => {
          <div class="sidebar-section">
            <div class="sidebar-section-title"> {Component.text(category.label)} </div>
            {Component.fragment(
              category.items->Array.map(item => {
                let isActive = currentPath == item.path
                let className = "sidebar-link" ++ (isActive ? " active" : "")
                Router.link(
                  ~to=item.path,
                  ~attrs=[Component.attr("class", className)],
                  ~children=[Component.text(item.title)],
                  (),
                )
              }),
            )}
          </div>
        }),
      )}
    </aside>
  }
}

// ---- Breadcrumb ----
module DocsBreadcrumb = {
  type props = {currentPath: string}

  let make = (props: props) => {
    let (category, title) = getCategoryAndTitle(props.currentPath)
    <nav class="docs-breadcrumb">
      {Router.link(~to="/getting-started", ~children=[Component.text("Docs")], ())}
      {if category != "" && category != "Getting Started" {
        Component.fragment([
          <span class="docs-breadcrumb-sep"> {Component.text("/")} </span>,
          <span> {Component.text(category)} </span>,
        ])
      } else {
        Component.fragment([])
      }}
      <span class="docs-breadcrumb-sep"> {Component.text("/")} </span>
      <span class="docs-breadcrumb-current"> {Component.text(title)} </span>
    </nav>
  }
}

// ---- Table of Contents ----
module TableOfContents = {
  type props = {}

  type tocEntry = {
    id: string,
    text: string,
    level: int,
  }

  let make = (_props: props) => {
    let entries: Signal.t<array<tocEntry>> = Signal.make([])
    let activeId = Signal.make("")

    // Extract headings from the .docs-content container after render
    let _ = Effect.run(() => {
      let extract: unit => unit = %raw(`function() {
        setTimeout(function() {
          var container = document.querySelector('.docs-content');
          if (!container) return;
          var headings = container.querySelectorAll('h2[id], h3[id]');
          var items = [];
          headings.forEach(function(h) {
            items.push({
              id: h.id,
              text: h.textContent || '',
              level: h.tagName === 'H2' ? 2 : 3
            });
          });
          if (items.length > 0) {
            window.__tocSetEntries(items);
          }
        }, 100);
      }`)

      let setEntries: array<tocEntry> => unit = %raw(`function(items) {
        window.__tocSetEntries = function() {};
      }`)
      ignore(setEntries)

      // Register the setter globally so the raw JS can call it
      let _: unit = %raw(`window.__tocSetEntries = function(items) {}`)
      let registerSetter: (array<tocEntry> => unit) => unit = %raw(`function(fn) {
        window.__tocSetEntries = fn;
      }`)
      registerSetter(items => Signal.set(entries, items))

      extract()

      // Scroll spy: track which heading is active
      let onScroll: unit => unit = %raw(`function() {
        var container = document.querySelector('.docs-content');
        if (!container) return;
        var headings = container.querySelectorAll('h2[id], h3[id]');
        var current = '';
        var offset = 100;
        headings.forEach(function(h) {
          var rect = h.getBoundingClientRect();
          if (rect.top <= offset) {
            current = h.id;
          }
        });
        if (window.__tocSetActive) {
          window.__tocSetActive(current);
        }
      }`)

      let registerActive: (string => unit) => unit = %raw(`function(fn) {
        window.__tocSetActive = fn;
      }`)
      registerActive(id => Signal.set(activeId, id))

      let addScroll: unit => unit = %raw(`function() {
        window.addEventListener('scroll', function() {
          var container = document.querySelector('.docs-content');
          if (!container) return;
          var headings = container.querySelectorAll('h2[id], h3[id]');
          var current = '';
          var offset = 100;
          headings.forEach(function(h) {
            var rect = h.getBoundingClientRect();
            if (rect.top <= offset) {
              current = h.id;
            }
          });
          if (window.__tocSetActive) {
            window.__tocSetActive(current);
          }
        }, { passive: true });
      }`)
      ignore(onScroll)
      addScroll()

      None
    })

    <aside class="docs-toc">
      <div class="toc-title"> {Component.text("On this page")} </div>
      <nav class="toc-nav">
        {Component.signalFragment(
          Computed.make(() => {
            let items = Signal.get(entries)
            items->Array.map(entry => {
              let baseClass =
                "toc-link" ++
                (entry.level == 3 ? " toc-link-sub" : "")
              Component.element(
                "a",
                ~attrs=[
                  Component.attr("href", "#" ++ entry.id),
                  Component.computedAttr("class", () =>
                    baseClass ++ (Signal.get(activeId) == entry.id ? " active" : "")
                  ),
                ],
                ~children=[Component.text(entry.text)],
                (),
              )
            })
          }),
        )}
      </nav>
    </aside>
  }
}

// ---- Prev/Next ----
module PrevNextNav = {
  type props = {currentPath: string}

  let make = (props: props) => {
    let (prev, next) = getPrevNext(props.currentPath)
    <div class="docs-prev-next">
      {switch prev {
      | Some(item) =>
        Router.link(
          ~to=item.path,
          ~attrs=[Component.attr("class", "docs-prev-next-link")],
          ~children=[
            <span class="docs-prev-next-label">
              {Component.text("\u2190 Previous")}
            </span>,
            <span class="docs-prev-next-title"> {Component.text(item.title)} </span>,
          ],
          (),
        )
      | None => <div />
      }}
      {switch next {
      | Some(item) =>
        Router.link(
          ~to=item.path,
          ~attrs=[Component.attr("class", "docs-prev-next-link next")],
          ~children=[
            <span class="docs-prev-next-label">
              {Component.text("Next \u2192")}
            </span>,
            <span class="docs-prev-next-title"> {Component.text(item.title)} </span>,
          ],
          (),
        )
      | None => <div />
      }}
    </div>
  }
}

// ---- Feedback Widget ----
module FeedbackWidget = {
  type props = {}

  let make = (_props: props) => {
    let feedback = Signal.make("")

    <div class="docs-feedback">
      {Component.text("Was this page helpful?")}
      {Component.element(
        "button",
        ~attrs=[
          Component.computedAttr("class", () =>
            "feedback-btn" ++ (Signal.get(feedback) == "yes" ? " selected" : "")
          ),
          Component.attr("title", "Yes"),
        ],
        ~events=[("click", _ => Signal.set(feedback, "yes"))],
        ~children=[Component.text("\u{1F44D}")],
        (),
      )}
      {Component.element(
        "button",
        ~attrs=[
          Component.computedAttr("class", () =>
            "feedback-btn" ++ (Signal.get(feedback) == "no" ? " selected" : "")
          ),
          Component.attr("title", "No"),
        ],
        ~events=[("click", _ => Signal.set(feedback, "no"))],
        ~children=[Component.text("\u{1F44E}")],
        (),
      )}
    </div>
  }
}

// ---- Main docs page component ----
type props = {
  currentPath: string,
  content: Component.node,
}

let make = (props: props) => {
  let {currentPath, content} = props

  <div class="docs-layout">
    <Sidebar currentPath />
    <div class="docs-main">
      <DocsBreadcrumb currentPath />
      <div class="docs-content"> {content} </div>
      <PrevNextNav currentPath />
      <FeedbackWidget />
    </div>
    <TableOfContents />
  </div>
}
