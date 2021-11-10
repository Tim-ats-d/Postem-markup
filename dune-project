(lang dune 2.9)

(using menhir 2.1)

(version 0.0.1)

(name postem)

(license "GPL-3.0")

(authors "The postem programmers")

(maintainers "tim.arnouts@protonmail.com")

(source
 (github Tim-ats-d/Postem-markup))

(bug_reports "https://github.com/Tim-ats-d/Postem-markup/issues")

(homepage "https://github.com/Tim-ats-d/Postem-markup")

(documentation "https://github.com/Tim-ats-d/Postem-markup/tree/master/doc")

(generate_opam_files true)

(package
 (name postem)
 (synopsis "Fast and easy notes taking oriented markup language")
 (description
  "Postem is a fast and easy notes taking oriented markup language.\n\nIt aims to offer a quick language to write to structure a text taken in note.")
 (depends
  (ocaml
   (>= 4.11))
   dune
  (menhir
   (>= 20210419))
  (ocamllex (>= 4.11.1))))
