open Utils

let initial_alias =
  let module M = Map.Make (String) in
  M.empty

let concat = Text.Lines.concat "\n\n"

let postprocess = Fun.id

module Tags : Type.Tags = struct
  let conclusion text = Text.prefix {|\-> |} text

  let definition name values = name ^ Text.Lines.concat_fst "\n  | " values

  let heading lvl text =
    let get_char = Array.get [| '#'; '*'; '='; '-'; '^'; '"' |] in
    let underlining_char = if lvl >= 6 then get_char 5 else get_char lvl in
    let underlining = String.make (String.length text) underlining_char in
    Text.between text "\n" underlining

  let paragraph = Fun.id

  let quotation lines = Text.prefix " █ " (Text.Lines.join lines)

  let listing = function
    | [] -> String.empty
    | [ x ] -> Text.prefix "  - " x
    | x :: xs ->
        let first = Text.prefix "  - " x
        and rest = Text.Lines.concat_fst "\n  - " xs in
        first ^ rest
end

let enumerate lines =
  List.mapi
    (fun i line ->
      if String.is_empty line then String.empty
      else Printf.sprintf "%i. %s" (succ i) line)
    lines
  |> Text.Lines.join_lines

let read filename =
  if Sys.file_exists filename then File.read_all filename
  else raise (Sys_error "in read meta mark: no such file or directory")

module Meta : Type.Meta = struct
  let args = [ ("enumerate", `Lines enumerate); ("read", `Inline read) ]

  let single = [ ("foo", fun () -> "bar") ]
end
