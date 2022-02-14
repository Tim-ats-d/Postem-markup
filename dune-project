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
 (synopsis "A lightweight markup language designed for quick note taking")
 (depends
  dune
  (ocaml
   (>= 4.11))
  (odoc :with-doc)
  (menhir
   (>= 20210419))))
