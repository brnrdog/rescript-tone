open Xote

type props = {}

let make = (_props: props) => {
  <Layout>
    {Router.routes([
      {
        pattern: "/",
        render: _ => <Pages__Home />,
      },
      {
        pattern: "/getting-started",
        render: _ =>
          <DocsPage
            currentPath="/getting-started"
            content={<Pages__GettingStarted />}
          />,
      },
      {
        pattern: "/api/core",
        render: _ =>
          <DocsPage
            currentPath="/api/core"
            content={<Pages__ApiCore />}
          />,
      },
      {
        pattern: "/api/instruments",
        render: _ =>
          <DocsPage
            currentPath="/api/instruments"
            content={<Pages__ApiInstruments />}
          />,
      },
      {
        pattern: "/api/effects",
        render: _ =>
          <DocsPage
            currentPath="/api/effects"
            content={<Pages__ApiEffects />}
          />,
      },
      {
        pattern: "/api/sources",
        render: _ =>
          <DocsPage
            currentPath="/api/sources"
            content={<Pages__ApiSources />}
          />,
      },
      {
        pattern: "/api/components",
        render: _ =>
          <DocsPage
            currentPath="/api/components"
            content={<Pages__ApiComponents />}
          />,
      },
      {
        pattern: "/api/signals",
        render: _ =>
          <DocsPage
            currentPath="/api/signals"
            content={<Pages__ApiSignals />}
          />,
      },
      {
        pattern: "/api/scheduling",
        render: _ =>
          <DocsPage
            currentPath="/api/scheduling"
            content={<Pages__ApiScheduling />}
          />,
      },
      {
        pattern: "/examples",
        render: _ =>
          <DocsPage
            currentPath="/examples"
            content={<Pages__Examples />}
          />,
      },
    ])}
  </Layout>
}
