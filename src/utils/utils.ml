module Char = struct
  include Char

  let to_string = String.make 1
end

module String = struct
  include String

  let empty = ""

  let is_empty = ( = ) ""

  let concat_first sep = function [] -> "" | l -> sep ^ String.concat sep l

  let join = String.concat ""

  let real_split chr str =
    String.split_on_char chr str |> List.filter (( <> ) "")

  let concat_lines = String.concat "\n"

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
        List.rev acc |> String.concat_lines
    in
    read_lines []

  let line filename line_nb =
    let ic = open_in filename in
    for _ = 1 to line_nb - 1 do
      ignore (input_line ic)
    done;
    input_line ic

  let write filename str =
    let oc = open_out filename in
    Printf.fprintf oc "%s\n" str;
    close_out oc
end

module Error_msg = struct
  open Lexing
  open Printf

  type t = string

  let of_position ?(hint = "") { pos_fname; pos_lnum; pos_cnum; pos_bol; _ }
      ~msg =
    let char_pos = pos_cnum - pos_bol in
    if pos_fname = "REPL" then
      Printf.sprintf "Error: %s.\n%s %i:%i" msg pos_fname pos_lnum char_pos
    else
      let padding = String.make (string_of_int pos_lnum |> String.length) ' ' in
      let cline = File.line pos_fname pos_lnum in
      let overview =
        sprintf
          " \027[0;34m%s╷\n\
           %i │\027[0m %s\n\
           %s \027[0;34m│\027[0m%s\027[0;31m^\027[0m\n\
           %s \027[0;34m╵\027[0m" padding pos_lnum cline padding
          (String.make (if char_pos = 0 then 0 else char_pos - 1) ' ')
          padding
      and carret = sprintf "%s %s %i:%i" padding pos_fname pos_lnum char_pos
      and hint =
        if String.is_empty hint then ""
        else Printf.sprintf "\027[0;33mHint: %s.\027[0m" hint
      in
      sprintf "\027[0;31mError: %s.\027[0m\n%s\n%s\n%s" msg overview carret hint

  let of_lexbuf { lex_curr_p; _ } ~msg = of_position lex_curr_p ~msg
end
