open Parse_lib.Combinator
open Utils

let carriage_return = pchar '\r'

and newline = pchar '\n'

and tab = pchar '\t'

and space = pchar ' '

let white = carriage_return <|> newline <|> tab <|> space

let white_one = many_one carriage_return <|> many_one newline <|> many_one tab <|> many_one space

let many_white = many white

let letter = satisfy Char.is_alpha "letter"

let letter_one = many_one letter

let digit = satisfy Char.is_digit "digit"

let digit_one = many_one digit

let ident =
  let to_string (first, chars_list) =
    let rest = List.map Char.concat chars_list |> String.join in
    Char.to_string first ^ rest
  in
  letter <&> many (digit_one <|> letter_one) |> map to_string

let not_quote = satisfy (( <> ) '"') "text"

let not_exclamation_mark = satisfy (( <> ) '!') "filename"
