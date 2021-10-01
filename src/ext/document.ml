open Utils

type t = { filename : string; content : string; lines_nb : int; max_line_length : int}

let create filename content =
  let file_lines = String.split_lines content in
  let max_line_length = List.map String.length file_lines |> List.fold_left max 0 in
  let lines_nb = List.length file_lines in
  { filename; content; lines_nb; max_line_length }