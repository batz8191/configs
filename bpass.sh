#!/bin/bash
x=$(java -cp $HOME/code/dev/bpass BPass $1 $2)
xte "str $x"
