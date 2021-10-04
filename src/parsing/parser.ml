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
  let to_expr (name, value) = Alias (name, value) in
  let text =
    surround quote (many not_quote) |> map String.of_chars <?> "text"
  in
  assoc ident (pstring "==") text |> map to_expr <?> "alias"

let pinclude =
  let to_expr chars = Include (String.of_chars chars) in
  surround exclam_mark (many not_exclamation_mark) |> map to_expr <?> "include"

let pexpr = palias <|> pint <|> pinclude <|> ptext <|> pwhite <?> "expr"

let pseq =
  let to_expr expr = Seq expr in
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

let split lst elem =
  let rec loop out acc = function
    | [] -> List.rev acc :: out
    | hd :: tl ->
        if hd = elem then loop (List.rev acc :: out) [] tl
        else loop out (hd :: acc) tl
  in
  loop [] [] lst |> List.rev

let pdocument =
  let to_doc elist =
    let rec loop doc acc = function
      | [] -> List.rev acc @ doc
      | hd :: tl -> (
          match hd with
          | White (i, Newline) when i > 1 ->
              let new_seq = List.rev acc in
              loop (Seq new_seq :: doc) [] tl
          | Seq s -> loop (Seq acc :: doc) [] s
          (* | Block b ->
             begin match b with
             | Conclusion e | Quotation e -> loop (Seq acc :: output) [] e
             | Definition (name, value) ->
               let name = loop doc

                 loop (Definition :: acc) loop ()
             end *)
          | e -> loop doc (e :: acc) tl)
    in
    Document (loop [] [] elist)
  in
  many_one (pseq <|> pblock) |> map to_doc <?> "document"
(* many_one (pseq <|> pblock) |> map (fun d -> Document d) <?> "document" *)

let error_position label msg { Parse_lib.Position.current_line; line; column } =
  let open Printf in
  let pos = sprintf "Line %i, characters %i" line column
  and failure_caret = sprintf "%s^ %s" (String.make column ' ') msg in
  sprintf "%s: Error parsing %s\n%s\n%s" pos label current_line failure_caret

(* let parse str =
   match run pdocument str with
   | Sucess (ast, _) -> Ok ast
   | Failure (label, msg, pos) -> Error (error_position label msg pos) *)
