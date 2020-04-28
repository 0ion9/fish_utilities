function __fish_print_user_functions
  find ~/.config/fish/functions -printf '%P\n'| string replace -r '.fish$' ''
end

# from 'functions' completion; unfortunately we can't just call the one it defines.

function __rf_fish_maybe_list_all_functions
    # if the current commandline token starts with an _, list all functions
    if string match -qr -- '^_' (commandline -ct)
        functions -an
    else
        functions -n
    end
end


complete -c nufunc -x -a '(__fish_print_user_functions)'
complete -c reloadfunc -x -a '(__rf_fish_maybe_list_all_functions)'
complete -c funcname -w reloadfunc
