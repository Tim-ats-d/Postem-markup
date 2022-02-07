type loc = { startpos : Lexing.position; endpos : Lexing.position }

type doc = expr list

and expr =
  | AliasDef of { name : string; value : string }
  | Text of string
  | UnaryOpWord of { op : char; word : string }
  | UnaryOpLine of { uop : char; line : expr list }
  | Unformat of string
  | White of string
