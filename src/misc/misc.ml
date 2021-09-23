module Int = struct
  let range a b =
    let rec loop i acc =
      if i = a then i :: acc else i :: acc |> loop (pred i)
    in
    loop b []
end

module Option = struct
  let merge f a b =
    match (a, b) with
    | None, None -> None
    | Some x, None | None, Some x -> Some x
    | Some x, Some y -> Some (f x y)
end

module Char = struct
  let to_string = String.make 1

  let is_space chr = to_string chr |> String.trim = ""

  let ( -- ) a b =
    List.map char_of_int (Int.range (int_of_char a) (int_of_char b))
end

module String = struct
  let is_empty str = str = ""

  let of_char_list chars = String.of_seq (List.to_seq chars)

  let to_char_list str = String.to_seq str |> List.of_seq

  let join chr = Char.to_string chr |> String.concat

  let strip_first str =
    let l = String.length str in
    if l = 0 || l = 1 then "" else String.sub str 1 (l - 1)

  let split_map_join ?(on = ' ') f str =
    String.split_on_char on str |> List.map f |> join on
end
