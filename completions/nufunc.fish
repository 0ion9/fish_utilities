function __fish_print_user_functions
  find ~/.config/fish/functions -printf '%P\n'| string replace -r '.fish$' ''
end

complete -c nufunc -x -a '(__fish_print_user_functions)'
complete -c funcname -w nufunc
complete -c reloadfunc -w nufunc
