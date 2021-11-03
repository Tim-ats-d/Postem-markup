open Utils

let initial_alias =
  let module M = Map.Make (String) in
  M.empty

let rec meta =
  [ ("enumerate", `Lines enumerate); ("read", `Inline File.read_all) ]

and enumerate lines =
  List.mapi
    (fun i line ->
      if String.is_empty line then String.empty
      else Printf.sprintf "%i. %s" (succ i) line)
    lines
  |> String.concat_lines

module Tags : Type.Tags = struct
  let conclusion text = {|\-> |} ^ text

  let definition name values = name ^ String.concat_first "\n  | " values

  let heading lvl text =
    let get_char = Array.get [| '#'; '*'; '='; '-'; '^'; '"' |] in
    let underlining_char = if lvl >= 6 then get_char 5 else get_char lvl in
    let underlining = String.make (String.length text) underlining_char in
    Printf.sprintf "%s\n%s" text underlining

  let paragraph = Fun.id

  let quotation lines = String.join lines |> Printf.sprintf " █ %s"

  let listing = function
    | [] -> String.empty
    | [ x ] -> "  - %s" ^ x
    | x :: xs ->
        let first = Printf.sprintf "  - %s" x
        and rest = String.concat_first "\n  - " xs in
        first ^ rest
end

module Misc : Type.Misc = struct
  let concat = String.concat "\n\n"

  let postprocess { Ext.Statistic.content; _ } = content
end
