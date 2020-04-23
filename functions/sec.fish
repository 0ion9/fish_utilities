#!/bin/fish

# Req:
#   'total' function

function sec -d '[y.][d.][h.][m.]<s> to plain seconds count.'
  # support : and , as separators
  # Also support implicit 0: h..s == $h hours, 0 minutes, $s seconds
  if not argparse -i d/day x/extended h/help -- $argv
    return 1
  end
  if test -n "$_flag_h"
    echo 'Syntax: '(status function)' [-x] [-d] TIMESPEC'
    echo '  Returns the number of seconds described by TIMESPEC.'
    echo '  TIMESPEC may be:'
    echo '   (without -x) : Simple list of time units, without marking, in the format [[[[[[[Y.]M.]w.]d.]h.]m.]s]'
    echo '                  , and : are also accepted as separators'
    echo '   (with -x): Series of time units with marking immediately following a number, no separators required.'
    echo '              Valid markings are one of YMwdhms.'
    echo
    echo '  -d:  Defines the length of a day as 16 hours rather than 24 hours.'
    echo '       This affects the size of units Y, M, w, d.'
    echo '  -x:  Use extended time format rather than positional. See above for details.'
    echo
    echo '  Examples:'
    for v in '10.30 : ten minutes and 30 seconds, without -x' \
             '10m30s : as above, with -x' \
             '4:10.30 : 4 hours, ten minutes and 30 seconds, without -x' \
             '4.10.30 : as above' \
             '4h10m30s : as above, with -x' \
             '360 : 6 minutes, without -x (note that sec effectively is a passthru op here, since the input is only a raw seconds count)' \
	     '4h 4h 4h  : 12 hours (multiple arguments are added together)'
      echo '   '$v
    end

    return 0
  end
  set -l t (string replace -ar '[:,]' . -- $argv | string split . | string replace -r '^$' 0)
  set -l units Y:-7:31536000 M:-6:2592000 w:-5:604800 d:-4:86400 h:-3:3600 m:-2:60 s:-1:1
  set -l expr [0-9.]+
  if test -n "$_flag_x"
    set expr [0-9.YMwdhms]+
  end
  if test (count $t) -gt (count (string match -r '^'$expr'$' -- $t))
    echo (status function)": input '$argv' contains invalid characters. $expr are accepted. " 1>&2
    return 1
  end
  # Y D H M S
  if test -n "$_flag_d"
    set units Y:-7:21024000 M:-6:1728000 w:-5:403200 d:-4:57600 h:-3:3600 m:-2:60 s:-1:1
  end

  if test -n "$_flag_x"
    set -l buf
    for v in Y M w d h m s
      set -a buf 0
      for m in (string match -ar [0-9]+$v $t)
#        echo "M $m" 1>&2
        set buf[-1] (math "$buf[-1]+"(string match -r [0-9]+ $m))
      end
    end
    set t $buf
  end

  for v in $units
    echo $v |read -ld : id i f
    if test $i = 0
      continue
    end
    if set -q t[$i]
      # XXX
      set t[$i] (math "$t[$i]*$f")
    end
  end
  if set -q t[-8]
    echo (count $t) places were provided, but (status function) only understands 7: 1>&2
    echo Years, Months, Weeks, Days, Hours, Minutes, Seconds 1>&2
    return 1
  end
  printf '%s\n' $t|total
end
