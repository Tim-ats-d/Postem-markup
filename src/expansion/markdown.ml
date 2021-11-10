open Utils
include Default

module Tags : Type.Tags = struct
  include Default.Tags

  let definition name values =
    Text.Lines.concat_fst "\n  " values |> Printf.sprintf "**%s**:%s" name

  let heading lvl text =
    let mark = if lvl > 6 then String.make 6 '#' else String.make lvl '#' in
    Printf.sprintf "%s %s" mark text

  let quotation = Text.Lines.concat_fst "> "
end
