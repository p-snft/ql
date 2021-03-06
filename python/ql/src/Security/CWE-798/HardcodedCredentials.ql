/**
 * @name Hard-coded credentials
 * @description Credentials are hard coded in the source code of the application.
 * @kind problem
 * @problem.severity error
 * @precision medium
 * @id py/hardcoded-credentials
 * @tags security
 *       external/cwe/cwe-259
 *       external/cwe/cwe-321
 *       external/cwe/cwe-798
 */

import semmle.python.security.TaintTracking
import semmle.python.filters.Tests

class HardcodedValue extends TaintKind {

    HardcodedValue() {
        this = "hard coded value"
    }

}

bindingset[char, fraction]
predicate fewer_characters_than(StrConst str, string char, float fraction) {
    exists(string text, int chars |
        text = str.getText() and
        chars = count(int i | text.charAt(i) = char) |
        /* Allow one character */
        chars = 1 or
        chars < text.length() * fraction
    )
}

predicate possible_reflective_name(string name) {
    exists(any(ModuleObject m).getAttribute(name))
    or
    exists(any(ClassObject c).lookupAttribute(name))
    or
    any(ClassObject c).getName() = name
    or
    any(ModuleObject m).getName() = name
    or
    exists(builtin_object(name))
}

int char_count(StrConst str) {
    result = count(string c | c = str.getText().charAt(_))
}

predicate capitalized_word(StrConst str) {
    str.getText().regexpMatch("[A-Z][a-z]+")
}

predicate maybeCredential(ControlFlowNode f) {
    /* A string that is not too short and unlikely to be text or an identifier. */
    exists(StrConst str |
        str = f.getNode() |
        /* At least 10 characters */
        str.getText().length() > 9 and
        /* Not too much whitespace */
        fewer_characters_than(str, " ", 0.05) and
        /* or underscores */
        fewer_characters_than(str, "_", 0.2) and
        /* Not too repetitive */
        exists(int chars |
            chars = char_count(str) |
            chars > 20 or
            chars > str.getText().length()/2
        ) and
        not possible_reflective_name(str.getText()) and
        not capitalized_word(str)
    )
    or
    /* Or, an integer with at least 8 digits */
    exists(IntegerLiteral lit |
        f.getNode() = lit
        |
        not exists(lit.getValue())
        or
        lit.getValue() > 10000000
    )
}

class HardcodedValueSource extends TaintSource {

    HardcodedValueSource() {
        maybeCredential(this)
    }

    override predicate isSourceOf(TaintKind kind) {
        kind instanceof HardcodedValue
    }

}

class CredentialSink extends TaintSink {

    CredentialSink() {
        exists(string name |
            name.regexpMatch(getACredentialRegex()) and
            not name.suffix(name.length()-4) = "file"
            |
            any(FunctionObject func).getNamedArgumentForCall(_, name) = this
            or
            exists(Keyword k |
                k.getArg() = name and k.getValue().getAFlowNode() = this
            )
            or
            exists(CompareNode cmp, NameNode n |
                n.getId() = name
                |
                cmp.operands(this, any(Eq eq), n)
                or
                cmp.operands(n, any(Eq eq), this)
            )
        )
    }


    override predicate sinks(TaintKind kind) {
        kind instanceof HardcodedValue
    }

}

/**
  * Gets a regular expression for matching names of locations (variables, parameters, keys) that
  * indicate the value being held is a credential.
  */
private string getACredentialRegex() {
  result = "(?i).*pass(wd|word|code|phrase)(?!.*question).*" or
  result = "(?i).*(puid|username|userid).*" or
  result = "(?i).*(cert)(?!.*(format|name)).*"
}

from TaintSource src, TaintSink sink

where src.flowsToSink(sink) and
not any(TestScope test).contains(src.(ControlFlowNode).getNode())

select sink, "Use of hardcoded credentials from $@.", src, src.toString()
