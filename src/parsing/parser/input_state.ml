open Utils.String

type t = { lines : string array; position : Position.t }

let of_str str =
  let position = Position.initial () in
  if is_empty str then { lines = [||]; position }
  else
    let lines = String.split_on_char '\n' str |> Array.of_list in
    { lines; position }

let current_line { lines; position } =
  let line_pos = position.line in
  if line_pos < Array.length lines then Array.get lines line_pos else "EOF"

let next_char input =
  let { lines; position } = input in
  if position.line >= Array.length lines then (input, None)
  else
    let cline = current_line input in
    if position.column < String.length cline then
      let char = cline.[position.column] in
      let new_pos = Position.incr_col position in
      let new_state = { input with position = new_pos } in
      (new_state, Some char)
    else
      let new_pos = Position.incr_line position in
      let new_state = { input with position = new_pos } in
      (new_state, Some '\n')
