open Parse_lib.Combinator
open Utils

let carriage_return_one = many_one (pchar '\r')

(* and newline_one = pchar '\n' *)

and tab_one = many_one (pchar '\t')

and space_one = many_one (pchar ' ')

let whitespaces = carriage_return_one <|> tab_one <|> space_one

let many_space = many whitespaces

let alpha = satisfy Char.is_alpha "alpha"

let alpha_one = many_one alpha

let symbol = satisfy Char.is_symbol "symbol"

let symbol_one = many_one symbol

let opt_sign = opt (pchar '-')

let digit = satisfy Char.is_num "digit"

let digit_one = many_one digit

let text = alpha_one <|> symbol_one <|> digit_one
