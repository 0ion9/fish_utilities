#!/bin/fish

function sum -w reduce -d '`reduce + $argv` -> sum of numbers given'
  reduce + $argv
end