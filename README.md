# Project 2 – Bottom-Up Parser (Flex & Bison)

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

## Build Instructions

Compile the program:

```bash
make
```

Clean all generated files:

```bash
make clean
```

---

## Run Instructions

Run interactively:

```bash
./parser
```

You’ll see:

```
Enter expressions (Ctrl+D to end):
```

Type statements line by line (press Enter between each).
Use **Ctrl+D** (Linux/macOS) or **Ctrl+Z + Enter** (Windows) to end input.

---

## Example Run

**Input**

```
A = 6 + x + 9
x = 2 + 2 * 4
```

**Output**

```
=== Abstract Syntax Tree ===
ASSIGNMENT: A =
  OPERATOR: +
    OPERATOR: +
      INTEGER: 6
      VARIABLE: x
    INTEGER: 9

=== Abstract Syntax Tree ===
ASSIGNMENT: x =
  OPERATOR: +
    INTEGER: 2
    OPERATOR: *
      INTEGER: 2
      INTEGER: 4
```

---

## Features

* ✅ Supports integers, variables, and operators `+`, `-`, `*`, `/`
* ✅ Handles parentheses `( )`
* ✅ Accepts multiple statements per run
* ✅ Prints a structured **Abstract Syntax Tree**
* ✅ Reports **lexical and syntax errors** with line and column numbers

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

---

## Author

Arnav Verma
University of North Texas
CSCE 4430 – Programming Languages
