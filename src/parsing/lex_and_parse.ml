open Printf
open Utils

let error_position label msg { Parse_lib.Position.current_line; line; column } =
  let pos = sprintf "Line %i, characters %i" line column
  and failure_caret = sprintf "%s^ %s" (String.make column ' ') msg in
  sprintf "%s: Error parsing %s\n%s\n%s" pos label current_line failure_caret

let print_result =
  let open Parse_lib.Combinator in
  function
  | Sucess (value, _) -> String.of_chars value |> eprintf "%s\n"
  | Failure (label, msg, pos) -> error_position label msg pos |> prerr_endline
