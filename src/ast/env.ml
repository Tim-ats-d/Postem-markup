type t = { expsn : (module Expansion.Type.S); metadata : metadata }

and metadata = { mutable headers : (int * string) list }

let create (module Expsn : Expansion.Type.S) =
  { expsn = (module Expsn); metadata = { headers = [] } }
