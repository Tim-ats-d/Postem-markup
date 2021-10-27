type t = { ctx : Context.t; headers : (int * string) list }

let create ~ctx = { ctx; headers = ([] : (int * string) list) }
