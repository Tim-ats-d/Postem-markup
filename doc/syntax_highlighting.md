# Syntaxic color for Postem

**Postem** provides a [custom lexer pygments](https://pygments.org/docs/lexerdevelopment/) ready to use located in `doc/lexer/lexer.py`.

Here is an example of **Python** code using it:
```py
import pygments
from pygments.formatters import HtmlFormatter
from pygments.lexers import load_lexer_from_file

sample_postem_code = """
& Section

> Quote
"""

formatter = HtmlFormatter()

with open("styles.css", "w") as f:
    f.write(formatter.get_style_defs())

with open("output.html", "w") as f:
    lexer = load_lexer_from_file("lexer.py", "PostemLexer")
    output = pygments.highlight(sample_postem_code, lexer, formatter)

    f.write('<head><link rel="stylesheet" type="text/css" href="styles.css"></head>')
    f.write(output)

```

See the [related Pygments documentation](https://pygments.org/docs/) for more information
