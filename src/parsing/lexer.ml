open Parser
module Sedlex = Sedlexing.Utf8

let strip ~left ?(right = 0) str =
  String.sub str left (String.length str - right - left)

exception Syntax_error of Sedlexing.lexbuf

let fail lexbuf = raise (Syntax_error lexbuf)

module LexCtx = struct
  type t = { mutable line : int; mutable parse_alias : bool }

  let create () = { line = 0; parse_alias = false }

  let initial = create ()
end

let lexeme = Sedlex.lexeme

let letter = [%sedlex.regexp? lu | ll | lt | lm | lo]

let mark = [%sedlex.regexp? mn | mc | me]

let number = [%sedlex.regexp? nd | nl | no]

let punctuation = [%sedlex.regexp? pc | pd | ps | pe | pi | pf | po]

let symbol = [%sedlex.regexp? sm | sc | sk | so]

let text_uchar = [%sedlex.regexp? letter | mark | number | punctuation | symbol]

let space_uchar = [%sedlex.regexp? zs]

let newline = [%sedlex.regexp? "\r\n" | "\n"]

let sep = [%sedlex.regexp? Rep (newline, 2)]

let ws = [%sedlex.regexp? Plus zs]

let text = [%sedlex.regexp? Plus text_uchar]

let assignment = [%sedlex.regexp? Opt ws, "==", Opt ws]

let metasingle = [%sedlex.regexp? '@', text]

let string = [%sedlex.regexp? '"', Star any, '"']

let unformat = [%sedlex.regexp? "{{", Star any, "}}"]

let conclusion = [%sedlex.regexp? "--", Opt ws]

let definition = [%sedlex.regexp? Opt ws, "%%", Opt ws]

let heading = [%sedlex.regexp? Plus '&', Opt ws]

let quotation = [%sedlex.regexp? '>', Opt ws]

let meta_args =
  [%sedlex.regexp? "..", Plus (letter | number), (newline | space_uchar)]

let rec token lexbuf ctx =
  let lexeme = Sedlex.lexeme in
  match%sedlex lexbuf with
  | eof -> EOF
  | sep -> SEPARATOR
  | newline ->
      Sedlexing.new_line lexbuf;
      print_endline "LINE";
      WHITESPACE "\n"
  | assignment ->
      ctx.LexCtx.parse_alias <- true;
      ASSIGNMENT
  | metasingle -> METASINGLE (strip ~left:1 @@ lexeme lexbuf)
  | meta_args ->
      let name = lexeme lexbuf |> strip ~left:2 |> String.trim in
      METAARGS (name, read_meta_value lexbuf)
  | string ->
      if ctx.LexCtx.parse_alias then (
        ctx.LexCtx.parse_alias <- false;
        STRING (strip ~left:1 ~right:1 @@ lexeme lexbuf))
      else TEXT (lexeme lexbuf)
  | unformat -> UNFORMAT (strip ~left:2 ~right:2 @@ lexeme lexbuf)
  | conclusion -> CONCLUSION
  | definition -> DEFINITION
  | heading ->
      let h = ref 0 in
      String.iter (fun c -> if c = '&' then incr h) (lexeme lexbuf);
      HEADING !h
  | quotation -> QUOTATION
  | ws -> WHITESPACE (lexeme lexbuf)
  | text -> TEXT (lexeme lexbuf)
  | _ ->
      print_endline (lexeme lexbuf);
      fail lexbuf

and read_meta_value lexbuf =
  let rec aux buf =
    match%sedlex lexbuf with
    | ".." ->
        let c = Buffer.contents buf in
        Buffer.clear buf;
        c
    | newline ->
        Sedlexing.new_line lexbuf;
        Buffer.add_string buf (lexeme lexbuf);
        aux buf
    | any ->
        Buffer.add_string buf (lexeme lexbuf);
        aux buf
    | _ -> fail lexbuf
  in
  aux (Buffer.create 17)

let read lexbuf = token lexbuf LexCtx.initial

let of_string =
  let open Printf in
  function
  | WHITESPACE w -> sprintf "Whitespace:%s" w
  | UNFORMAT u -> sprintf "Unformat:%s" u
  | TEXT t -> sprintf "Text:%s" t
  | STRING s -> sprintf "String:%s" s
  | SEPARATOR -> "Separator"
  | QUOTATION -> "Quotation"
  | METASINGLE s -> sprintf "Metasingle:%s" s
  | METAARGS (name, value) -> sprintf "Metaargs:%s | %s" name value
  | HEADING h -> sprintf "Heading: level %i" h
  | EOF -> "EOF"
  | DEFINITION -> "Definition"
  | CONCLUSION -> "Conclusion"
  | ASSIGNMENT -> "Assignment"

let read_debug lexbuf =
  let token = read lexbuf in
  print_endline (of_string token);
  token
