type t = { current_line : string; line : int; column : int }

let initial () = { line = 0; column = 0; current_line = "TODO" }

let incr_col pos = { pos with column = succ pos.column }

let incr_line pos = { pos with line = pos.line + 1; column = 0 }
