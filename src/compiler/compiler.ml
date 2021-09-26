open Parsing

let compile document =
  match Parser.parse document with
  | Ok ast ->
      let global = Ast.Context.create () in
      Ast.Eval.eval global ast |> print_endline
  | Error err -> prerr_endline err
