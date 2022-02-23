type doc = expr list [@@deriving show]

and expr =
  | Text of string
  | White of string
  | Group of expr list
  | UnaryOp of { op : string; group : expr }
