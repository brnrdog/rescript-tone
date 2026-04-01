/**
 * Register the custom ESM loader using the non-deprecated module.register() API.
 * Used via: node --import ./scripts/node-loader-register.mjs
 */
import { register } from "node:module";
import { pathToFileURL } from "node:url";

register("./scripts/node-loader.mjs", pathToFileURL("./"));
