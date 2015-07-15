%{
	#include<stdio.h>
	extern int yylval;
%}

%token HASHDEF HDFILE NAMESPACE USERFILE
%token IDENTIFIER DIGIT SIZEOF THIS UNION STRUCT CLASS
%token AUTO REGISTER STATIC EXTERN VIRTUAL INLINE CONST VOLATILE FRIEND TYPEDEF PUBLIC PRIVATE PROTECTED
%token SCOPE_OP RIGHT_ASSIGN LEFT_ASSIGN ADD_ASSIGN SUB_ASSIGN MUL_ASSIGN DIV_ASSIGN MOD_ASSIGN AND_ASSIGN XOR_ASSIGN OR_ASSIGN
%token RIGHT_OP LEFT_OP INC_OP DEC_OP PTR_OP AND_OP OR_OP LE_OP GE_OP EQ_OP NE_OP
%token VOID INT CHAR LONG FLOAT UNSIGNED SIGNED DOUBLE SHORT
%token BREAK CONTINUE SWITCH GOTO IF ELSE CASE DEFAULT RETURN FOR WHILE DO
%token CIN COUT

%start start_symbol
%%

start_symbol
	: translation_unit  {printf("\n\n\nTHERE ARE NO ERRORS IN THE PROGRAM\n\n"); return 0;}
	;

translation_unit
	: header class_specifier
	;

header
	: HASHDEF header
	| HDFILE header
	| NAMESPACE header
	| USERFILE header
	|
	;

class_specifier
	: class_head '{' member_list '}' ';'
	;

class_head
	: class_key class_name 
	;

class_name
	: IDENTIFIER
	;

class_key
	: CLASS
	| STRUCT
	| UNION
	;

member_list
	: member_declaration member_list
	| access_specifier ':' member_list
	|
	;

member_declaration
	: decl_specifiers member_declarator_list ';' 
	| function_definition
	;

decl_specifiers
	: decl_specifiers decl_specifier
	|
	;

decl_specifier
	: storage_class_specifier
	| type_specifier
	| fct_specifier
	| FRIEND
	| TYPEDEF
	;

storage_class_specifier
	: AUTO
	| REGISTER
	| STATIC
	| EXTERN
	;

fct_specifier
	: INLINE
	| VIRTUAL
	;

type_specifier
	: simple_type_name
	| class_specifier
	| CONST
	| VOLATILE
	;

simple_type_name
	: CHAR
	| SHORT
	| INT
	| LONG 
	| SIGNED 
	| UNSIGNED 
	| FLOAT 
	| DOUBLE 
	| VOID
	;

member_declarator_list: 
	| member_declarator
	| member_declarator_list ',' member_declarator 
	;

member_declarator
	: declarator pure_specifier
	| declarator
	| IDENTIFIER ':' constant_expression 
	;

pure_specifier
	: '=' DIGIT
	;

access_specifier
	: PUBLIC
	| PRIVATE
	| PROTECTED
	;

declaration
	: decl_specifiers declarator_list ';'
	| function_definition
	;

constant_expression
	: conditional_expression
	;

expression
	: assignment_expression
	| expression ',' assignment_expression
	;

assignment_expression
	: conditional_expression
	| unary_expression assignment_operator assignment_expression
	;

assignment_operator
	: RIGHT_ASSIGN 
	| LEFT_ASSIGN
	| ADD_ASSIGN
	| SUB_ASSIGN
	| MUL_ASSIGN
	| DIV_ASSIGN
	| MOD_ASSIGN
	| AND_ASSIGN
	| XOR_ASSIGN 
	| OR_ASSIGN
	| '='
	;

conditional_expression
	: logical_or_expression
	| logical_or_expression '?' expression ':' conditional_expression 
	;

logical_or_expression
	: logical_and_expression
	| logical_or_expression OR_OP logical_and_expression 
	;

logical_and_expression
	: inclusive_or_expression
	| logical_and_expression AND_OP inclusive_or_expression 
	;

inclusive_or_expression
	: exclusive_or_expression
	| inclusive_or_expression '|' exclusive_or_expression 
	;

exclusive_or_expression
	: and_expression
	| exclusive_or_expression '^' and_expression 
	;

and_expression
	: equality_expression
	| and_expression '&' equality_expression 
	;

equality_expression
	: relational_expression
	| equality_expression EQ_OP relational_expression
	| equality_expression NE_OP relational_expression
	;

relational_expression
	: shift_expression
	| relational_expression '<' shift_expression
	| relational_expression '>' shift_expression
	| relational_expression LE_OP shift_expression
	| relational_expression GE_OP shift_expression
	;

shift_expression
	: additive_expression
	| shift_expression LEFT_OP additive_expression
	| shift_expression RIGHT_OP additive_expression
	;

additive_expression
	: multiplicative_expression
	| additive_expression '+' multiplicative_expression
	| additive_expression '-' multiplicative_expression
	;

multiplicative_expression
	: segment_expression
	| multiplicative_expression '*' segment_expression
	| multiplicative_expression '/' segment_expression
	| multiplicative_expression '%' segment_expression
	;

