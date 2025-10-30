#!/bin/bash
make clean
echo "---- Cleaned environment ----"
echo "---- Building files ----"
make
echo "---- Starting Parser ----"
./parser
