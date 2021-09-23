type loc = Lexing.position

type program = Prog of expr list

and expr =
  | Text of string
  | Alias of string * string
  | Marker of (string -> string)
  | Block of expr * expr

and value = Int of int | Str of string

(* type 'a program = Prog of 'a expr list

   and _ expr =
     | Literal : 'a literal -> 'a expr
     | Id : string -> string expr
     | Alias : (string * string) expr
     | Marker : (string -> string) * _ expr list -> string expr
     | Block : _ expr * _ expr -> _ expr

   and _ literal =
     | Int : int -> int literal
     | Str : string -> string literal *)
