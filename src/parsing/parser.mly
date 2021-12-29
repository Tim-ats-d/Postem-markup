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
  | name=TEXT; ASSIGNMENT; value=STRING { `AliasDef {name; value} }
  | m=METAARGS { let name, value = m in
                `MetaArgsCall (make_loc $startpos $endpos, { name; value }) }
  | m=METASINGLE { `MetaSingleCall (make_loc $startpos $endpos, m) }
  | t=TEXT { `Text t }
  | u=UNFORMAT { `Unformat u }
  | w=WHITESPACE { `Whitespace w }
