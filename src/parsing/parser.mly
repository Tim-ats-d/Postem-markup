%{
  open Ast.Ast_types
%}

%token <string> TEXT
%token <int> INT

%token CARRIAGERETURN NEWLINE TAB SPACE

%token SEPARATOR
%token EOF

%token ASSIGNMENT
%token <string> STRING

%token <string> INCLUDE
%token <string> UNFORMAT

%token CONCLUSION DEFINITION QUOTATION
%token <int> HEADING

%start document

%type <document> document

%type <expr> expr

%%

document: blist=separated_list(SEPARATOR, block_list); EOF { Document blist }

block_list:
  | bl=conclusion | bl=definition | bl=heading | bl=quotation { Block bl }
  | p=paragraph { p }

conclusion: CONCLUSION; p=paragraph { Conclusion p }

definition: n=paragraph; DEFINITION; v=paragraph { Definition (n, v) }

heading: h=HEADING; p=paragraph { Heading (h, p) }

quotation: QUOTATION; p=paragraph { Quotation p}

paragraph: elist=expr+ { Seq elist }

expr:
  | n=TEXT; ASSIGNMENT; v=STRING { Alias (n, v) }
  | i=INCLUDE                    { Include i }
  | i=INT                        { Int i }
  | t=TEXT                       { Text t }
  | u=UNFORMAT                   { Unformat u }
  | w=whitespace                 { White w }

whitespace:
  | CARRIAGERETURN { CarriageReturn }
  | NEWLINE        { Newline }
  | TAB            { Tab }
  | SPACE          { Space }
