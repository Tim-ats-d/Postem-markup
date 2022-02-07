open Ast.Ast_types

module IntEval = Ast.Eval_impl.Make (struct
  type t = int

  let rec eval _meta doc = List.map eval_expr doc

  and eval_expr = function
    | Text t -> ( try int_of_string t with Failure _ -> 0)
    | _ -> 0
end)

module MyCompiler =
  Core.Compil_impl.Make
    (Postem__Compiler.Parser)
    (struct
      type t = int list

      let eval = IntEval.eval ~alias:Ast.Share.AliasMap.empty
    end)

let count_int str =
  match MyCompiler.from_string str with
  | Ok i -> List.fold_left Int.add 0 i
  | Error err ->
      prerr_endline err;
      exit 1

let pgrm = {|
&& One number: 20

> Number quotation 10

30|}

let () =
  print_int @@ count_int pgrm;
  print_newline ()
