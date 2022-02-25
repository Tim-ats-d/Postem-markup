type doc = expr list [@@deriving show]

and expr =
  | Text of string
  | White of string
  | Unformat of string
  | Group of expr list
  | UnaryOp of { op : string; group : expr }
  | BinOp of { op : string; left : expr; right : expr }
