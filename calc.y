%{
#include <stdio.h>
#include <stdlib.h>
#define YYDEBUG 1
%}


%union {
	double double_value;
}

%token <double_value> DOUBLE_LITERAL
%token ADD SUB MUL DIV CR LT RT
%type <double_value> primary_expression expression term line line_list

%%

line_list
	: line
	| line_list line
	;

line
	: expression CR
	{
		printf(">> %lf\n",$1);
	}
	;

expression
	: term
	| expression ADD term
	{
		$$ = $1 + $3;
	}
	| expression SUB term
	{
		$$ = $1 - $3;
	}
	;

term
	: primary_expression
	| term MUL primary_expression
	{
		$$ = $1 * $3;
	}
	| term DIV primary_expression 
	{
		$$ = $1 / $3;
	}
	| LT expression RT
	{
		$$ = $2;
	}
	;

primary_expression
	: DOUBLE_LITERAL
	;

%%

int yyerror(char const *str){
	extern char *yytext;
	printf(stderr,"parser error near %s\n",yytext);
	return 0;
}

int main(void){
	extern int yyparse(void);
	extern FILE *yyin;
	yyin = stdin;
	if(yyparse()){
		fprintf(stderr,"ERROR!\n");
		exit(1);	
	}
	return 0;
}
