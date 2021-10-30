type t = (name * (module Type.S) * doc) list

and name = string

and doc = string

let expansions : t =
  [
    ("default", (module Default), "output to plain text.");
    ("markdown", (module Markdown), "output to Markdown.");
    ("html", (module Html), "output to HTML.");
  ]
