let known_expsn = Expansion.Known.expansions

let load expsn_name =
  let found_expsn =
    List.filter (fun (name, _, _) -> name = expsn_name) known_expsn
  in
  match found_expsn with
  | [] ->
      Printf.eprintf
        {|Error: no extension found as %s. Did you register your extension in src/expansion/known.ml ?|}
        expsn_name;
      exit 1
  | [ (_, _, expsn) ] -> expsn
  | _ ->
      Printf.eprintf
        {|Error: ambiguity found. Several extensions are known as "%s"|}
        expsn_name;
      exit 1

let print () =
  List.iter
    (fun (name, doc, _) -> Printf.printf "%s: %s\n" name doc)
    known_expsn
