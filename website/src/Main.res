open Xote

%%raw(`import './styles.css'`)

Router.init(~basePath="/rescript-tone", ())

// Prerendered HTML provides instant first paint and SEO.
// Clear it and mount fresh for full reactivity — the transition
// is imperceptible since the JS executes immediately after load.
%%raw(`
  var el = document.getElementById('app');
  if (el) el.innerHTML = '';
`)
Component.mountById(<App />, "app")
