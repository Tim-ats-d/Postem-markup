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
    White (String.length whites, char_to_whitespace whites.[0])
  in
  white_one |> map to_expr <?> "whitespace"

let ptext =
  let to_expr chars = Text (String.of_chars chars) in
  letter_one |> map to_expr <?> "text"

let palias =
  let to_expr ((name, _), value) = Alias (name, value) in
  let text =
    let quote = pchar '"' <?> "quote" in
    between quote (many not_quote) quote |> map String.of_chars <?> "text"
  in
  let name = throw_right ident many_white
  and equal = throw_right (pstring "==") many_white
  and value = text in
  name <&> equal <&> value |> map to_expr <?> "alias"

let pinclude =
  let to_expr chars = Include (String.of_chars chars) in
  let exclam_mark = pchar '!' <?> "exclamation mark" in
  between exclam_mark (many not_exclamation_mark) exclam_mark
  |> map to_expr <?> "include"

let pexpr = palias <|> pint <|> pinclude <|> ptext <|> pwhite <?> "expr"

let pseq =
  let to_expr expr = Seq expr in
  many_one pexpr |> map to_expr <?> "seq"

let pconclusion =
  let to_block (_, seq) = Block (Conclusion seq) in
  let mark = throw_right (pstring "--") many_white in
  mark <&> pseq |> map to_block <?> "conclusion"

let pdefinition =
  let to_block ((name, _), value) = Block (Definition (name, value)) in
  let name = throw_right ptext many_white
  and mark = throw_right (pstring "%%") many_white
  and value = pseq in
  name <&> mark <&> value |> map to_block <?> "definition"

let pheading =
  let to_block (level, seq) = Block (Heading (List.length level, seq)) in
  let mark = throw_right (many_one (pchar '&')) many_white in
  mark <&> pseq |> map to_block <?> "heading"

let pquotation =
  let to_block (_, expr) = Block (Quotation expr) in
  let mark = throw_right (pchar '>') many_white in
  mark <&> pseq |> map to_block <?> "quotation"

let pblock = pconclusion <|> pdefinition <|> pheading <|> pquotation <?> "block"

let pdocument =
   let to_expr d = Document d in
   sep_by (pseq <|> pblock) (pstring "\n\n") |> map to_expr <?> "document"

(* let error_position label msg { Parse_lib.Position.current_line; line; column } =
   let pos = sprintf "Line %i, characters %i" line column
   and failure_caret = sprintf "%s^ %s" (String.make column ' ') msg in
   sprintf "%s: Error parsing %s\n%s\n%s" pos label current_line failure_caret *)

(* let parse str =
   match run pdocument str with
   | Sucess (ast, _) -> Ok ast
   | Failure (label, msg, pos) -> Error (error_position label msg pos) *)
