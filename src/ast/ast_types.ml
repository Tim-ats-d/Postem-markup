type document = Document of expr list

and expr =
  | Alias of string * string
  | Block of block
  | Int of int
  | Include of string
  | Listing of expr list
  | Text of string
  | Seq of expr list
  | White of int * whitespace

and block =
  | Conclusion of expr
  | Definition of expr * expr
  | Heading of int * expr
  | Quotation of expr

and whitespace = CarriageReturn | Newline | Tab | Space | Unknown of char
