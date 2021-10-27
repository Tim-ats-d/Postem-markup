open Utils

module S : Type.S = struct
  let initial_alias =
    let module M = Map.Make (String) in
    M.empty

  let concat_block = String.concat "\n\n"

  let conclusion str = Printf.sprintf "\\-> %s" str

  let definition name values = name ^ String.concat_first "\n  | " values

  let heading level str =
    let underline =
      let chars = [| '#'; '*'; '='; '-'; '^'; '"' |] in
      (if level > 6 then Array.get chars 5 else Array.get chars level)
      |> String.(length str |> make)
    in
    Printf.sprintf "%s\n%s" str underline

  let quotation = String.concat_first "\n █ "

  let listing = String.concat_first "\n - "

  let postprocess { Ext.Document.content; _ } = content
end
