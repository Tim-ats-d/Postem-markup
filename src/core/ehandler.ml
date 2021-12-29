module KnownExpansions = struct
  type t = (name * doc * (module Ast.Expansion.S)) list

  and name = string

  and doc = string
end

exception UnknownExpsn of string * string

exception ExpsnAmbiguity of string * string

let unknown_expsn ~msg ~hint = raise @@ UnknownExpsn (msg, hint)

let expsn_ambiguity ~msg ~hint = raise @@ ExpsnAmbiguity (msg, hint)

let load_exn t name =
  let found_expsn = List.filter (fun (n, _, _) -> n = name) t in
  match found_expsn with
  | [] ->
      unknown_expsn
        ~msg:(Printf.sprintf {|no extension found as "%s"|} name)
        ~hint:"Did you register your extension in src/expansion/known.ml ?"
  | [ (_, _, expsn) ] -> expsn
  | _ ->
      expsn_ambiguity ~msg:"ambiguity found"
        ~hint:(Printf.sprintf {|Several extensions are known as "%s"|} name)

let load_res t name =
  let found_expsn = List.filter (fun (n, _, _) -> n = name) t in
  match found_expsn with
  | [] ->
      let msg = Printf.sprintf {|no extension found as "%s"|} name in
      let hint = "Did you register your extension in src/expansion/known.ml?" in
      Error (msg, hint)
  | [ (_, _, expsn) ] -> Ok expsn
  | _ ->
      let msg = "ambiguity found" in
      let hint = Printf.sprintf {|Several extensions are known as "%s"|} name in
      Error (msg, hint)

let to_string t =
  List.map (fun (name, doc, _) -> Printf.sprintf "%s: %s" name doc) t
  |> String.concat "\n"
