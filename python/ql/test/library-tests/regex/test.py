import re
#            0123456789ABCDEF  
re.compile(r'012345678')
re.compile(r'(\033|~{)')
re.compile(r'\A[+-]?\d+')
re.compile(r'(?P<name>[\w]+)|')
re.compile(r'\|\[\][123]|\{\}')
re.compile(r'^.$')
re.compile(r'[^A-Z]')
#       0123456789ABCDEF
re.sub('(?m)^(?!$)', indent*' ', s)
re.compile("(?:(?:\n\r?)|^)( *)\S")
re.compile("[]]")
re.compile("[^]]")
re.compile("[^-]")

#Lookbehind group
re.compile(r'x|(?<!\w)l')
#braces, not qualifier
re.compile(r"x{Not qual}")

#Multiple carets and dollars
re.compile("^(^y|^z)(u$|v$)$")

#Multiples
re.compile("ax{3}")
re.compile("ax{,3}")
re.compile("ax{3,}")
re.compile("ax{01,3}")

#Negative lookahead
re.compile(r'(?!not-this)^[A-Z_]+$')
#Negative lookbehind
re.compile(r'^[A-Z_]+$(?<!not-this)')


#OK -- ODASA-ODASA-3968
re.compile('(?:[^%]|^)?%\((\w*)\)[a-z]')

#ODASA-3985
#Half Surrogate pairs
re.compile(u'[\uD800-\uDBFF][\uDC00-\uDFFF]')
#Outside BMP
re.compile(u'[\U00010000-\U0010ffff]')

#Modes
re.compile("", re.VERBOSE)
re.compile("", flags=re.VERBOSE)
re.compile("", re.VERBOSE|re.DOTALL)
re.compile("", flags=re.VERBOSE|re.IGNORECASE)
re.search("", None, re.UNICODE)
x = re.search("", flags=re.UNICODE)

#empty choice
re.compile(r'|x')
re.compile(r'x|')

#Named group with caret and empty choice.
re.compile(r'(?:(?P<n1>^(?:|x)))')
