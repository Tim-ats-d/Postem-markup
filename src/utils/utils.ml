module Int = struct
  include Int

  let range a b =
    let rec loop i acc =
      if i = a then i :: acc else i :: acc |> loop (pred i)
    in
    loop b []
end

module Option = struct
  include Option

  let merge f a b =
    match (a, b) with
    | None, None -> None
    | Some x, None | None, Some x -> Some x
    | Some x, Some y -> Some (f x y)
end

module Char = struct
  include Char

  let to_string = String.make 1

  let is_alpha = function 'A' .. 'Z' | 'a' .. 'z' -> true | _ -> false

  let is_digit = function '0' .. '9' -> true | _ -> false

  let is_space chr = to_string chr |> String.trim = ""

  let ( -- ) a b =
    List.map char_of_int (Int.range (int_of_char a) (int_of_char b))
end

module String = struct
  include String

  let is_empty str = str = ""

  let of_chars chars = String.of_seq (List.to_seq chars)

  let to_chars str = String.to_seq str |> List.of_seq

  let join chr = Char.to_string chr |> String.concat

  let strip_first str =
    let l = String.length str in
    if l = 0 || l = 1 then "" else String.sub str 1 (l - 1)

  let split_map_join ?(on = ' ') f str =
    String.split_on_char on str |> List.map f |> join on
end

module List = struct
  include List

  let run_length_encoding f lst =
    let rec loop i acc lst =
      match lst with
      | [] -> acc
      | [ x ] -> f 1 x :: acc
      | fst :: snd :: tl ->
          if fst = snd then loop (i + 1) acc (snd :: tl)
          else loop 1 (f i fst :: acc) (snd :: tl)
    in
    loop 1 [] lst |> List.rev
end
