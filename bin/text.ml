open Ast.Ast_types

module RichText = struct
  type t = Empty | Normal of string | Bold of string

  let to_string = function
    | Empty -> ""
    | Normal n -> n
    | Bold b -> Printf.sprintf "\\e[1m%s\\e[0m" b

  let of_tlist tlist = Normal (List.map to_string tlist |> String.concat "")
end

module PostemToRichText = Ast.Eval_impl.Make (struct
  open RichText

  type t = RichText.t

  let rec eval _metadata doc = List.map (eval_expr _metadata) doc

  and eval_expr _meta = function
    | Alias _ -> Empty
    | Block _ -> Empty
    | Listing _ -> Empty
    | MetamarkArgs _ -> Empty
    | MetamarkSingle _ -> Empty
    | Text t -> Bold t
    | Seq _ -> Empty
    | Unformat _ -> Empty
    | Whitespace w -> Normal w
end)

let () =
  match
    Parsing.parse_document (Lexing.from_channel (open_in "bin/doc.post"))
  with
  | Ok ast ->
      List.iter
        (fun text -> print_endline @@ RichText.to_string text)
        (PostemToRichText.eval ast)
  | Error err -> print_endline err
