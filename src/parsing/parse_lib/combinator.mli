type 'a parser_result = Sucess of 'a | Failure of label * error * Position.t

and label = string

and error = string

type 'a parser

val set_label : 'a parser -> error -> 'a parser

val ( <?> ) : 'a parser -> string -> 'a parser

val get_label : 'a parser -> error

val position_of_input_state : Input_state.t -> Position.t

val satisfy : (char -> bool) -> error -> char parser

val pchar : char -> char parser

val run_on_input :
  'a parser -> Input_state.t -> ('a * Input_state.t) parser_result

val run : 'a parser -> error -> ('a * Input_state.t) parser_result

val bind : ('a -> 'b parser) -> 'a parser -> 'b parser

val ( >>= ) : 'a parser -> ('a -> 'b parser) -> 'b parser

val return : 'a -> 'a parser

val map : ('a -> 'b) -> 'a parser -> 'b parser

val apply : ('a -> 'b) parser -> 'a parser -> 'b parser

val lift2 : ('a -> 'b -> 'c) -> 'a parser -> 'b parser -> 'c parser

val and_then : 'a parser -> 'b parser -> ('a * 'b) parser

val ( <&> ) : 'a parser -> 'b parser -> ('a * 'b) parser

val or_else : 'a parser -> 'a parser -> 'a parser

val ( <|> ) : 'a parser -> 'a parser -> 'a parser

val choice : char parser list -> char parser

val any_of : char list -> char parser

val sequence : 'a parser list -> 'a list parser

val parse_zero_or_more : 'a parser -> Input_state.t -> 'a list * Input_state.t

val many : 'a parser -> 'a list parser

val many_one : 'a parser -> 'a list parser

val opt : 'a parser -> 'a option parser

val throw_right : 'a parser -> 'b parser -> 'a parser

val throw_left : 'a parser -> 'b parser -> 'b parser

val between : 'a parser -> 'b parser -> 'c parser -> 'b parser

val sep_by_one : 'a parser -> 'b parser -> 'a list parser

val sep_by : 'a parser -> 'b parser -> 'a list parser

val pstring : error -> error parser

val read_all_chars : Input_state.t -> char list
