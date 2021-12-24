type loc = { startpos : Lexing.position; endpos : Lexing.position }

type document = expr list

and expr =
  | Alias of string * string
  | Block of block
  | Listing of expr list
  | MetamarkArgs of loc * string * string
  | MetamarkSingle of loc * string
  | Text of string
  | Seq of expr list
  | Unformat of string
  | Whitespace of string

and block =
  | Conclusion of expr
  | Definition of expr * expr
  | Heading of Share.TitleLevel.t * expr
  | Quotation of expr
