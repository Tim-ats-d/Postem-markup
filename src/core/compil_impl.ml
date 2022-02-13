module type S = sig
  type t

  val from_lexbuf :
    ?filename:string -> Sedlexing.lexbuf -> (t, Common.Err.t) result

  val from_string : ?filename:string -> string -> (t, Common.Err.t) result
  val from_channel : ?filename:string -> in_channel -> (t, Common.Err.t) result
end

module Make (Parser : Syntax.S) (Checker : Checker.S) (Eval : Ast.Eval.S) :
  S with type t := Eval.t = struct
  let from_lexbuf ?(filename = "") lexbuf =
    Sedlexing.set_filename lexbuf filename;
    let open Common.Result in
    match Parser.parse lexbuf with
    | Ok parsed_ast -> (
        match Checker.pass parsed_ast with
        | Ok ast -> ok @@ Eval.eval ast
        | Error err -> Error (err :> Common.Err.t))
    | Error err -> Error (err :> Common.Err.t)

  let from_string ?(filename = "") str =
    let lexbuf = Sedlexing.Utf8.from_string str in
    from_lexbuf lexbuf ~filename

  let from_channel ?(filename = "") chan =
    let lexbuf = Sedlexing.Utf8.from_channel chan in
    from_lexbuf lexbuf ~filename
end