segment_expression
	: pm_expression
	| segment_expression ']' pm_expression
	;

pm_expression
	: cast_expression
	| pm_expression '.' '*' cast_expression
	| pm_expression PTR_OP '*' cast_expression
	;

cast_expression
	: unary_expression
	| '(' simple_type_name ')' cast_expression
	;

unary_expression
	: postfix_expression
	| INC_OP unary_expression
	| DEC_OP unary_expression
	| unary_operator cast_expression
	| SIZEOF unary_expression
	| SIZEOF '(' simple_type_name ')'
	;

unary_operator
	: '*'
	| '&'
	| '+'
	| '-'
	| '!'
	| '~'
	| '/'
	;

postfix_expression
	: primary_expression
	| postfix_expression '[' expression ']'
	| postfix_expression '(' expression ')'
	| simple_type_name '(' expression ')'
	| postfix_expression '.' name
	| postfix_expression PTR_OP name
	| postfix_expression INC_OP
	| postfix_expression DEC_OP
	;

primary_expression
	: THIS
	| SCOPE_OP IDENTIFIER
	| SCOPE_OP operator_function_name
	| name
	;

name
	: IDENTIFIER
	| operator_function_name
	| '~' class_name
	;

declarator_list
	: init_declarator
	| declarator_list ',' init_declarator
	;

init_declarator
	: declarator initializer
	| declarator
	;

declarator
	: name
	| ptr_operator declarator
	| declarator '(' arg_declaration_list ')' 
	| declarator '(' ')' 
	| declarator '[' constant_expression ']'
	| declarator '[' ']'
	| '(' declarator ')'
	;

ptr_operator
	: '*'
	| '&' 
	| class_name SCOPE_OP '*'
	;

arg_declaration_list
	: argument_declaration
	| arg_declaration_list ',' argument_declaration
	;

argument_declaration
	: decl_specifiers declarator
	| decl_specifiers declarator '=' expression
	;

function_definition
	: decl_specifiers declarator compound_statement
	;

initializer
	: '=' expression
	| '=' '{' initializer_list '}'
	| '(' expression ')'
	;

initializer_list
	: expression
	| initializer_list ',' expression
	| '{' initializer_list '}'
	;

statement
	: labeled_statement
	| expression_statement
	| compound_statement
	| selection_statement
	| iteration_statement
	| jump_statement
	| declaration_statement
	| input_output
	;

input_output
	: CIN LEFT_OP IDENTIFIER ';'
	| COUT RIGHT_OP value
	;

value
	: IDENTIFIER
	| RIGHT_OP value
	| ';'
	;

labeled_statement
	: IDENTIFIER ':' statement
	| CASE constant_expression ':' statement
	| DEFAULT ':' statement 
	;

expression_statement
	: expression ';'
	| ';'
	;

compound_statement
	: '{' statement_list '}'
	| '{' '}'
	;

statement_list
	: statement
	| statement_list statement 
	;

selection_statement
	: IF '(' expression ')' statement
	| IF '(' expression ')' statement ELSE statement
	| SWITCH '(' expression ')' statement
	;

iteration_statement
	: WHILE '(' expression ')' statement
	| DO statement WHILE '(' expression ')' ';'
	| FOR '(' for_init_statement expression ';' expression ';' postfix_expression ')' statement
	;

for_init_statement
	: expression_statement
	| declaration_statement
	| IDENTIFIER '=' DIGIT
	| IDENTIFIER '=' IDENTIFIER
	;

jump_statement
	: BREAK ';'
	| CONTINUE ';'
	| RETURN expression ';'
	| RETURN ';'
	| GOTO IDENTIFIER ';'
	;

declaration_statement
	: declaration
	;

operator_function_name
	: operator operator
	;

operator
	: '+'
	| '-'
	| '*'
	| '/'
	| '%'
	| '^'
	| '&'
	| '|'
	| '~'
	| '!'
	| '<'
	| '>'
	| assignment_operator
	| AND_OP
	| OR_OP
	| INC_OP
	| DEC_OP
	| ','
	| PTR_OP '*'
	| PTR_OP	
	| '(' ')'
	| '[' ']'
	;

%%

int main()
{
	extern FILE *yyin,*yyout;
	char a[20];
	int op;
	system("clear");
	printf("\n\t 1. To enter a C++ program");
	printf("\n\t 2. To enter the C++ filename");
	printf("\n\t 3. To exit");
	printf("\n\t Enter option : ");
	scanf("%d",&op);
	switch(op)
	{
		case 1 : printf("\n\t Enter C++ program :\n\n\n");
			 yyparse();
			 break;
		case 2 : printf("\n\t Enter File name : ");	
			 scanf("%s",a);
			 yyin=fopen(a,"r");
			 yyout=fopen("output.c","w");
			 yyparse();
			 break;
		case 3 : return 0;
		default : printf("\n\n\t Invalid input\n\n\n");
			  return 0;
	}
	return 0;
}

int yyerror()
{
	printf("\n\n\n\nTHE C++ PROGRAM HAS ERROR(s)!!!\n\nCHECK ERROR AT LINE %d\n",yylval);
}	
