module KnownExpansions = struct
  type t = Expansion.Known.t

  let to_string t =
    List.map (fun (name, doc, _) -> Printf.sprintf "%s: %s" name doc) t
    |> String.concat "\n"
end

let load t name =
  let found_expsn = List.filter (fun (n, _, _) -> n = name) t in
  match found_expsn with
  | [] -> Error (`UnknownExpsn name)
  | [ (_, _, expsn) ] -> Ok expsn
  | _ -> Error (`ExpsnAmbiguity name)
