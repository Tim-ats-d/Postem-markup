open Utils

module S : Type.S = struct
  include Default.S

  let definition name values =
    String.concat_first "\n  " values |> Printf.sprintf "**%s**:%s" name

  let heading lvl text =
    let mark = if lvl > 6 then String.make 6 '#' else String.make lvl '#' in
    Printf.sprintf "%s %s" mark text

  let quotation = String.concat_first "> "
end
