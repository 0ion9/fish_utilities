#!/bin/fish

function nufunc
  argparse f/from= i/import= -- $argv

  set -l func $argv[1]
  set -l file ~/.config/fish/functions/$func.fish

  # XXX implement --import (bring in function defined in environment, using 'type')
  if test -e $file
    echo "Not overwriting $file, editing only"
  else
    if test -n "$_flag_from"
      set srcfile (fillpath -p ~/.config/fish/functions -e fish $_flag_from)
      if not test -f "$srcfile"
        echo "Template file $v doesn't exist or is not a regular file. Exiting."
        exit
      else
        cp -av -- $srcfile $file
        sed -iEe "s,function $_flag_from,function $func," $file
      end
    else
      printf "#!/bin/fish\n\nfunction $func\n\nend" > $file
    end
  end

  set -l cmd $EDITOR $file

  if test (count $argv) -gt 1
    set -a cmd $argv[2..-1]
  end

  eval $cmd
end
