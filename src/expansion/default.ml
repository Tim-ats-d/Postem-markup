open Shared_lib

let initial_alias = Ast.Share.AliasMap.empty

let postprocess lines =
  List.filter (( <> ) "") lines |> Text.Lines.concat "\n\n"

let numerotation =
  let open Enumerate.Builtins in
  let t1 = new upper_case_numeric_roman
  and t2 = new upper_case_latin
  and t3 = new lower_case_greek
  and t4 = new null
  and t5 = new null
  and t6 = new null in
  let open Ast.Share.TitleLevel in
  function T1 -> t1 | T2 -> t2 | T3 -> t3 | T4 -> t4 | T5 -> t5 | T6 -> t6

module Tags : Ast.Expansion.Tags = struct
  let conclusion text = Text.prefix {|\-> |} text

  let definition name values = name ^ Text.Lines.concat_fst "\n  | " values

  let heading num lvl text =
    let uchar =
      let open Ast.Share.TitleLevel in
      match lvl with
      | T1 -> '#'
      | T2 -> '*'
      | T3 -> '='
      | T4 -> '-'
      | T5 -> '^'
      | T6 -> '"'
    in
    let head = if num = "" then text else Printf.sprintf "%s - %s" num text in
    let underlining = String.make (String.length head) uchar in
    Text.between head "\n" underlining

  let paragraph = Fun.id

  let quotation lines = Text.prefix " █ " (Text.Lines.join lines)
end

let enumerate lines =
  List.mapi
    (fun i line ->
      if line = "" then "" else Printf.sprintf "%i. %s" (succ i) line)
    lines
  |> Text.Lines.join_lines

let read filename =
  let read_all fname =
    let ic = open_in fname in
    let rec read_lines acc =
      try input_line ic :: acc |> read_lines
      with _ ->
        close_in_noerr ic;
        List.rev acc |> String.concat "\n"
    in
    read_lines []
  in
  if Sys.file_exists filename then read_all filename
  else raise (Sys_error "in read meta mark: no such file or directory")

module Meta : Ast.Expansion.Meta = struct
  let args =
    Ast.Share.MetaMode.[ ("enumerate", Lines enumerate); ("read", Inline read) ]

  let single = [ ("foo", fun () -> "bar") ]
end
