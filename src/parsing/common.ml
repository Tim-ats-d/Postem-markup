open Parse_lib.Combinator
open Utils

let carriage_return = pchar '\r'

and newline = pchar '\n'

and tab = pchar '\t'

and space = pchar ' '

let white = carriage_return <|> newline <|> tab <|> space

let white_one =
  many_one carriage_return <|> many_one newline <|> many_one tab
  <|> many_one space

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

let quote = pchar '"' <?> "quote"

let not_quote = satisfy (( <> ) '"') "text"

let exclam_mark = pchar '!' <?> "exclamation mark"

let not_exclamation_mark = satisfy (( <> ) '!') "filename"

let prefix pop pexpr =
  let mark = throw_right pop many_white in
  mark <&> pexpr

let assoc pleft pop pright =
  let ignore_white ((l, _), r) = (l, r) in
  throw_right pleft many_white
  <&> throw_right pop many_white <&> pright |> map ignore_white

let surround pby pmiddle = between pby pmiddle pby
