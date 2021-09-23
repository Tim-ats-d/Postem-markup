%{
  [@@@coverage exclude_file]
  open Ast.Ast_types
%}

%token <string> STRING
%token <int> INT

%token SEPARATOR
%token EOF

%start prog

%type <program> prog
%%
prog:
  | EOF                                 { Prog [] }
  | e = list(expr) { Prog e }
;

expr:
  | s = STRING { String s }
;
