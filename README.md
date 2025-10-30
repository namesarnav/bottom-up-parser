# Project 2 – Bottom Up Parser (Flex & Bison)

## Overview

This project implements a **bottom-up parser** using **Flex** and **Bison**.
It performs lexical analysis and parsing for arithmetic and assignment statements, producing an **Abstract Syntax Tree (AST)** that visually represents the structure of each expression.

---

## Grammar

The parser follows the base grammar from Project 1, with the addition of assignment statements.

```
<expression>        -> <term> <expression_suffix>
<expression_suffix> -> + <term> <expression_suffix> | - <term> <expression_suffix> | ε
<term>              -> <factor> <term_suffix>
<term_suffix>       -> * <factor> <term_suffix> | / <factor> <term_suffix> | ε
<factor>            -> ( <expression> ) | <integer> | <variable>
<statement>         -> <variable> = <expression>
```

This grammar supports both arithmetic operations and variable assignments, for example:

```
A = 2 * 3 + 4
B = (2 + 3) * 4
x = y + 2 * (3 - 1)
```

---

## Files

| File        | Description                                                                  |
| ----------- | ---------------------------------------------------------------------------- |
| `scanner.l` | Flex lexer that recognizes tokens such as integers, variables, and operators |
| `parser.y`  | Bison parser that constructs the AST based on grammar rules                  |
| `Makefile`  | Automates the build and clean process                                        |
| `README.md` | Project documentation and usage guide                                        |

---
## Build and Run Instructions

You can run the project using either a shell script or by compiling manually.

---

### **Option 1: Using `run.sh` (Recommended)**

1. **Give execution permission (first time only):**

   ```bash
   chmod +x run.sh
   ```

2. **Run the project:**

   ```bash
   ./run.sh
   ```

This script automatically compiles the source files and runs the program for you.

---

### **Option 2: Manual Compilation and Execution**

If you prefer to run it yourself:

- You can either use the Makefile:
```bash
make clean
make
```

- Or you can do it all manually with: 
```bash
bison -d parser.y
flex lexer.l
gcc parser.tab.c lex.yy.c -o parser -lfl
./parser
```

You can then enter expressions interactively:

```
Enter expressions (Ctrl+D to end):
a = b + c
x = 1 + 2 * 3
```

---

## Features

* Supports integers, variables, and operators `+`, `-`, `*`, `/`
* Handles parentheses `( )`
* Accepts multiple statements per run
* Prints a structured **Abstract Syntax Tree**
* Reports **lexical and syntax errors** with line and column numbers

---

## Error Handling Example

**Input**

```
A = 2++3
@x = 5
```

**Output**

```
Parse error at line 1, column 5: syntax error
Lexical error: invalid character '@' at line 2, col 1
```

---

## Requirements

Install dependencies (if needed):

```bash
sudo apt install flex bison
```

## Use of AI
AI tools were used to assist only with **documentation** and **debugging**. 

Tools used: 
1. Github Copilot - Debugging 
2. ChatGPT - Formatting `README.md` and adding comments in code

**All core logic, grammar rules, and testing were implemented and verified manually by me (Arnav).**

---

## Author

Arnav Verma
University of North Texas
CSCE 4430 – Programming Languages
