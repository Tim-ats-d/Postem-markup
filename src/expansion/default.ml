open Utils

module S : Type.S = struct
  let initial_alias =
    let module M = Map.Make (String) in
    M.empty

  let concat_block = String.concat "\n\n"

  let conclusion text = Printf.sprintf {|\-> %s|} text

  let definition name values = name ^ String.concat_first "\n  | " values

  let heading lvl text =
    let get_char = Array.get [| '#'; '*'; '='; '-'; '^'; '"' |] in
    let underlining_char = if lvl > 6 then get_char 5 else get_char lvl in
    let underlining = String.make (String.length text) underlining_char in
    Printf.sprintf "%s\n%s" text underlining

  let quotation = String.concat_first "\n █ "

  let listing = String.concat_first "\n - "

  let postprocess { Ext.Document.content; _ } = content
end
