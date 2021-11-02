let launch eval =
  let input = ref [] in
  try
    while true do
      input := read_line () :: !input
    done
  with End_of_file -> (
    print_newline ();
    match List.rev !input |> String.concat "\n" |> eval with
    | Ok output ->
        print_endline output;
        exit 0
    | Error msg ->
        prerr_endline msg;
        exit 1)
