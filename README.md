# 基于Flex和Bison的数学表达式计算器

## 项目概述
本计算器实现支持浮点数的四则运算和括号优先级处理，通过词法分析和语法分析构建完整的表达式解析系统。项目使用以下技术栈：
- **Flex**：词法分析器生成器（版本2.6.4）
- **Bison**：语法分析器生成器（版本3.7.6）
- **GCC编译器**：C语言实现语义动作
- **Make**：构建自动化工具

## 功能特性
✅ 支持基本四则运算（+-*/）  
✅ 浮点数运算支持  
✅ 运算符优先级（乘除 > 加减）  
✅ 括号优先级覆盖  
✅ 交互式命令行界面  
✅ 错误恢复机制  

## 编译运行
```bash
# 生成词法分析器
flex calc.l

# 生成语法分析器（-d参数生成头文件）
bison -d calc.y

# 编译生成可执行文件
gcc lex.yy.c y.tab.c -o calc -lm

# 运行计算器
./calc
```

## 文件结构说明
```
calc/
├── calc.l         # Flex词法规则文件
├── calc.y         # Bison语法规则文件
├── makefile       # 构建配置文件
├── lex.yy.c       # Flex生成的词法分析器
├── y.tab.c        # Bison生成的语法分析器
├── y.tab.h        # 词法/语法分析器共享头文件
└── y.output       # Bison语法分析调试报告
```

## 技术详解

### Flex 词法分析器
Flex通过正则表达式定义词法规则，生成C语言实现的词法分析器。核心功能：
```lex
%{
// 包含Bison生成的头文件
#include "y.tab.h"
%}

%%
[0-9]+"."[0-9]+  { yylval.dval = atof(yytext); return NUMBER; }
"+"              { return ADD; }
"-"              { return SUB; }
"*"              { return MUL; }
"/"              { return DIV; }
"("              { return LPAREN; }
")"              { return RPAREN; }
\n               { return EOL; }
[ \t]            ; // 忽略空白
.                { yyerror("非法字符"); }
%%
```

### Bison 语法分析器
Bison使用上下文无关文法定义语法规则，生成LALR解析器。核心功能：
```bison
%{
// 语义值类型定义
#define YYSTYPE double
%}

%token NUMBER
%token ADD SUB MUL DIV LPAREN RPAREN EOL

%left ADD SUB
%left MUL DIV
%left UMINUS

%%
input:    /* empty */
        | input line
;

line:    EOL
        | exp EOL { printf("= %g\n", $1); }
;

exp:    NUMBER          { $$ = $1; }
        | exp ADD exp   { $$ = $1 + $3; }
        | exp SUB exp   { $$ = $1 - $3; }
        | exp MUL exp   { $$ = $1 * $3; }
        | exp DIV exp   { $$ = $1 / $3; }
        | LPAREN exp RPAREN  { $$ = $2; }
        | SUB exp %prec UMINUS { $$ = -$2; }
;
%%
```

## Flex & Bison 协作流程
1. **词法分析阶段**：Flex生成的`yylex()`函数将输入流转换为token序列
2. **语法分析阶段**：Bison解析token流，根据文法规则构建抽象语法树
3. **语义动作执行**：在语法规则中嵌入C代码执行实际计算
4. **错误恢复**：通过`yyerror()`函数实现错误处理机制

## 高级特性实现
1. **优先级处理**：通过Bison的`%left`指令定义运算符优先级
2. **负数支持**：使用`%prec UMINUS`修改产生式优先级
3. **浮点运算**：词法分析器识别双精度浮点数并传递至语法层
4. **内存管理**：单次表达式求值模式避免内存泄漏

## 扩展建议
- 添加变量支持（如`let x = 5`）
- 实现函数调用（如`sin()`, `sqrt()`）
- 增加历史记录功能
- 支持十六进制/二进制数字表示
