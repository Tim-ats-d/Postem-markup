%{
  open Ast.Ast_types
%}

%token <string> OP
%token <string> NEWLINE
%token <string> TEXT
%token <string> WHITE
%token <string> UNFORMAT

%token LBRACKET RBRACKET
%token EOF

%type <Ast.Ast_types.doc> document
%start document

%%

let document :=
  | lines=line*; EOF; { lines }

let line :=
  | expr
  | uop_line
  | n=NEWLINE; { White n }

let expr :=
  | group
  | terminal
  | unary_op

let terminal ==
  | t=TEXT;     { Text t }
  | w=WHITE;    { White w }
  | u=UNFORMAT; { Unformat u }

let group ==
  | LBRACKET; g=expr*; RBRACKET; { Group g }

let unary_op ==
  | op=OP; t=TEXT;      { UnaryOp { op; group = Group [ Text t ] } }
  | op=OP; group=group; { UnaryOp { op; group } }

let uop_line ==
  | op=OP; WHITE; group=expr+; NEWLINE; { UnaryOp { op; group = Group group } } (* TODO Add newline *)
  // | WHITE; op=OP; WHITE; group=expr+; NEWLINE; { UnaryOp { op; group = Group group } } (* TODO Add newline *)
