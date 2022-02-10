type loc = { startpos : Lexing.position; endpos : Lexing.position }

type doc = expr list

and expr =
  | AliasDef of { name : string; value : string }
  | Text of string
  | Group of expr list
  | UnaryOp of { op : string; group : expr }
  | Unformat of string
  | White of string
