%{
/***************************************
 * Flex 词法分析器配置文件 calc.l
 * 定义词法规则和token匹配模式
 ***************************************/
#include <stdio.h>
#include "y.tab.h"
int yywrap(void){
	return 1;
}
%}

%%

"+" return ADD;
"-" return SUB;
"*" return MUL;
"/" return DIV;
"\n" return CR;
"(" return LT;
")" return RT;

([1-9][0-9]*)|0|([0-9]+\.[0-9]+) {
	double temp;
	sscanf(yytext,"%lf",&temp);
	yylval.double_value = temp;
	return DOUBLE_LITERAL;
}

[ \t]+ {
};

. {
}
%%
