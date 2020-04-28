#!/bin/fish

# Req:
#   cat

# See also these shortcut functions:
#   sum (== `reduce + $argv`)
#   product (== `reduce x $argv`)

function reduce -d "<STDIN> | reduce [-s SCALE] OP [NUMBER..] , or reduce [-s SCALE] OP NUMBER [NUMBER..]"
  set -l retval 0
  if not argparse -i h/help s/scale='!test $_flag_value -ge 0 -a $_flag_value -le 99; or test max = $_flag_value' -- $argv
    set retval 1
    set _flag_h 1
  end

  set op (string replace x '*' -- $argv[1])
  if not contains "$op" - + "*" /
    set retval 1
    set -l okops '[ one of + - / * x ]'
    if test -z "$op"
      echo "An operator $okops must be provided." 1>&2
    else
      echo "'$op' is not a valid operator $okops" 1>&2
    end
    set _flag_h 1
  end
  set argv $argv[2..-1]

  if test -n "$_flag_h"
    echo (status function) [-h] [-s scale] OPERATOR NUMBER [NUMBER..]
    echo "  Arithmetic reduction (+-/*) of numbers from stdin and/or arguments."
    echo "  OPERATOR : Operator used for reduction. One of + - / * x. [default: *]"
    echo "             (x is a convenience alias for *)"
    echo "  -s SCALE : Scale setting passed to `math`"
    echo
    echo "  Numbers read from stdin should be separated by spaces."
    echo "  A 'Number' is any valid 'math' expression - '2', '-6', '1e5', 'sin(.5)' etc."
    echo "  Empty arguments or lines are ignored."
    echo "  Numbers from stdin are prepended to command-line numbers, eg 'echo 5 | reduce - 4'"
    echo "    evaluates (5-4) == 1"
    echo
    echo "  Reducing a single number, N, simply returns N. "
    echo "  For other operators, a minimum of 1 number is required."
    return $retval
  end

  set -l joiner $op
  # expands to empty if _flag_s is unset -- see `help expand` for why.
  set -l mathargs (echo -s"$_flag_s")
  set -l argpad_left
  set -l argpad_right

  # parenthesize all numbers in case they are compound expressions
  set -l repl string replace --filter -ar '^(.+)$' '($1)'

  switch "$op"
    case +
      set argpad_left 0
    case '\*'
      set argpad_left 1
    case /
      set argpad_right 1
    case -
      set argpad_right 0
  end

  if not isatty stdin
    cat -
    printf '%s\n' $argpad_left $argv $argpad_right
  else
    # this test can only be done correctly once we know that no numbers are coming from stdin
    if test (count $argv) -eq 0
      echo 'At least one number must be given' 1>&2
    end
    printf %s\n $argpad_left $argv $argpad_right
  end | string replace -a ' ' '' | $repl |  string join -- $joiner | math $mathargs
end
