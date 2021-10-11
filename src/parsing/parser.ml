open Ast.Ast_types
open Common
open Parse_lib.Combinator
open Utils

let pint =
  let to_expr digits =
    let i = digits |> String.of_chars |> int_of_string in
    Int i
  in
  digit_one |> map to_expr <?> "int"

let pwhite =
  let char_to_whitespace = function
    | '\r' -> CarriageReturn
    | '\n' -> Newline
    | '\t' -> Tab
    | ' ' -> Space
    | c -> Unknown c
  in
  let to_expr chars =
    let whites = String.of_chars chars in
    let type' = char_to_whitespace whites.[0] in
    White (String.length whites, type')
  in
  white_one |> map to_expr <?> "whitespace"

let ptext =
  let to_expr chars = Text (String.of_chars chars) in
  text_one |> map to_expr <?> "text"

let punformat =
  let to_expr str = Unformat (String.of_chars str) in
  let left = pstring "{{{" and right = pstring "}}}" in
  let all = many_one (satisfy (fun _ -> true) "all") in
  between left all right |> map to_expr <?> "unformat"

let palias =
  let to_expr (name, value) = Alias (name, value) in
  let text =
    surround quote (many not_quote) |> map String.of_chars <?> "text"
  in
  assoc ident (pstring "==") text |> map to_expr <?> "alias"

let pinclude =
  let to_expr chars = Include (String.of_chars chars) in
  surround exclam_mark (many not_exclamation_mark) |> map to_expr <?> "include"

let pexpr = palias <|> pint <|> pinclude <|> pwhite <|> ptext <?> "expr"

let pseq =
  let to_expr elist = Seq elist in
  many_one pexpr |> map to_expr <?> "seq"

let pconclusion =
  let to_block (_, seq) = Block (Conclusion seq) in
  prefix (pstring "--") pseq |> map to_block <?> "conclusion"

let pdefinition =
  let to_block (name, value) = Block (Definition (name, value)) in
  assoc ptext (pstring "%%") pseq |> map to_block <?> "definition"

let pheading =
  let to_block (level, seq) = Block (Heading (List.length level, seq)) in
  prefix (many_one (pchar '&')) pseq |> map to_block <?> "heading"

let pquotation =
  let to_block (_, expr) = Block (Quotation expr) in
  prefix (pchar '>') pseq |> map to_block <?> "quotation"

let pblock = pconclusion <|> pdefinition <|> pheading <|> pquotation <?> "block"

let pdocument =
  let delim = pstring "$$" in
  let to_doc elist = Document elist in
  sep_by (pseq <|> pblock) delim |> map to_doc <?> "document"

let error_position label msg { Parse_lib.Position.current_line; line; column } =
  let open Printf in
  let pos = sprintf "Line %i, characters %i" line column
  and failure_caret = sprintf "%s^ %s" (String.make column ' ') msg in
  sprintf "%s: Error parsing %s\n%s\n%s" pos label current_line failure_caret

let parse str =
  match run pdocument str with
  | Sucess (ast, _) -> Ok ast
  | Failure (label, msg, pos) -> Error (error_position label msg pos)
