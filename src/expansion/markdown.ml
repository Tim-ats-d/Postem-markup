open Utils
include Default

module Tags : Ast.Expansion.Tags = struct
  include Default.Tags

  let definition name values =
    Text.Lines.concat_fst "\n  " values |> Printf.sprintf "**%s**:%s" name

  let heading _ lvl text =
    let lvli = Ast.Share.TitleLevel.to_int lvl in
    let mark = String.make lvli '#' in
    Printf.sprintf "%s %s" mark text

  let quotation = Text.Lines.concat_fst "> "
end
