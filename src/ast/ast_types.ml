type loc = Lexing.position

type document = Document of expr list

and expr =
  | Text of string
  | White of int * whitespace
  | Int of int
  | Alias of string * string
  | Marker of (string -> string)
  | Block of expr * expr

and whitespace = CarriageReturn | Newline | Tab | Space | Unknown of char
