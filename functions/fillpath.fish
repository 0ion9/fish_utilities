#!/bin/fish

function fillpath -d 'add extension or path components to a path if they are not present'
  argparse p/path= e/ext= -- $argv
  # make sure the ext string begins with . (eg. '.png', not 'png')
  # XXX this should be implemented via an argparse callback
  if test -n "$_flag_ext"; and not string match -r '^[.]' "$_flag_ext" > /dev/null
#    echo 'prepending . to $_flag_ext' 1>&2
    set _flag_ext ."$_flag_ext"
  end
  # XXX this, too.
  if test -n "$_flag_path"; and not string match -r '/$' "$_flag_path" > /dev/null
#    echo 'appending / to $_flag_path' 1>&2
    # note that we don't test whether this path exists. The calling process should do that if needed.
    set _flag_path "$_flag_path"/
  end
  for v in $argv
    if test -n "$_flag_ext"; and not string match -r '[.][^/]+$' "$v" > /dev/null
      set v "$v""$_flag_ext"
    end
    if test -n "$_flag_path"; and not string match -r / "$v" > /dev/null
#      echo '/ not found in $v' 1>&2
      set v "$_flag_path""$v"
    end
    printf '%s\n' "$v"
  end
end
