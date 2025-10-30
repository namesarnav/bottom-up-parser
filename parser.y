%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* externs from Flex */
extern int line_num;
extern int col_num;
extern FILE *yyin;

int yylex(void);
void yyerror(const char *s);

/* AST Node Types */
typedef enum {
    NODE_INTEGER,
    NODE_VARIABLE,
    NODE_BINARY_OP,
    NODE_ASSIGNMENT
} NodeType;

/* AST Node Structure */
typedef struct ASTNode {
    NodeType type;
    union {
        int int_value;
        char *var_name;
        struct {
            char op;
            struct ASTNode *left;
            struct ASTNode *right;
        } binary_op;
        struct {
            char *var_name;
            struct ASTNode *expr;
        } assignment;
    } data;
} ASTNode;

/* Function declarations */
ASTNode* create_integer_node(int value);
ASTNode* create_variable_node(char *name);
ASTNode* create_binary_op_node(char op, ASTNode *left, ASTNode *right);
ASTNode* create_assignment_node(char *var_name, ASTNode *expr);
void print_ast(ASTNode *node, int indent);
void free_ast(ASTNode *node);
%}

/* Union for semantic values */
%union {
    int int_val;
    char *str_val;
    struct ASTNode *node;
}

/* Tokens */
%token <int_val> INTEGER
%token <str_val> VARIABLE
%token ASSIGN PLUS MINUS MULT DIV LPAREN RPAREN

/* Non-terminals */
%type <node> statement expression term factor integer

/* Operator precedence */
%left PLUS MINUS
%left MULT DIV

%start input

%%

/* ===================== GRAMMAR ===================== */

input:
      /* empty */
    | input statement '\n'
    | input statement
    ;

statement:
      VARIABLE ASSIGN expression {
          ASTNode *stmt = create_assignment_node($1, $3);
          printf("\n=== Abstract Syntax Tree ===\n");
          print_ast(stmt, 0);
          free_ast(stmt);
      }
    | expression {
          ASTNode *expr = $1;
          printf("\n=== Abstract Syntax Tree ===\n");
          print_ast(expr, 0);
          free_ast(expr);
      }
    ;

expression:
      term
    | expression PLUS term  { $$ = create_binary_op_node('+', $1, $3); }
    | expression MINUS term { $$ = create_binary_op_node('-', $1, $3); }
    ;

term:
      factor
    | term MULT factor { $$ = create_binary_op_node('*', $1, $3); }
    | term DIV factor  { $$ = create_binary_op_node('/', $1, $3); }
    ;

factor:
      LPAREN expression RPAREN { $$ = $2; }
    | integer
    | VARIABLE { $$ = create_variable_node($1); }
    ;

integer:
      INTEGER { $$ = create_integer_node($1); }
    ;

%%

/* ===================== IMPLEMENTATION ===================== */

ASTNode* create_integer_node(int value) {
    ASTNode *node = malloc(sizeof(ASTNode));
    node->type = NODE_INTEGER;
    node->data.int_value = value;
    return node;
}

ASTNode* create_variable_node(char *name) {
    ASTNode *node = malloc(sizeof(ASTNode));
    node->type = NODE_VARIABLE;
    node->data.var_name = strdup(name);
    return node;
}

ASTNode* create_binary_op_node(char op, ASTNode *left, ASTNode *right) {
    ASTNode *node = malloc(sizeof(ASTNode));
    node->type = NODE_BINARY_OP;
    node->data.binary_op.op = op;
    node->data.binary_op.left = left;
    node->data.binary_op.right = right;
    return node;
}

ASTNode* create_assignment_node(char *var_name, ASTNode *expr) {
    ASTNode *node = malloc(sizeof(ASTNode));
    node->type = NODE_ASSIGNMENT;
    node->data.assignment.var_name = strdup(var_name);
    node->data.assignment.expr = expr;
    return node;
}

void print_ast(ASTNode *node, int indent) {
    if (!node) return;
    for (int i = 0; i < indent; i++) printf("  ");
    switch (node->type) {
        case NODE_INTEGER:
            printf("INTEGER: %d\n", node->data.int_value);
            break;
        case NODE_VARIABLE:
            printf("VARIABLE: %s\n", node->data.var_name);
            break;
        case NODE_BINARY_OP:
            printf("OPERATOR: %c\n", node->data.binary_op.op);
            print_ast(node->data.binary_op.left, indent + 1);
            print_ast(node->data.binary_op.right, indent + 1);
            break;
        case NODE_ASSIGNMENT:
            printf("ASSIGNMENT: %s =\n", node->data.assignment.var_name);
            print_ast(node->data.assignment.expr, indent + 1);
            break;
    }
}

void free_ast(ASTNode *node) {
    if (!node) return;
    switch (node->type) {
        case NODE_VARIABLE:
            free(node->data.var_name);
            break;
        case NODE_BINARY_OP:
            free_ast(node->data.binary_op.left);
            free_ast(node->data.binary_op.right);
            break;
        case NODE_ASSIGNMENT:
            free(node->data.assignment.var_name);
            free_ast(node->data.assignment.expr);
            break;
        case NODE_INTEGER:
            break;
    }
    free(node);
}

void yyerror(const char *s) {
    fprintf(stderr, "Parse error at line %d, column %d: %s\n", line_num, col_num, s);
}

int main(int argc, char **argv) {
    if (argc > 1) {
        FILE *file = fopen(argv[1], "r");
        if (!file) {
            fprintf(stderr, "Error: Cannot open file '%s'\n", argv[1]);
            return 1;
        }
        yyin = file;
    }

    printf("Enter expressions (Ctrl+D to end):\n");
    yyparse();
    return 0;
}