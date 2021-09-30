type document = Document of expr list

and expr =
  | Alias of string * string
  | Block of block
  | Int of int
  | Text of string
  | Seq of expr list
  | White of int * whitespace

and block = Quotation of expr

and whitespace = CarriageReturn | Newline | Tab | Space | Unknown of char
