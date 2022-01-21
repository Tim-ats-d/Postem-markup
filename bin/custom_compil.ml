open Ast.Ast_types

module IntEval = Ast.Eval_impl.Make (struct
  type t = int

  let rec eval _meta doc = List.map eval_elem doc

  and eval_elem = function
    | Block b -> eval_block b
    | Paragraph p -> eval_vlist p

  and eval_vlist vlist = List.map eval_value vlist |> List.fold_left Int.add 0

  and eval_value = function
    | `MetaArgsCall _ -> 0
    | `MetaSingleCall _ -> 0
    | `Text t -> ( try int_of_string t with Failure _ -> 0)
    | `Whitespace _ -> 0

  and eval_block = function
    | Conclusion c -> eval_vlist c
    | Definition (name, values) ->
        let name' = eval_vlist name and values' = eval_vlist values in
        name' + values'
    | Heading (_lvl, h) -> eval_vlist h
    | Quotation q -> eval_vlist q
end)


module MyCompiler =
  Core.Compil_impl.Make
    (Core.Compiler.Parser)
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
