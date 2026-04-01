/**
 * Custom Node.js ESM loader that stubs non-JS asset imports
 * (CSS, SVG, images) so the app modules can be loaded in Node for SSR.
 */

const assetExtensions = [".css", ".svg", ".png", ".jpg", ".jpeg", ".gif", ".webp"];

export async function resolve(specifier, context, nextResolve) {
  if (assetExtensions.some((ext) => specifier.endsWith(ext))) {
    return {
      shortCircuit: true,
      url: "data:text/javascript,export default ''",
    };
  }
  return nextResolve(specifier, context);
}
