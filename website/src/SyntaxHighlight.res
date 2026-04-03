open Xote

let keywords = [
  "let",
  "type",
  "module",
  "open",
  "switch",
  "if",
  "else",
  "true",
  "false",
  "and",
  "or",
  "rec",
  "external",
  "include",
  "when",
  "async",
  "await",
]

let types = ["int", "string", "bool", "float", "array", "option", "unit", "promise"]

let highlightToken = (token: string) => {
  if keywords->Array.includes(token) {
    <span class="syntax-keyword"> {Component.text(token)} </span>
  } else if types->Array.includes(token) {
    <span class="syntax-type"> {Component.text(token)} </span>
  } else if token == "=>" || token == "->" || token == "|>" || token == "==" || token == "!=" {
    <span class="syntax-operator"> {Component.text(token)} </span>
  } else {
    Component.text(token)
  }
}

let highlightLine = (line: string) => {
  let trimmed = line->String.trim
  if trimmed->String.startsWith("//") {
    <span class="syntax-comment"> {Component.text(line)} </span>
  } else {
    // Check for strings
    let parts = line->String.split("\"")
    if Array.length(parts) > 1 {
      Component.fragment(
        parts->Array.mapWithIndex((part, i) => {
          if mod(i, 2) == 1 {
            <span class="syntax-string">
              {Component.text("\"" ++ part ++ "\"")}
            </span>
          } else {
            let words = part->String.split(" ")
            Component.fragment(
              words->Array.mapWithIndex((word, j) => {
                let separator = if j > 0 {
                  Component.text(" ")
                } else {
                  Component.text("")
                }
                Component.fragment([separator, highlightToken(word)])
              }),
            )
          }
        }),
      )
    } else {
      let words = line->String.split(" ")
      Component.fragment(
        words->Array.mapWithIndex((word, i) => {
          let separator = if i > 0 {
            Component.text(" ")
          } else {
            Component.text("")
          }
          Component.fragment([separator, highlightToken(word)])
        }),
      )
    }
  }
}

let highlight = (code: string) => {
  let lines = code->String.split("\n")
  Component.fragment(
    lines->Array.mapWithIndex((line, i) => {
      let lineNum = Int.toString(i + 1)
      <div class="syntax-line">
        <span class="syntax-line-number"> {Component.text(lineNum)} </span>
        <span class="syntax-line-content"> {highlightLine(line)} </span>
      </div>
    }),
  )
}
