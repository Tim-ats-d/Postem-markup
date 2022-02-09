type t = (name * doc * (module Ast.Expansion.S)) list
and name = string
and doc = string

let expansions : t = [ ("default", "output to plain text.", (module Default)) ]
