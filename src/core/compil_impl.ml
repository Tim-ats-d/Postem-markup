open Utils

module type EVAL = sig
  type t

  val eval : Ast.Ast_types.expr Ast.Ast_types.document -> t
end

module type S = sig
  type t

  val from_lexbuf : ?filename:string -> Lexing.lexbuf -> (t, string) result

  val from_string : ?filename:string -> string -> (t, string) result

  val from_channel : ?filename:string -> in_channel -> (t, string) result
end

module Make (Eval : EVAL) : S with type t := Eval.t = struct
  let from_lexbuf ?(filename = "") lexbuf =
    Lexing.set_filename lexbuf filename;
    match Parsing.parse_document lexbuf with
    | Ok ast -> (
        try Ok (Eval.eval ast)
        with Ast.Eval.Missing_metamark ({ startpos; endpos }, name) ->
          let msg = Printf.sprintf "missing metamark \"%s\"" name
          and hint =
            "try to define your metamark in the used expansion and reinstall \
             Postem."
          and cursor_length = endpos.pos_cnum - endpos.pos_bol in
          Error (Error.of_position startpos ~msg ~hint ~cursor_length))
    | Error _ as err -> err

  let from_string ?(filename = "") str =
    let lexbuf = Lexing.from_string str in
    from_lexbuf lexbuf ~filename

  let from_channel ?(filename = "") chan =
    let lexbuf = Lexing.from_channel chan in
    from_lexbuf lexbuf ~filename
end
