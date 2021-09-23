open Misc.String

type 'a parser_result = Sucess of 'a | Failure of string

type 'a parser = Parser of (string -> ('a * string) parser_result)

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

let bind f p =
  let aux input =
    match run p input with
    | Failure _ as err -> err
    | Sucess (value, remaining) -> run (f value) remaining
  in
  Parser aux

let ( >>= ) p f = bind f p

let return x =
  let aux input = Sucess (x, input) in
  Parser aux

let map f = bind (fun x -> return (f x))

let apply fp xp =
  fp >>= fun f ->
  xp >>= fun x -> return (f x)

let lift2 f x y = apply (apply (return f) x) y

let and_then p1 p2 =
  p1 >>= fun res1 ->
  p2 >>= fun res2 -> return (res1, res2)

let or_else parser1 parser2 =
  let aux input =
    let res1 = run parser1 input in
    match res1 with Sucess _ -> res1 | Failure _ -> run parser2 input
  in
  Parser aux

let choice = pchar ' ' |> List.fold_left or_else (* TODO *)

let any_of chars = chars |> List.map pchar |> choice

let rec sequence parsers =
  let cons_p = lift2 List.cons in
  match parsers with [] -> return [] | hd :: tl -> cons_p hd (sequence tl)

let rec parse_zero_or_more parser input =
  match run parser input with
  | Failure _ -> ([], input)
  | Sucess (first, input_after_first_parse) ->
      let subvalues, remaining =
        parse_zero_or_more parser input_after_first_parse
      in
      (first :: subvalues, remaining)

let many parser =
  let aux input = Sucess (parse_zero_or_more parser input) in
  Parser aux

let many_one p =
  p >>= fun hd ->
  many p >>= fun tl -> return (hd :: tl)

let opt parser =
  let some = map Option.some parser and none = return None in
  or_else some none

let throw_right p1 p2 = and_then p1 p2 |> map fst

let throw_left p1 p2 = and_then p1 p2 |> map snd

let between p1 p2 p3 = throw_left p1 (throw_right p2 p3)

let sep_by_one p sep =
  let sep_then_p = throw_left sep p in
  and_then p (many sep_then_p) |> map (fun (p, plist) -> p :: plist)

let sep_by p sep = or_else (sep_by_one p sep) (return [])

let pstring str =
  Misc.String.to_char_list str
  |> List.map pchar |> sequence
  |> map Misc.String.of_char_list

let parse_int =
  let result_to_int (sign, digits) =
    let i = digits |> Misc.String.of_char_list |> int_of_string in
    match sign with Some _ -> -i | None -> i
  in
  let digits = many_one (any_of Misc.Char.('0' -- '9'))
  and sign = opt (pchar '-') in
  and_then sign digits |> map result_to_int
