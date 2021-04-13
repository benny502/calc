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
	| error CR
	{
		yyclearin;
		yyerrok;
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
	| term ADD primary_expression
	{
		$$ = $1 + $3;
	}
	| term SUB primary_expression
	{
		$$ = $1 + $3;
	}
	;

primary_expression
	: DOUBLE_LITERAL
	| LT term RT
	{
		$$ = $2;
	}
	;

%%

int yyerror(char const *str){
	extern char *yytext;
	fprintf(stderr,"parser error near %s\n",yytext);
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
