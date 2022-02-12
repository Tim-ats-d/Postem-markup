%{
  open Parsed_ast

  let mk_loc startpos endpos value = { startpos; endpos; value }
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
  | n=NEWLINE; { LWhite n }

let expr :=
  | group
  | terminal
  | unary_op

let terminal ==
  | t=TEXT;     { LText t }
  | w=WHITE;    { LWhite w }
  | u=UNFORMAT; { LUnformat u }

let group ==
  | LBRACKET; grp=expr*; RBRACKET; { LGroup grp }

let unary_op ==
  | op=OP; t=TEXT;
    { let op_loc = mk_loc $startpos $endpos op in
      LUnaryOp { op = op_loc; group = LGroup [ LText t ] } }
  | op=OP; group=group;
    { let op_loc = mk_loc $startpos $endpos op in
      LUnaryOp { op = op_loc; group } }

let uop_line ==
  | op=OP; WHITE; grp=expr+; NEWLINE;
    { let op_loc = mk_loc $startpos $endpos op in
      LUnaryOp { op = op_loc; group = LGroup grp } }
  (* TODO Add newline *)

  // | WHITE; op=OP; WHITE; group=expr+; NEWLINE; { UnaryOp { op; group = Group group } } (* TODO Add newline *)
