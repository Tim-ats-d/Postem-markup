open Ast.Ast_types
open Parser.Combinator
module U = Utils

let any = satisfy Utils.Char.is_alphanum "text"

let text = many_one any

let whitespace_char = satisfy Utils.Char.is_space "whitespace"

let spaces = many whitespace_char

and spaces_one = many_one whitespace_char

let opt_sign = opt (pchar '-')

let digit_char = satisfy U.Char.is_digit "digit"

let parse_int =
  let result_to_int (sign, digits) =
    let i = digits |> U.String.of_chars |> int_of_string in
    match sign with Some _ -> -i | None -> i
  in
  opt_sign <&> many_one digit_char |> map result_to_int <?> "integer"

let parse_string = many_one any |> map Utils.String.of_chars <?> "string"

let parse_alias =
  let result_to_alias ((name, _), value) =
    U.String.(Alias (of_chars name, of_chars value))
  in
  let name = throw_right text spaces
  and equal = throw_right (pstring "==") spaces
  and value = text in
  name <&> equal <&> value |> map result_to_alias <?> "alias"
