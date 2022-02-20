module IntEval = struct
  type t = int

  let rec eval doc = List.fold_left eval_expr 0 doc

  and eval_expr acc expr =
    match expr with
    | Ast.Types.Text t -> ( acc + try int_of_string t with Failure _ -> 0)
    | _ -> acc
end

module MyCompiler =
  Core.Compil_impl.Make (Syntax.Parser) (Checker.Make (Expansion.Default))
    (IntEval)

let () =
  match MyCompiler.from_string "hello 10 world" with
  | Ok n -> Printf.printf "%d\n" n
  | Error err -> prerr_endline @@ Common.Err.to_string err
