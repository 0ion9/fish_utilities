#!/bin/fish

function funcfile -w functions -d 'get filename function(s) were defined in'
  argparse h/help -- $argv
  if test "$_flag_h"
    echo (status function)' funcname [funcname..]'
    echo
    echo '  Generalization of "functions -D" to apply to multiple files,'
    echo '  Example usage: `geany (funcfile funcfile nufunc reloadfunc)`'
  end
  # Extends `functions -D` to multiple functions
  # eg `geany (funcfile funcfile nufunc reloadfunc)` to open these three related functions in Geany
  for f in $argv
    functions -D $f
  end
end