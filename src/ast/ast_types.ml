type loc = { startpos : Lexing.position; endpos : Lexing.position }

type ident = { name : string; value : string }

type value =
  [ `MetamarkArgs of loc * ident
  | `MetamarkSingle of loc * string
  | `Text of string
  | `Whitespace of string
  | `Unformat of string ]

type expr = [ `AliasDef of ident | value ]

type 'a document = 'a element list

and 'a element = Block of 'a block | Paragraph of 'a list

and 'a block =
  | Conclusion of 'a list
  | Definition of 'a list * 'a list
  | Heading of Share.TitleLevel.t * 'a list
  | Quotation of 'a list
