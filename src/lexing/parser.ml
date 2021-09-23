open Misc.String

type 'a parser_result = Sucess of 'a | Failure of string

type 'a parser = Parser of (string -> ('a * string) parser_result)

let strip_first str =
  let l = String.length str in
  if l = 0 || l = 1 then "" else String.sub str 1 (l - 1)

let pchar char_to_match =
  let aux str =
    if is_empty str then Failure "No more input"
    else
      let first = str.[0] in
      if first = char_to_match then
        let remaining = strip_first str in
        Sucess (char_to_match, remaining)
      else
        let msg =
          Printf.sprintf "Expecting '%c'. Got '%c'" char_to_match first
        in
        Failure msg
  in
  Parser aux

let run parser input =
  let (Parser aux) = parser in
  aux input

let and_then parser1 parser2 =
  let aux input =
    match run parser1 input with
    | Failure _ as f -> f
    | Sucess (value1, remaining1) -> (
        match run parser2 remaining1 with
        | Failure _ as f -> f
        | Sucess (value2, remaining2) -> Sucess ((value1, value2), remaining2))
  in
  Parser aux

let or_else parser1 parser2 =
  let aux input =
    let res1 = run parser1 input in
    match res1 with Sucess _ -> res1 | Failure _ -> run parser2 input
  in
  Parser aux

let reduce f = List.fold_left f []

let choice = List.fold_left or_else []

let any_of chars = chars |> List.map pchar |> choice

let map f parser =
  let aux input =
    match run parser input with
    | Sucess (value, remaining) -> Sucess (f value, remaining)
    | Failure _ as f -> f
  in
  Parser aux

let return x =
  let aux input = Sucess (x, input) in
  Parser aux

let apply f_parser x_parser =
  and_then f_parser x_parser |> map (fun (f, x) -> f x)

let ( <*> ) = apply

let lift2 f x y = apply (apply (return f) x) y

let add_p = lift2 ( + )

let rec sequence parsers =
  let cons_p = lift2 List.cons in
  match parsers with [] -> return [] | hd :: tl -> cons_p hd (sequence tl)

let parse_three_digit =
  let digits = Misc.Char.('1' -- '9') in
  let parse_digits = any_of digits in
  let tuple_parser = and_then (and_then parse_digits parse_digits) parse_digits
  and transform_tuple ((c1, c2), c3) =
    String.init 3 (fun x -> List.nth [ c1; c2; c3 ] x)
  in
  map transform_tuple tuple_parser |> map int_of_string
