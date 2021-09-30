open Parse_lib.Combinator

val whitespaces : char list parser

val alpha : char parser

val alpha_one : char list parser

val many_space : char list list parser

val opt_sign : char option parser

val digit : char parser

val text : char list parser
