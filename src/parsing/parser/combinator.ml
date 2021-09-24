open Printf

type 'a parser_result = Sucess of 'a | Failure of label * error * Position.t

and label = string

and error = string

type 'a parser = {
  func : Input_state.t -> ('a * Input_state.t) parser_result;
  label : label;
}

let set_label p new_label =
  let func input =
    match p.func input with
    | Sucess _ as s -> s
    | Failure (_, err, pos) -> Failure (new_label, err, pos)
  in
  { func; label = new_label }

let ( <?> ) = set_label

let get_label p = p.label

let position_of_input_state is =
  {
    Position.current_line = Input_state.current_line is;
    line = is.position.line;
    column = is.position.column;
  }

let satisfy predicate label =
  let func input =
    let remaining, char_opt = Input_state.next_char input in
    match char_opt with
    | None ->
        let pos = position_of_input_state input in
        Failure (label, "No more input", pos)
    | Some first ->
        if predicate first then Sucess (first, remaining)
        else
          let err = sprintf "Unexpected '%c'" first
          and pos = position_of_input_state input in
          Failure (label, err, pos)
  in
  { func; label }

let pchar char_to_match =
  let predicate = Char.equal char_to_match
  and label = Utils.Char.to_string char_to_match in
  satisfy predicate label

let run_on_input { func; _ } input = func input

let run parser (input : string) = run_on_input parser (Input_state.of_str input)

let bind f p =
  let func input =
    match run_on_input p input with
    | Failure _ as err -> err
    | Sucess (value, remaining) -> run_on_input (f value) remaining
  in
  { func; label = "unknown" }

let ( >>= ) p f = bind f p

let return x =
  let func input = Sucess (x, input) in
  { func; label = "x" }

let map f = bind (fun x -> return (f x))

let apply fp xp =
  fp >>= fun f ->
  xp >>= fun x -> return (f x)

let lift2 f x y = apply (apply (return f) x) y

let and_then p1 p2 =
  let label = sprintf "%s and_then %s" (get_label p1) (get_label p2) in
  set_label
    ( p1 >>= fun res1 ->
      p2 >>= fun res2 -> return (res1, res2) )
    label

let or_else p1 p2 =
  let label = sprintf "%s or_else %s" (get_label p1) (get_label p2) in
  let func input =
    let res1 = run_on_input p1 input in
    match res1 with Sucess _ -> res1 | Failure _ -> run_on_input p2 input
  in
  { func; label }

let choice = pchar ' ' |> List.fold_left or_else

let any_of chars =
  let label = Utils.String.of_chars chars |> sprintf "any of %s" in
  set_label (chars |> List.map pchar |> choice) label

let rec sequence parsers =
  let cons_p = lift2 List.cons in
  match parsers with [] -> return [] | hd :: tl -> cons_p hd (sequence tl)

let rec parse_zero_or_more parser input =
  match run_on_input parser input with
  | Failure _ -> ([], input)
  | Sucess (first, input_after_first_parse) ->
      let subvalues, remaining =
        parse_zero_or_more parser input_after_first_parse
      in
      (first :: subvalues, remaining)

let many p =
  let label = get_label p |> sprintf "many %s"
  and func input = Sucess (parse_zero_or_more p input) in
  { func; label }

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
  Utils.String.to_chars str |> List.map pchar |> sequence
  |> map Utils.String.of_chars

let read_all_chars input =
  let rec loop acc str =
    let remaining, char_opt = Input_state.next_char str in
    match char_opt with None -> acc | Some c -> loop (c :: acc) remaining
  in
  loop [] input |> List.rev
