%{
  open Parsed_ast

  let mk_loc loc value = { loc; value }
%}

%token <string> OP
%token <string> NEWLINE
%token <string> TEXT
%token <string> WHITE
%token <string> UNFORMAT

%token LBRACKET RBRACKET
%token EOF

%type <Parsed_ast.t> document
%start document

%%

let document :=
  | lines=line*; EOF; { lines }

let line :=
  | expr
  | uop_line
  | n=NEWLINE; { LNewline n }

let expr :=
  | group
  | terminal
  | op_app

let terminal ==
  | t=TEXT;     { LText t }
  | w=WHITE;    { LWhite w }
  | u=UNFORMAT; { LUnformat u }

let group ==
  | LBRACKET; grp=group_aux*; RBRACKET; { LGroup grp }

let group_aux ==
  | expr
  | n=NEWLINE; { LNewline n }

let op_app ==
  | unary_op

let unary_op ==
  | op=OP; t=TEXT;
    { LUnaryOp { op = mk_loc $loc(op) op; group = LGroup [ LText t ]; newline = "" } }
  | op=OP; group=group;
    { LUnaryOp { op = mk_loc $loc(op) op; group; newline = "" } }

let uop_line ==
  | op=OP; WHITE; grp=expr+; newline=NEWLINE;
    { LUnaryOp { op = mk_loc $loc(op) op; group = LGroup grp; newline } }
