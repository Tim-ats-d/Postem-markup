module Lexing = struct
  include Lexing

  let pp_position fmt _t = Format.fprintf fmt "loc"
end

type 'a with_loc = { loc : Lexing.position * Lexing.position; value : 'a }
[@@deriving show]

type t = expr list [@@deriving show]

and expr =
  | LText of string
  | LWhite of string
  | LNewline of string
  | LUnformat of string
  | LGroup of expr list
  | LUnaryOp of { op : string with_loc; group : expr; newline : string }
