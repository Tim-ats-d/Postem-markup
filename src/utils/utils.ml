module Char = struct
  include Char

  let to_string = String.make 1

  let concat chars = List.map to_string chars |> String.concat ""
end

module String = struct
  include String

  let empty = ""

  let is_empty str = str = ""

  let of_chars chars = String.of_seq (List.to_seq chars)

  let to_chars str = String.to_seq str |> List.of_seq

  let concat_first sep = function [] -> "" | l -> sep ^ String.concat sep l

  let join = String.concat ""

  let split_lines = String.split_on_char '\n'
end

module File = struct
  type t = string

  let read_all filename =
    let ic = open_in filename in
    let rec read_lines acc =
      try input_line ic :: acc |> read_lines
      with _ ->
        close_in_noerr ic;
        List.rev acc |> String.concat "\n"
    in
    read_lines []

  let write filename str =
    let oc = open_out filename in
    Printf.fprintf oc "%s\n" str;
    close_out oc
end
