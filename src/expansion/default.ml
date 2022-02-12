let alias = Common.Ctx.AliasCtx.(empty |> add "P" "Postem")

let underline ~char text =
  Printf.sprintf "%s\n%s\n" text @@ String.(make (length text)) char

let quote = Printf.sprintf " █ %s\n"
let conclusion = Printf.sprintf "-> %s\n"

let uop =
  let open Common.Ctx.UopCtx in
  empty
  |> add "&" @@ underline ~char:'#'
  |> add "&&" @@ underline ~char:'*'
  |> add "&&&" @@ underline ~char:'='
  |> add "&&&&" @@ underline ~char:'-'
  |> add "&&&&&" @@ underline ~char:'^'
  |> add "&&&&&&" @@ underline ~char:'"'
  |> add ">" quote |> add "%%" Fun.id |> add "--" conclusion
  (* |> add ">" quote
  |> add "--" conclusion *)
