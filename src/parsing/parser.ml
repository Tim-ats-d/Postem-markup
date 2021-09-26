open Ast.Ast_types
open Common
open Parse_lib.Combinator
open Utils

let pint =
  let to_expr (sign, digits) =
    let i = digits |> String.of_chars |> int_of_string in
    Int (match sign with Some _ -> -i | None -> i)
  in
  opt_sign <&> many_one digit |> map to_expr <?> "int"

let pwhitespace =
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
  whitespaces |> map to_expr <?> "whitespace"

let ptext =
  let to_expr chars = Text (String.of_chars chars) in
  many_one alpha |> map to_expr <?> "text"

let palias =
  let to_expr ((name, _), value) =
    String.(Alias (of_chars name, of_chars value))
  in

  let name = throw_right alpha_one many_space
  and equal = throw_right (pstring "==") many_space
  and value = alpha_one in
  name <&> equal <&> value |> map to_expr <?> "alias"

let pblock =
  let to_expr b = Block b in
  many_one (pint <|> pwhitespace <|> ptext <|> palias) |> map to_expr <?> "expr"

let pdocument =
  let to_expr d = Document d in
  sep_by pblock (pstring "\n\n") |> map to_expr <?> "document"
