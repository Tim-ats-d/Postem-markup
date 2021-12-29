type loc = { startpos : Lexing.position; endpos : Lexing.position }

type ident = { name : string; value : string }

type value =
  [ `MetaArgsCall of loc * ident
  | `MetaSingleCall of loc * string
  | `Text of string
  | `Whitespace of string ]

type expr = [ `AliasDef of ident | `Unformat of string | value ]

type 'a document = 'a element list

and 'a element = Block of 'a block | Paragraph of 'a list

and 'a block =
  | Conclusion of 'a list
  | Definition of 'a list * 'a list
  | Heading of Share.TitleLevel.t * 'a list
  | Quotation of 'a list
