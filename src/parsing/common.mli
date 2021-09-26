val whitespaces : char list Parse_lib.Combinator.parser

val alpha : char Parse_lib.Combinator.parser

val alpha_one : char list Parse_lib.Combinator.parser

val many_space : char list list Parse_lib.Combinator.parser

val opt_sign : char option Parse_lib.Combinator.parser

val digit : char Parse_lib.Combinator.parser
