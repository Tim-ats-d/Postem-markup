open Parse_lib.Combinator
open Utils

let carriage_return_one = many_one (pchar '\r')

and newline_one = pchar '\n'

and tab_one = many_one (pchar '\t')

and space_one = many_one (pchar ' ')

let whitespaces = carriage_return_one <|> tab_one <|> space_one

let alpha = satisfy Char.is_alpha "text"

let alpha_one = many_one alpha

let many_space = many whitespaces

let opt_sign = opt (pchar '-')

let digit = satisfy Char.is_digit "digit"
