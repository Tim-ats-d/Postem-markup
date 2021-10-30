type t = (name * (module Type.S) * doc) list

and name = string

and doc = string

let expansions : t =
  [
    ("default", (module Default.S), "output to plain text.");
    ("markdown", (module Markdown.S), "output to Markdown.");
    ("html", (module Html.S), "output to HTML.");
  ]
