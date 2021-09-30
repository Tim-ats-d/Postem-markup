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

  let is_num = function '0' .. '9' -> true | _ -> false

  let is_symbol = function
    | '~' .. '{' | '@' .. ':' | '/' .. '!' -> true
    | _ -> false
end

module String = struct
  include String

  let is_empty str = str = ""

  let of_chars chars = String.of_seq (List.to_seq chars)

  let to_chars str = String.to_seq str |> List.of_seq

  let strip_first str =
    let l = String.length str in
    if l = 0 || l = 1 then "" else String.sub str 1 (l - 1)

  let join = String.concat ""
end
