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

  let concat_first sep = function [] -> "" | l -> sep ^ String.concat sep l

  let join = String.concat ""

  let split_lines = String.split_on_char '\n'

  let strip_first str =
    let l = String.length str in
    if l = 0 || l = 1 then "" else String.sub str 1 (l - 1)
end

module File = struct
  type t = string

  let is_exist filename =
    try
      open_in filename |> ignore;
      true
    with Sys_error _ -> false

  let read_all filename =
    let ic = open_in filename in
    let rec read_lines acc =
      try input_line ic :: acc |> read_lines
      with _ ->
        close_in_noerr ic;
        List.rev acc |> String.concat "\n"
    in
    read_lines []
end
