open Xote

%%raw(`import './styles.css'`)

Router.init(~basePath="/rescript-tone", ())

// If the page was prerendered (SSR), hydrate to attach reactivity.
// Otherwise, mount fresh (dev server, or non-prerendered 404 fallback).
let hasSSRContent: bool = %raw(`
  document.getElementById('app')?.childNodes.length > 0
`)

if hasSSRContent {
  Hydration.hydrateById(() => <App />, "app")
} else {
  Component.mountById(<App />, "app")
}
