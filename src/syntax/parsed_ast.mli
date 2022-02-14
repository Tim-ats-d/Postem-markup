type 'a with_loc = { loc : Lexing.position * Lexing.position; value : 'a }

type t = expr list

and expr =
  | LText of string
  | LWhite of string
  | LUnformat of string
  | LGroup of expr list
  | LUnaryOp of { op : string with_loc; group : expr }
