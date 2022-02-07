%{
  open Ast.Ast_types
%}

%token <string> NEWLINE
%token <string> STRING
%token <string> TEXT
%token <string> WHITE

%token <char> UOP_WORD
%token <char> UOP_LINE

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
  | uop=UOP_LINE; line=expr+; NEWLINE; { UnaryOpLine { uop; line } }

let expr :=
  | terminal
  | alias
  | unary_op

let alias ==
  | name=TEXT; EQ; value=STRING; { AliasDef { name; value } }

let unary_op ==
  | op=UOP_WORD; word=TEXT; { UnaryOpWord { op; word } }

let terminal ==
  | t=TEXT;  { Text t }
  | w=WHITE; { White w }
