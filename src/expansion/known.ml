let expansions : (string * (module Type.S)) list =
  [ ("default", (module Default.S)); ("markdown", (module Markdown.S)) ]
