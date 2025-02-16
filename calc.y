%{
/***************************************
 * Bison 语法分析器配置文件 calc.y
 * 定义语法规则和语义动作
 * 
 * 文件结构：
 * 1. 头文件声明和调试设置
 * 2. 语义值类型定义（%union）
 * 3. 终结符/非终结符声明（%token/%type）
 * 4. 语法规则定义（%% ... %%）
 * 5. 错误处理函数和主函数
 ***************************************/
#include <stdio.h>
#include <stdlib.h>
#define YYDEBUG 1  // 启用调试模式
%}


%union {
	double double_value;  // 语义值类型为双精度浮点数
}

// 终结符声明（由词法分析器返回）
%token <double_value> DOUBLE_LITERAL  // 数字字面量
%token ADD SUB MUL DIV CR LT RT       // 运算符和符号：
                                      // + - * / 换行符 < >
%type <double_value> primary_expression expression line line_list // 非终结符类型声明

%%

/* 语法规则定义 */
line_list          // 输入行集合
	: line         // 单行输入
	| line_list line  // 多行输入（递归定义）
	;

line              // 单行处理规则
	: expression CR  // 有效表达式+换行
	{
		printf(">> %lf\n",$1);  // 打印计算结果
	}
	| error CR       // 错误处理规则
	{
		yyclearin;   // 清除错误token
		yyerrok;     // 重置错误状态
	}
	;

expression        // 表达式规则（支持运算优先级）
	: primary_expression  // 基础表达式
	| expression MUL expression  // 乘法（左结合）
	{
		$$ = $1 * $3;
	}
	| expression DIV expression  // 除法（左结合）
	{ 
		$$ = $1 / $3;
	}
	| expression ADD expression  // 加法（左结合）
	{
		$$ = $1 + $3;
	}
	| expression SUB expression  // 减法（左结合）
	{
		$$ = $1 - $3;
	}
	;

primary_expression  // 基础表达式元素
	: DOUBLE_LITERAL  // 数字字面量
	| LT expression RT  // 括号表达式
	{
		$$ = $2;  // 返回括号内表达式的值
	}
	;

%%

// 语法错误处理函数
int yyerror(char const *str){
	extern char *yytext;  // 当前解析的token
	fprintf(stderr,"语法错误 near %s\n",yytext);
	return 0;
}

// 主函数
int main(void){
	extern int yyparse(void);    // Bison生成的解析函数
	extern FILE *yyin;           // 输入文件指针
	
	yyin = stdin;                // 设置输入为标准输入
	if(yyparse()){               // 启动语法解析
		fprintf(stderr,"严重错误!\n");
		exit(1);	
	}
	return 0;
}
