open Utils
include Default

let rec meta =
  [ ("enumerate", `Lines enumerate); ("read", `Inline File.read_all) ]

and enumerate lines =
  List.map
    (fun line ->
      if String.is_empty line then String.empty else Printf.sprintf ". %s" line)
    lines
  |> String.concat_lines

module Tags : Type.Tags = struct
  include Default.Tags

  let definition name values =
    Printf.sprintf "%s::\n%s" name (String.concat_lines values)

  let heading lvl text =
    let lvl = if lvl >= 6 then 6 else lvl in
    Printf.sprintf "%s %s" (String.make lvl '=') text

  let quotation lines =
    Printf.sprintf "---\n%s\n---" (String.concat_lines lines)

  let listing lines =
    List.map (Printf.sprintf "* %s") lines |> String.concat_lines
end
