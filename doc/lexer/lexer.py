
from pygments.lexer import RegexLexer, bygroups
from pygments.token import Generic, Keyword, Name, Number, String, Text


class PostemLexer(RegexLexer):
    name = 'Postem'
    aliases = ['postem']

    tokens = {
        'root': [
            # Integer
            (r'\d+', Number.Integer),
            # Whitespace
            (r'( |\t|\r)', Text),
            # Alias
            (r'(.+)( |\t|\r)*(==)( |\t|\r)*(".*")',
             bygroups(Name.Variable, Text, Keyword, Text, String.Double)),
            # Metamark with args
            (r'(\.\.)(.+)( |\t|\n)([^\.\.]*)(\.\.)', bygroups(Keyword,
             Name.Attributes, Text, Name.Attributes, Keyword)),
            # Metamark without args
            (r'@(.+)', Name.Attributes),
            # Unformat
            (r'(\{\{)(.*)(\}\})', bygroups(Keyword, Text, Keyword)),
            # Conclusion
            (r'(--)( |\t|\n)*(.*)', bygroups(Keyword, Text, Generic.Strong)),
            # Definition
            (r'(.*)( |\t|\n)*(%%)( |\t|\n)*(.*)',
             bygroups(Generic.Strong, Text, Keyword, Text, Generic.Emph)),
            # Heading
            (r'&.*\n', Generic.Heading),
            # Subheading
            (r'&+.*\n', Generic.Subheading),
            # Quotation
            (r'(>)(.*)', bygroups(Keyword, Generic.Emph)),
            # Text
            (r'.', Text),
        ]
    }
