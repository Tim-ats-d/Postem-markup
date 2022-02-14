module type S = sig
  val parse : Sedlexing.lexbuf -> (Parsed_ast.t, Common.Err.parser_err) result
end

module Parser = struct
  let parse lexbuf =
    let lexer = Sedlexing.with_tokenizer Lexer.read lexbuf in
    let parser =
      MenhirLib.Convert.Simplified.traditional2revised Parser.document
    in
    let open Result in
    try ok @@ parser lexer with
    | Lexer.IllegalChar lexbuf ->
        error @@ `IllegalCharacter (Sedlexing.lexing_positions lexbuf)
    | Parser.Error -> error @@ `SyntaxError (Sedlexing.lexing_positions lexbuf)
end

module Parsed_ast = Parsed_ast
