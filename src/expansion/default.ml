let alias = Common.Ctx.AliasCtx.(empty |> add "P" "Postem")

let fmt_title ~nbring ~fmt ~chr text =
  nbring#next;
  let ftext = fmt nbring#get text in
  Printf.sprintf "%s\n%s" ftext @@ String.(make (length ftext)) chr

let underline ~char text =
  Printf.sprintf "%s\n%s" text @@ String.(make (length text)) char

let quote = Printf.sprintf " █ %s"
let conclusion = Printf.sprintf "-> %s"

let bop =
  let open Common.Ctx.BinOpCtx in
  empty
  |> add ">>" @@ fun qtation author ->
     Printf.sprintf "%s\n  %s" (quote qtation) author

let uop =
  let module Enum = Enumerate.Builtins in
  let open Common.Ctx.UopCtx in
  empty
  |> add "&"
     @@ fmt_title
          ~nbring:(new Enum.upper_case_numeric_roman)
          ~fmt:(Printf.sprintf "%s - %s") ~chr:'#'
  |> add "&&"
     @@ fmt_title
          ~nbring:(new Enum.upper_case_latin)
          ~fmt:(Printf.sprintf "%s) %s") ~chr:'*'
  |> add "&&&"
     @@ fmt_title
          ~nbring:(new Enum.lower_case_greek)
          ~fmt:(Printf.sprintf "%s. %s") ~chr:'='
  |> add "&&&&" @@ underline ~char:'-'
  |> add "&&&&&" @@ underline ~char:'^'
  |> add "&&&&&&" @@ underline ~char:'"'
  |> add ">" quote |> add "%%" Fun.id |> add "--" conclusion
(* |> add ">" quote
   |> add "--" conclusion *)
