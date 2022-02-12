open Common

module type S = sig
  val parse : Sedlexing.lexbuf -> (Parsed_ast.t, Common.Err.t) result
end

module Parser = struct
  let parse lexbuf =
    let lexer = Sedlexing.with_tokenizer Lexer.read lexbuf in
    let parser =
      MenhirLib.Convert.Simplified.traditional2revised Parser.document
    in
    try Ok (parser lexer) with
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

module Parsed_ast = Parsed_ast
