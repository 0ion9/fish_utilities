#!/bin/fish

# 'Copy Location' (for example, in GIMP or Nautilus) produces file:// urls
# which need to be converted before use on the commandline.
#
# 'unurl' is not a 100% satisfying name, but it's the closest I've come so far to expressing what
# this function does. Feel free to suggest a better one.
#
# My typical use is with xsel - eg 'sxiv (xsel -ob | unurl)'

function unurl -d 'convert file:///path/to/file.ext -> ordinary /path/to/file.ext'
  if not isatty stdin
    string unescape --style url | string replace -r '^file://' ''
  else
    string unescape --style url -- $argv | string replace -r '^file://' ''
  end
end