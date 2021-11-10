open Utils
include Default

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

let enumerate lines =
  List.map
    (fun line ->
      if String.is_empty line then String.empty else Printf.sprintf ". %s" line)
    lines
  |> String.concat_lines

module Meta : Type.Meta = struct
  let args =
    [ ("enumerate", `Lines enumerate); ("read", `Inline File.read_all) ]

  let single = []
end
