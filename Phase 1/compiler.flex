%{
#include <stdio.h>
%}

/* Token constants */
%option noyywrap
%option yylineno

/* Regular expressions for tokens */
DIGIT       [0-9]
LETTER      [a-zA-Z_]
ID          {LETTER}({LETTER}|{DIGIT})*
INT_CONST   {DIGIT}+
STR_CONST   \"([^\"\n]|\\.)*\"
BOOL_CONST  "true"|"false"

/* Keywords */
class       "class"
inherits    "inherits"
if          "if"
then        "then"
else        "else"
fi          "fi"
while       "while"
loop        "loop"
pool        "pool"
let         "let"
in          "in"
case        "case"
of          "of"
esac        "esac"
new         "new"
isvoid      "isvoid"
not         "not"


/* Operators and special symbols */
PLUS        "+"
MINUS       "-"
MULT        "*"
DIV         "/"
LT          "<"
GT          ">"
LEQ         "<="
EQ          "="
LPAREN      "("
RPAREN      ")"
COLON       ":"
SEMI        ";"
AT          "@"
PERIOD      "."
COMMA       ","
ASSIGN      "<-"
LBRACE      "{"
RBRACE      "}"
TILDE       "~"
LBRACKET    "["
RBRACKET    "]"

/* Ignore whitespace */
WS          [ \t\r\f\v\n]+
COMMENT     "//".*|\s*\/\*([^*]|\*+[^*/])*\*+\/

/* Rules for tokens */
%%

{BOOL_CONST} { printf("BOOL_CONST: %s\n", yytext); }
{ID} {
    char *keywords[] = {
        "class", "inherits", "if", "then", "else", "fi", "while", "loop",
        "pool", "let", "in", "case", "of", "esac", "new", "isvoid", "not", "false", "true"
    };
    char *datatypes[] = {"Object", "Int", "String", "Bool", "IO"};
    
    int numKeywords = sizeof(keywords) / sizeof(keywords[0]); 
    int numDatatypes = sizeof(datatypes) / sizeof(datatypes[0]); 
    int f = 0; 

    for (int i = 0; i < numKeywords; ++i) {
        if (strcmp(yytext, keywords[i]) == 0) {
            printf("KEYWORD: %s\n", yytext);
            f = 1;
            break; 
        }
    }
    for (int i = 0; i < numDatatypes; ++i) {
        if (strcmp(yytext, datatypes[i]) == 0) {
            printf("DATATYPE: %s\n", yytext);
            f = 1;
            break; 
        }
    }

    if (!f) {
        printf("ID: %s\n", yytext); 
    }
}

{INT_CONST}  { printf("INT_CONST: %s\n", yytext); }
{STR_CONST}  { printf("STR_CONST: %s\n", yytext); }
{PLUS}       { printf("PLUS: %s\n", yytext); }
{MINUS}      { printf("MINUS: %s\n", yytext); }
{MULT}       { printf("MULTIPLY: %s\n", yytext); }
{DIV}        { printf("DIVISON: %s\n", yytext); }
{LT}         { printf("LT: %s\n", yytext); }
{GT}         { printf("GT: %s\n", yytext); }
{LEQ}        { printf("LEQ: %s\n", yytext); }
{EQ}         { printf("EQ: %s\n", yytext); }
{LPAREN}     { printf("LEFT_PAREN: %s\n", yytext); }
{RPAREN}     { printf("RIGHT_PAREN: %s\n", yytext); }
{COLON}      { printf("COLON: %s\n", yytext); }
{SEMI}       { printf("SEMI_COLON: %s\n", yytext); }
{AT}         { printf("AT: %s\n", yytext); }
{PERIOD}     { printf("PERIOD: %s\n", yytext); }
{COMMA}      { printf("COMMA: %s\n", yytext); }
{ASSIGN}     { printf("ASSIGN: %s\n", yytext); }
{LBRACE}     { printf("LEFT_BRACE: %s\n", yytext); }
{RBRACE}     { printf("RIGHT_BRACE: %s\n", yytext); }
{TILDE}      { printf("TILDE: %s\n", yytext); }
{LBRACKET}   { printf("LEFT_BRACKET: %s\n", yytext); }
{RBRACKET}   { printf("RIGHT_BRACKET: %s\n", yytext); }
{WS} 
{COMMENT}         

.            { printf("ERROR: Invalid token: %s\n", yytext); }

%%

int main(int argc, char** argv) {
    if (argc < 2) {
        fprintf(stderr, "Usage: %s <input_file>\n", argv[0]);
        return 1;
    }

    FILE* input_file = fopen(argv[1], "r");
    if (!input_file) {
        fprintf(stderr, "Error opening input file.\n");
        return 1;
    }

    yyin = input_file;
    yylex();

    fclose(input_file);
    return 0;
}