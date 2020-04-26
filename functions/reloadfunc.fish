#!/bin/fish

function reloadfunc -w functions -d "Reload specified functions, if they were defined in a file."
  set retval 0
  for funcname in $argv
    if not functions -q $funcname
      set retval 1
      echo "'$funcname' is not a defined function." 1>&2
      continue
    end
    set -l where (functions -D $funcname)
    if not contains $where n/a stdin
      source $where
    else
      set retval 1
      echo "'$funcname' can't be reloaded as it was defined in ($where), not a file." 1>&2
    end
  end
  return $retval
end