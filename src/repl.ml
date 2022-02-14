module type S = sig
  val launch : unit -> unit
end

module Make (Compiler : Core.Compil_impl.S with type t := string) = struct
  let prompt () = print_string "> "
  let print = Printf.printf "- : %s\n"

  let rec launch () =
    prompt ();
    let input = ref [] in
    try
      while true do
        input := read_line () :: !input
      done
    with End_of_file -> (
      match
        List.rev !input |> String.concat "\n"
        |> Compiler.from_string ~filename:"REPL"
      with
      | Ok output -> print output; launch ()
      | Error err -> Common.(prerr_with_exit @@ Err.to_string err))
end
