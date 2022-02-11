type loc = { startpos : Lexing.position; endpos : Lexing.position }

type doc = expr list

and expr =
  | Text of string
  | White of string
  | Unformat of string
  | Group of expr list
  | UnaryOp of { op : string; group : expr }
  | AliasDef of { name : string; value : string }
