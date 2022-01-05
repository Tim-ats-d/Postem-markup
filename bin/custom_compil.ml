open Ast.Ast_types

module IntEval = Ast.Eval_impl.Make (struct
  type t = int

  let rec eval _meta (doc : value document) = List.map eval_elem doc

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

module Parser = struct
  let parse lexbuf =
    let open Parsing in
    try Ok (Parser.document Lexer.read lexbuf) with
    | Lexer.Syntax_error { lex_curr_p; _ } ->
        Result.error
        @@ Utils.Error.of_position lex_curr_p
             ~msg:"character not allowed in source text"
             ~hint:"non-ascii characters must be placed in a unformat block."
    | Parser.Error -> Result.error @@ Utils.Error.of_lexbuf lexbuf ~msg:"syntax error"
end

module MyCompiler =
  Core.Compil_impl.Make
    (Parser)
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
