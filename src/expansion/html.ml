open Utils
include Default

let format ?(class_ = "") ?(id = "") ~tag content =
  let class' = match class_ with "" -> "" | _ -> " class=" ^ class_
  and id' = match id with "" -> "" | _ -> " id=" ^ id in
  Printf.sprintf "<%s%s%s>%s</%s>" tag class' id' content tag

let concat = String.concat "\n"

module Tags : Type.Tags = struct
  include Default.Tags

  let conclusion content = format ~tag:"p" ~class_:"conclusion" content

  let definition name values =
    let content =
      String.concat_lines values |> Printf.sprintf "<b>%s</b>: %s" name
    in
    format ~tag:"p" ~class_:"definition" content

  let heading lvl content =
    let lvl_str = (if lvl >= 6 then 6 else lvl) |> string_of_int in
    let tag = "h" ^ lvl_str
    and id = String.real_split ' ' content |> String.concat "-" in
    format ~tag ~id content

  let paragraph text = format ~tag:"p" text

  let quotation lines =
    let content = String.concat "\n" lines in
    format ~tag:"blockquote" content

  let listing lines =
    let content =
      List.map (fun line : string -> format ~tag:"li" line) lines
      |> String.concat_lines
    in
    format ~tag:"ul" content
end

module Meta : Type.Meta = struct
  include Default.Meta

  let args = []
end
