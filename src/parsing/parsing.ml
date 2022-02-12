open Common

module type S = sig
  val parse : Sedlexing.lexbuf -> (Ast.Types.expr list, Err.t) result
end

module Make (Expsn : Ast.Expansion.S) : S = struct
  let parse lexbuf =
    let lexer = Sedlexing.with_tokenizer Lexer.read lexbuf in
    let parser =
      MenhirLib.Convert.Simplified.traditional2revised Parser.document
    in
    try
      let parsed_ast = parser lexer in
      let module Pprocess = Postprocess.Make (Expsn) in
      Pprocess.postprocess parsed_ast
    with
    | Lexer.Syntax_error lexbuf ->
        let _, pos = Sedlexing.lexing_positions lexbuf in
        let msg =
          Err.pp_position pos ~msg:"character not allowed in source text"
            ~hint:"try to escape this character."
        in
        Error (`IllegalCharacter msg)
    | Parser.Error ->
        let msg = Err.pp_lexbuf lexbuf ~msg:"syntax error" in
        Error (`SyntaxError msg)
end
