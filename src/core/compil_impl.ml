module type EVAL = sig
  type t

  val eval : Ast.Types.doc -> t
end

module type S = sig
  type t

  val from_lexbuf :
    ?filename:string -> Sedlexing.lexbuf -> (t, Common.Err.t) result

  val from_string : ?filename:string -> string -> (t, Common.Err.t) result
  val from_channel : ?filename:string -> in_channel -> (t, Common.Err.t) result
end

module Make (Parser : Parsing.S) (Eval : EVAL) : S with type t := Eval.t =
struct
  let from_lexbuf ?(filename = "") lexbuf =
    Sedlexing.set_filename lexbuf filename;
    Result.bind (Parser.parse lexbuf) (fun ast -> Ok (Eval.eval ast))

  let from_string ?(filename = "") str =
    let lexbuf = Sedlexing.Utf8.from_string str in
    from_lexbuf lexbuf ~filename

  let from_channel ?(filename = "") chan =
    let lexbuf = Sedlexing.Utf8.from_channel chan in
    from_lexbuf lexbuf ~filename
end
