open Utils
include Default

let numbering _ = new Enumerate.Builtins.null

module Tags : Ast.Expansion.Tags = struct
  include Default.Tags

  let definition name values =
    Printf.sprintf "%s::\n%s" name (Text.Lines.concat_lines values)

  let heading _ lvl text =
    let ilvl = Ast.Share.TitleLevel.to_int lvl in
    let prefix = String.make ilvl '=' in
    Printf.sprintf "%s %s" prefix text

  let quotation lines =
    Printf.sprintf "---\n%s\n---" @@ Text.Lines.concat_lines lines
end

let enumerate lines =
  List.map
    (fun line ->
      if String.is_empty line then String.empty else Printf.sprintf ". %s" line)
    lines
  |> Text.Lines.concat_lines

module Meta : Ast.Expansion.Meta = struct
  let args = []

  let single = []
end
