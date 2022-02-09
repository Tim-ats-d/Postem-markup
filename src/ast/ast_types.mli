type loc = { startpos : Lexing.position; endpos : Lexing.position }

type doc = expr list

and expr =
  | AliasDef of { name : string; value : string }
  | Text of string
  | OpWord of { op : char; word : string }
  | OpLine of { op : string; line : expr list }
  | Unformat of string
  | White of string
