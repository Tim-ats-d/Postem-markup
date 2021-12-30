open Utils

module type Interpr = sig
  type t

  val eval : Ast.Ast_types.expr Ast.Ast_types.document -> t
end

module type S = sig
  type t

  val from_lexbuf : Lexing.lexbuf -> (t, string) result

  val from_string : string -> (t, string) result

  val from_file : string -> (t, string) result
end

module Make (Eval : Interpr) : S with type t := Eval.t = struct
  let from_lexbuf lexbuf =
    match Parsing.parse_document lexbuf with
    | Ok ast -> (
        try Ok (Eval.eval ast)
        with Ast.Eval.Missing_metamark ({ startpos; endpos }, name) ->
          let msg = Printf.sprintf "missing metamark '%s'" name
          and hint =
            "try to define your metamark in the used expansion and reinstall \
             Postem"
          and cursor_length = endpos.pos_cnum - endpos.pos_bol in
          Error (Error.of_position startpos ~msg ~hint ~cursor_length))
    | Error _ as err -> err

  let from_string str =
    let lexbuf = Lexing.from_string str in
    Lexing.set_filename lexbuf "REPL";
    from_lexbuf lexbuf

  let from_file filename =
    let lexbuf = Lexing.from_channel (open_in filename) in
    Lexing.set_filename lexbuf filename;
    from_lexbuf lexbuf
end
