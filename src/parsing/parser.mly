%{
  open Ast.Ast_types

  let make_loc startpos endpos = { startpos; endpos }
%}

%token <string> TEXT
%token <string> WHITESPACE

%token SEPARATOR
%token EOF

%token ASSIGNMENT
%token <string> STRING

%token <string * string> METAARGS
%token <string> METASINGLE
%token <string> UNFORMAT

%token CONCLUSION DEFINITION QUOTATION
%token <int> HEADING

%start document

%type <expr document> document

%%

document: blist=separated_list(SEPARATOR, block_list); EOF { blist }

block_list:
  | bl=conclusion | bl=definition | bl=heading | bl=quotation { Block bl }
  | p=paragraph { Paragraph p }

conclusion: CONCLUSION; p=paragraph { Conclusion p }

definition: n=paragraph; DEFINITION; v=paragraph { Definition (n, v) }

heading: h=HEADING; p=paragraph { Heading (Ast.Share.TitleLevel.of_int h, p) }

quotation: QUOTATION; p=paragraph { Quotation p }

paragraph: elist=expr+ { elist }

expr:
  | n=TEXT; ASSIGNMENT; v=STRING { `AliasDef (n, v) }
  | m=METAARGS                   { let name, text = m in
                                   `MetamarkArgs (make_loc $startpos $endpos, name, text) }
  | m=METASINGLE                 { `MetamarkSingle (make_loc $startpos $endpos, m) }
  | t=TEXT                       { `Text t }
  | u=UNFORMAT                   { `Unformat u }
  | w=WHITESPACE                 { `Whitespace w }
