#!/bin/fish

# Req:
#   cat
#   tr

# XXX technically this should be named 'reduce', but the most common usage
# is as a totaller.

function total -d "<STDIN> | total, or total N1 N2 N3 [..]"
  # XXX be more accurate with '-s' -- accept 'max', since 'math' does.
  argparse -i h/help o/operator='!string match -qr "^[+/*x-]\$"' s/scale='!_validate_int --min 0 --max 99' -- $argv
  set -l joiner +
  set -l minargs 1
  # expands to empty if _flag_s is unset -- see `help expand` for why.
  set -l mathargs (echo -s"$_flag_s")
  set -l argpad 0
  set -l repl string replace --filter -ar '^(.+)$' '($1)'
  if test -n "$_flag_o"
    switch "$_flag_o"
      case '\*' x / + -
        set joiner "$_flag_o"
        if string match -qrv -- '[+*x]' "$_flag_o"
          set minargs 2
          set argpad
        end
        if test '*' = "$_flag_o"
          set argpad 1
        end
      case \*
        echo "Invalid setting for -o: '$_flag_o'; must be one of + - * / "
    end
    # x is a convenience alias for *, same as with `math`.
    if test "$_flag_o" = x
      set joiner "*"
    end
  end

  if test -n "$_flag_h"
    echo (status function) [-h] [-o op] [-s scale] NUMBER.. : 'Arithmetic reduction (+-/*) of numbers from stdin and/or arguments.'
    echo "  -o op: Operator used for reduction. One of + - / *. [default: *]"
    echo "  -s scale: Scale setting passed to `math`"
    echo "  Numbers read from stdin should be separated by spaces."
    echo "  A 'Number' is any valid 'math' expression - '2', '-6', '1e5', 'sin(.5)' etc."
    echo "  Empty arguments or lines are ignored."
    return 0
  end
  # when no arguments are supplied, return 0
  if not isatty stdin
    begin;
      cat -
      printf '%s\n' $argpad $argv
    end |tr -d ' ' | $repl |  string join -- $joiner | math $mathargs
  else
    if test (count $argv) -eq 0
      echo 'At least '(switch $minargs; case 1; echo one number; case 2: echo two numbers;end)\
        ' must be given' 1>&2
    end
    $repl -- $argpad $argv | string join -- $joiner | math $mathargs
  end
end
