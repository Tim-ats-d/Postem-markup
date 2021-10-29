let load_expansion expsn_name =
  let found_expsn =
    List.filter
      (fun (name, _) -> if name = expsn_name then true else false)
      Expansion.Known.expansions
  in
  match found_expsn with
  | [] ->
      Printf.eprintf
        {|Error: no extension found as "%s". Did you register your extension in src/expansion/known.ml ?|}
        expsn_name;
      exit 1
  | [ (_, expsn) ] -> expsn
  | _ ->
      Printf.eprintf
        {|Error: ambiguity found. Several extensions are known as "%s"|}
        expsn_name;
      exit 1
