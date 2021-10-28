open Utils

module S : Type.S = struct
  let initial_alias =
    let module M = Map.Make (String) in
    M.empty

  let concat = String.concat "\n\n"

  let conclusion text = Printf.sprintf {|\-> %s|} text

  let definition name values = name ^ String.concat_first "\n  | " values

  let heading lvl text =
    let get_char = Array.get [| '#'; '*'; '='; '-'; '^'; '"' |] in
    let underlining_char = if lvl >= 6 then get_char 5 else get_char lvl in
    let underlining = String.make (String.length text) underlining_char in
    Printf.sprintf "%s\n%s" text underlining

  let paragraph = Fun.id

  let quotation lines = String.join lines |> Printf.sprintf " █ %s"

  let listing = function
    | [] -> ""
    | [ x ] -> Printf.sprintf "  - %s" x
    | x :: xs ->
        let first = Printf.sprintf "  - %s" x
        and rest = String.concat_first "\n  - " xs in
        first ^ rest

  let postprocess { Ext.Postprocess.content; _ } = content
end
