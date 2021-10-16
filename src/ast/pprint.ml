open Ast_types
open Printf
open Utils

let rec pprint_document (Document d) =
  List.map pprint_expr d |> String.concat "\n"

and pprint_expr = function
  | Alias (name, value) -> sprintf "Alias:%s=%s" name value
  | Block b -> pprint_block b
  | Include i -> sprintf "Include:%s" i
  | Int i -> sprintf "Int:%d" i
  | Listing _ -> ""
  | Text t -> sprintf "Text:%s" t
  | Seq s -> List.map pprint_expr s |> String.concat ", " |> sprintf "Seq:%s"
  | Unformat u -> sprintf "Unformat:%s" u
  | White kind -> print_whitespace kind |> sprintf "Whitespace:%s"

and pprint_block = function
  | Conclusion c -> pprint_expr c |> sprintf "Conclusion:%s"
  | Definition (n, v) ->
      sprintf "Definition(%s, %s)" (pprint_expr n) (pprint_expr v)
  | Heading (lvl, h) -> sprintf "Heading(%i, %s)" lvl (pprint_expr h)
  | Quotation q -> pprint_expr q |> sprintf "Quotation:%s"

and print_whitespace = function
  | CarriageReturn -> {|\r|}
  | Newline -> {|\n|}
  | Tab -> {|\t|}
  | Space -> {|space|}
  | Unknown u -> Char.to_string u
