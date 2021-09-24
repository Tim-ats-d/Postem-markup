open Parser.Combinator

let whitespace_char = satisfy Utils.Char.is_space "whitespace"

let spaces = many whitespace_char

and spaces_one = many_one whitespace_char

let digit_char = satisfy Utils.Char.is_digit "digit"

let text = satisfy (fun _ -> true) "text"

let parse_int =
  let result_to_int (sign, digits) =
    let i = digits |> Utils.String.of_chars |> int_of_string in
    match sign with Some _ -> -i | None -> i
  in
  let digits = many_one digit_char and sign = opt (pchar '-') in
  and_then sign digits
  |> map result_to_int
  <?> "integer"
