#!/bin/fish

function pseudohash -d 'hash a serial number to produce a 4 digit (base64) reasonably-unique-ID code.'
  # requires: 'refcodes' or `xxd, base64, tr'
  argparse h/help l/last n/index=+ x/export -- $argv
  if test -n "$_flag_h"
    echo (status function) '[-l] [-n] [-x] [series id]'
    printf '    %s\n' \
      'Pseudohash combines serial numbers with hashing. Any given series starts with a value of 1.' \
      'This is combined with the series id: "$seriesid/$value", and hashed, then base64 encoded' \
      'with an altered alphabet (~_ instead of /+, so that the code can be embedded in a filename).' \
      'This 4 character code distinguishes between about 2^24 unique items.' \
      'The base serial number is stored in a fish universal variable named __pseudohash_$SERIESID.' \
      'To restart a series, set this variable to 0.'\
      'Generated codes are "reasonably" unique -- ie. the rate of "false positives" is merely low,' \
      'in exchange for much greater compactness of individual codes.'

    return
  end
  set -l seriesid $argv[1]
  set -l message
  if test -z "$seriesid"
    set seriesid default
  end

  if not set -l __$seriesid
     echo "Series id '$seriesid' is not a valid variable name. Exiting."
     return 1
  else
     set -e __$seriesid
  end


  set -a message $seriesid" PH"
  set -l varname __pseudohash_$seriesid

  if test -n "$_flag_l"
    set -l start (test -n "$$varname"; and math "$$varname"-10; or echo 1)
    set -l _end (test -n "$$varname"; and echo "$$varname"; or echo 10)
    if test "$start" -lt 1
      set start 1
    end
    echo pseudohash $seriesid -n(seq $start $_end) 1>&2
    pseudohash $seriesid -n(seq $start $_end)
    return $status
  end

  if test -n "$_flag_x"
    echo "set -U $varname $$varname"
    if test "$seriesid" = "default"
       set seriesid ''
    end
    echo "# Get next hash with: \$ pseudohash $seriesid"
    return
  end
  # 0 is skipped over
  # in order to use 0, the value here would be -1
  if not set -q $varname
    echo 'Initializing pseudohash series, variable name = '$varname 1>&2
    set -U $varname 0
  end

  set -l index
  if test -z "$_flag_n"
    set $varname (math $$varname+1)
    set index $$varname
  else
    echo 'N' $_flag_n 1>&2
    set index $_flag_n
  end

  set -l refcodes (which refcodes 2>/dev/null)
  if test -z "$refcodes"; and test (which xxd base64 tr 2>/dev/null) -lt 3
    echo 'Either [refcodes] or [xxd + base64 + tr] must be installed. Exiting.'
    return 1
  end
  # the hashes produced by distinct series id are differentiated by using the series id as a prefix
  # we use / as the separator because it cannot be used in a variable name.
  for i in $index
    printf %s/%d\n  $seriesid $i| md5sum - | head -c6 | begin
      if test -n "$refcodes"
        set -l bytes
        while read -n 2 hex; set -a bytes (math 0x$hex); end
        refcodes --code-only $bytes
      else
        xxd -r -p - |base64 -w 0 | tr '/+' '~_'
      end
    end
    printf '(%s #%d)\n' $seriesid $i 1>&2
  end
end
