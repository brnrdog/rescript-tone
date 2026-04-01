/**
 * Minimal DOM/browser API shims so the compiled ReScript modules
 * can be imported in Node.js for SSR prerendering.
 */

// localStorage stub
globalThis.localStorage = {
  _store: {},
  getItem(key) {
    return this._store[key] ?? null;
  },
  setItem(key, value) {
    this._store[key] = String(value);
  },
  removeItem(key) {
    delete this._store[key];
  },
  clear() {
    this._store = {};
  },
};

// window stub
globalThis.window = globalThis;
globalThis.window.__XOTE_HYDRATED__ = false;
globalThis.window.__XOTE_STATE__ = {};

// Minimal document stub — enough for Basefn theme init and other module-level code.
const noopEl = {
  classList: { add() {}, remove() {}, toggle() {}, contains: () => false },
  setAttribute() {},
  getAttribute: () => null,
  removeAttribute() {},
  style: {},
  innerHTML: "",
  textContent: "",
  appendChild: () => noopEl,
  removeChild: () => noopEl,
  querySelectorAll: () => [],
  querySelector: () => null,
  addEventListener() {},
  removeEventListener() {},
  children: [],
  childNodes: [],
  parentNode: null,
  tagName: "DIV",
  id: "",
};

globalThis.document = {
  documentElement: { ...noopEl },
  body: { ...noopEl },
  head: { ...noopEl },
  createElement: () => ({ ...noopEl }),
  createTextNode: (t) => ({ ...noopEl, textContent: t }),
  createComment: (t) => ({ ...noopEl, textContent: t }),
  createDocumentFragment: () => ({ ...noopEl, children: [] }),
  getElementById: () => null,
  querySelector: () => null,
  querySelectorAll: () => [],
  addEventListener() {},
  removeEventListener() {},
};

// history / location stubs
globalThis.history = {
  pushState() {},
  replaceState() {},
  state: null,
};

globalThis.location = {
  pathname: "/",
  search: "",
  hash: "",
  href: "http://localhost/",
  origin: "http://localhost",
};

// addEventListener / scrollTo stubs
globalThis.addEventListener = () => {};
globalThis.removeEventListener = () => {};
globalThis.scrollTo = () => {};

// navigator stub
try {
  globalThis.navigator = {
    userAgent: "node",
    clipboard: { writeText: () => Promise.resolve() },
  };
} catch {
  // navigator is read-only in some Node versions
}

// Animation frame stubs
globalThis.requestAnimationFrame = (fn) => setTimeout(fn, 0);
globalThis.cancelAnimationFrame = (id) => clearTimeout(id);

// setTimeout / setInterval already exist in Node

// matchMedia stub (used by some theme detection)
globalThis.matchMedia = () => ({
  matches: false,
  addEventListener: () => {},
  removeEventListener: () => {},
});
