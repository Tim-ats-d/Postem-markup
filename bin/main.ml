open Ast

let document =
  Ast_types.Document
    [
      Block (Heading (0, Text "Postem"));
      Alias ("P", "Postem");
      Block
        (Quotation
           (Seq
              [
                Text "P";
                White (1, Space);
                Text "is";
                White (1, Space);
                Text "a";
                White (1, Space);
                Text "fast";
                White (1, Space);
                Text "and";
                White (1, Space);
                Text "easy";
                White (1, Space);
                Text "notes";
                White (1, Space);
                Text "taking";
                White (1, Space);
                Text "oriented";
                White (1, Space);
                Text "markup";
                White (1, Space);
                Text "language.";
              ]));
      Block
        (Quotation
           (Seq
              [
                Text "I";
                White (1, Space);
                Text "have";
                White (1, Space);
                Text "written";
                White (1, Space);
                Text "P";
                White (1, Space);
                Text "to";
                White (1, Space);
                Text "be";
                White (1, Space);
                Text "fast.";
              ]));
      Block
        (Definition
           ( Text "Fast",
             Seq
               [
                 Text "Synonymous";
                 White (1, Space);
                 Text "with";
                 White (1, Space);
                 Text "fast";
               ] ));
    ]

let () = Ast.Eval.eval "doc" document |> print_endline
