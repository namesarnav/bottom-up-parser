CC = gcc
CFLAGS = -Wall -g
FLEX = flex
BISON = bison

TARGET = parser
LEX_SRC = scanner.l
YACC_SRC = parser.y
LEX_OUT = lex.yy.c
YACC_OUT = parser.tab.c
YACC_HEADER = parser.tab.h
OBJS = parser.tab.o lex.yy.o

all: $(TARGET)

$(TARGET): $(OBJS)
	$(CC) $(CFLAGS) -o $(TARGET) $(OBJS) -lfl

$(YACC_OUT) $(YACC_HEADER): $(YACC_SRC)
	$(BISON) -d $(YACC_SRC)

$(LEX_OUT): $(LEX_SRC) $(YACC_HEADER)
	$(FLEX) $(LEX_SRC)

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -f $(TARGET) $(LEX_OUT) $(YACC_OUT) $(YACC_HEADER) $(OBJS)

rebuild: clean all