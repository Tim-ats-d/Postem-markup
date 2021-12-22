%{
  open Ast.Ast_types
%}

%token <string> TEXT
%token <string> WHITESPACE

%token SEPARATOR EOF

%token ASSIGNMENT
%token <string> STRING

%token <string * string> METAARGS
%token <string> METASINGLE
%token <string> UNFORMAT

%token CONCLUSION DEFINITION QUOTATION
%token <int> HEADING

%start document

%type <document> document

%%

document: blist=separated_list(SEPARATOR, block_list); EOF { blist }

block_list:
  | bl=conclusion | bl=definition | bl=heading | bl=quotation { Block bl }
  | p=paragraph { p }

conclusion: CONCLUSION; p=paragraph { Conclusion p }

definition: n=paragraph; DEFINITION; v=paragraph { Definition (n, v) }

heading: h=HEADING; p=paragraph { Heading (h, p) }

quotation: QUOTATION; p=paragraph { Quotation p }

paragraph: elist=expr+ { Seq elist }

expr:
  | n=TEXT; ASSIGNMENT; v=STRING { Alias (n, v) }
  | m=METAARGS                   { let name, text = m in
                                   MetamarkArgs (create_loc $startpos $endpos, name, text) }
  | m=METASINGLE                 { MetamarkSingle (create_loc $startpos $endpos, m) }
  | t=TEXT                       { Text t }
  | u=UNFORMAT                   { Unformat u }
  | w=WHITESPACE                 { Whitespace w }
