open Utils

module type S = sig
  val initial_alias : string Map.Make(Utils.String).t

  val concat_block : string list -> string

  val conclusion : string -> string

  val definition : string -> string list -> string

  val heading : int -> string -> string

  val quotation : string list -> string

  val listing : string list -> string

  val postprocess : Document.t -> string
end

module Default : S = struct
  let initial_alias =
    let module M = Map.Make (String) in
    M.empty

  let concat_block = String.concat "\n\n"

  let conclusion str = Printf.sprintf "\\-> %s" str

  let definition name values = name ^ String.concat_first "\n  | " values

  let heading level str =
    let underline =
      Array.get [| '#'; '*'; '='; '-'; '^'; '"' |] level
      |> String.(length str |> make)
    in
    Printf.sprintf "%s%s" str underline

  let quotation = String.concat_first "\n █ "

  let listing = String.concat_first "\n - "

  let postprocess { Document.content; _ } = content
end
