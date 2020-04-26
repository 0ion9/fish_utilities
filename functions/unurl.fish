#!/bin/fish

# 'Copy Location' (for example, in GIMP or Nautilus) produces file:// URIs
# which need to be converted before use on the commandline.
#
# 'unurl' is not a 100% satisfying name, but it's the closest I've come so far to expressing what
# this function does. Feel free to suggest a better one.
#
# My typical use is with xsel - eg 'sxiv (xsel -ob | unurl)'

function unurl -d 'convert file:///path/to/file.ext -> ordinary /path/to/file.ext'
  if not isatty stdin
    cat -
  else
    printf %s\n $argv
  end | while read -L url
    # keep non-file:// items unmodified, so that you can mix URIs and ordinary paths
    # (for example, using `clipmon` and then copying several paths across various applications which
    #  may individually return either file:// URIs or ordinary paths)
    if string match -qr '^file://' -- $url
      string unescape --style url -- $url | string replace -r '^file://' ''
    else
      printf %s\n "$url"
    end
  end
end