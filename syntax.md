**Text**

```
text ::= <Any unicode characters>
```
**Numeric**
```
num ::= "0".."9"
```
**Alias**
```
text "==" text
```
**Century alias**
```
century_alias ::= "_"numeric"e"
```
**Line alias**
```
line_alias ::= "_"numeric<any ASCII character except "e">
```
**Date alias**
```
date_alias ::= "_date_"
```
**Text formatting**
**Title**
```
title ::= '&' .. '&&&&&&' text
```
**Conclusion**
```
".." text
```
**Simple definition**
```
text "::" text
```
**Complex definition**
```
text "::" text ["*" text]*
```
**Text block**
```
text "%" text ["%" text]*
```
