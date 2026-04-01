/**
 * Static Site Generation for rescript-tone docs.
 *
 * For every route:
 *   1. Calls Router.initSSR to set the path (no browser APIs).
 *   2. Calls App.make({}) to build the virtual node tree.
 *   3. Calls SSR.renderNodeToString to serialise it to HTML.
 *   4. Injects the markup into the Vite-built index.html shell.
 *   5. Writes the result to dist/<route>/index.html.
 *
 * Run with: node scripts/prerender.mjs
 */

// Register the custom ESM loader to stub CSS/asset imports.
// Must happen before any app code is imported.
import { register } from "node:module";
import { pathToFileURL } from "node:url";
register("./scripts/node-loader.mjs", pathToFileURL("./"));

// DOM/browser shims must load before any app code
import "./dom-shim.mjs";

import { readFileSync, writeFileSync, mkdirSync } from "node:fs";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";

const __dirname = dirname(fileURLToPath(import.meta.url));
const distDir = join(__dirname, "..", "dist");

const routes = [
  "/",
  "/getting-started",
  "/api/core",
  "/api/instruments",
  "/api/effects",
  "/api/sources",
  "/api/components",
  "/api/signals",
  "/api/scheduling",
  "/examples",
];

// Read the Vite-built shell
const shell = readFileSync(join(distDir, "index.html"), "utf-8");

// Import Xote and the compiled App component
const { Router, SSR } = await import("xote");
const App = await import("../src/App.res.mjs");

console.log("Prerendering routes...\n");

for (const route of routes) {
  // Initialise the router for this path (server-safe, no DOM access)
  // JS signature: initSSR(basePath, pathname, search, hash, _unit)
  Router.initSSR("/rescript-tone", route, "", "", undefined);

  // Build the component tree (App.make already wraps with Layout)
  const appNode = App.make({});

  // Render the virtual node tree to an HTML string
  const html = SSR.renderNodeToString(appNode);

  // Inject into the shell, replacing the empty #app div
  const page = shell.replace(
    '<div id="app"></div>',
    `<div id="app">${html}</div>`
  );

  // Write to the correct path
  const outPath =
    route === "/"
      ? join(distDir, "index.html")
      : join(distDir, route.slice(1), "index.html");

  mkdirSync(dirname(outPath), { recursive: true });
  writeFileSync(outPath, page, "utf-8");
  console.log(`  ✓ ${route}`);
}

// Also write 404.html from the index shell (SPA fallback)
const fallback = readFileSync(join(distDir, "index.html"), "utf-8");
writeFileSync(join(distDir, "404.html"), fallback, "utf-8");

console.log("\n  ✓ 404.html (SPA fallback)");
console.log("\nDone — prerendered", routes.length, "pages.\n");
