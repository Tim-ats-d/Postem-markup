%{
  open Ast.Ast_types
%}

%token <string> NEWLINE
%token <string> STRING
%token <string> TEXT
%token <string> WHITE

%token <char> UOP_WORD
%token <string> UOP_LINE

%token EQ

%token EOF

%type <Ast.Ast_types.doc> document
%start document

%%

let document :=
  | lines=stmt*; EOF; { lines }

let stmt :=
  | expr
  | n=NEWLINE; { White n }
  | op=UOP_LINE; line=expr+; NEWLINE; { OpLine { op; line } }

let expr :=
  | terminal
  | alias
  | unary_op

let alias ==
  | name=TEXT; EQ; value=STRING; { AliasDef { name; value } }

let unary_op ==
  | op=UOP_WORD; word=TEXT; { OpWord { op; word } }

let terminal ==
  | t=TEXT;  { Text t }
  | w=WHITE; { White w }
