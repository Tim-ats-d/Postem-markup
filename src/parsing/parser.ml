open Ast.Ast_types
open Parse_lib.Combinator
open Utils

let alpha = satisfy Char.is_alpha "text"

let alpha_one = many_one alpha

let whitespace = satisfy Char.is_space "whitespace"

let spaces = many whitespace

let opt_sign = opt (pchar '-')

let digit = satisfy Char.is_digit "digit"

module type PARSER = sig
  val label : string

  val parse : expr parser
end

module IntParser : PARSER = struct
  let label = "int"

  let to_expr (sign, digits) =
    let i = digits |> String.of_chars |> int_of_string in
    Int (match sign with Some _ -> -i | None -> i)

  let parse = opt_sign <&> many_one digit |> map to_expr
end

module WhiteSpaceParser : PARSER = struct
  let label = "whitespace"

  let char_to_whitespace = function
    | '\r' -> CarriageReturn
    | '\n' -> Newline
    | '\t' -> Tab
    | ' ' -> Space
    | c -> Unknown c

  let to_expr chars =
    List.run_length_encoding (fun i x -> White (i, char_to_whitespace x)) chars
    |> List.fold_left (fun a b -> Block (a, b)) EOF

  let parse = many_one whitespace |> map to_expr
end

module TextParser : PARSER = struct
  let label = "text"

  let to_expr chars = Text (String.of_chars chars)

  let parse = many_one alpha |> map to_expr
end

module AliasParser : PARSER = struct
  let label = "alias"

  let to_expr ((name, _), value) =
    String.(Alias (of_chars name, of_chars value))

  let parse =
    let name = throw_right alpha_one spaces
    and equal = throw_right (pstring "==") spaces
    and value = alpha_one in
    name <&> equal <&> value |> map to_expr
end

module BlockParser = struct
  let label = "block"

  let to_expr = List.fold_left (fun a b -> Block (a, b)) EOF

  let to_expr = List.fold_left (fun a b -> Block (a, b)) EOF

  let parse =
    let parse_expr =
      many IntParser.parse <|> many TextParser.parse <|> many AliasParser.parse
      |> map to_expr in
    sep_by parse_expr WhiteSpaceParser.parse |> map to_expr
end

let make_parser (module P : PARSER) =
  P.(parse <?> label)


let parse_document = sep_by BlockParser.parse (pstring "\n\n") <?> "document"
