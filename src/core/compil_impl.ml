module type PARSER = sig
  val parse : Sedlexing.lexbuf -> (Ast.Ast_types.doc, string) result
end

module type EVAL = sig
  type t

  val eval : Ast.Ast_types.doc -> (t, string) result
end

module type S = sig
  type t

  val from_lexbuf : ?filename:string -> Sedlexing.lexbuf -> (t, string) result
  val from_string : ?filename:string -> string -> (t, string) result
  val from_channel : ?filename:string -> in_channel -> (t, string) result
end

module Make (Parser : PARSER) (Eval : EVAL) : S with type t := Eval.t = struct
  let from_lexbuf ?(filename = "") lexbuf =
    Sedlexing.set_filename lexbuf filename;
    match Parser.parse lexbuf with
    | Ok ast -> Eval.eval ast
    | Error _ as err -> err

  let from_string ?(filename = "") str =
    let lexbuf = Sedlexing.Utf8.from_string str in
    from_lexbuf lexbuf ~filename

  let from_channel ?(filename = "") chan =
    let lexbuf = Sedlexing.Utf8.from_channel chan in
    from_lexbuf lexbuf ~filename
end
