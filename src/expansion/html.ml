open Utils
include Default

let format ?(class_ = "") ?(id = "") ~tag content =
  let class' = match class_ with "" -> "" | _ -> " class=" ^ class_
  and id' = match id with "" -> "" | _ -> " id=" ^ id in
  Printf.sprintf "<%s%s%s>%s</%s>" tag class' id' content tag

let concat = String.concat "\n"

module Tags : Ast.Expansion.Tags = struct
  include Default.Tags

  let conclusion content = format ~tag:"p" ~class_:"conclusion" content

  let definition name values =
    let content =
      Text.Lines.join_lines values |> Printf.sprintf "<b>%s</b>: %s" name
    in
    format ~tag:"p" ~class_:"definition" content

  let heading _ lvl content =
    let lvl_str = Int.to_string @@ Ast.Share.TitleLevel.to_int lvl in
    let tag = "h" ^ lvl_str
    and id = String.real_split ' ' content |> String.concat "-" in
    format ~tag ~id content

  let paragraph text = format ~tag:"p" text

  let quotation lines =
    let content = Text.Lines.join_lines lines in
    format ~tag:"blockquote" content
end

module Meta : Ast.Expansion.Meta = struct
  include Default.Meta

  let args = []
end
