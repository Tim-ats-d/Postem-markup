type t = string

let prefix = Printf.sprintf "%s%s"
let suffix s str = Printf.sprintf "%s%s" str s
let between = Printf.sprintf "%s%s%s"

module Lines = struct
  type t = string list

  let concat = String.concat
  let concat_fst sep = function [] -> "" | l -> sep ^ String.concat sep l
  let concat_lines = String.concat "\n"
  let join = String.concat ""
  let join_lines = String.concat "\n"
  let prefix str = List.map (prefix str)
  let suffix str = List.map (fun line -> suffix line str)
end
