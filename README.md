Various utility functions for fish

* `total` : sum a list of numbers (or do other basic arithmetic reductions). `total 1 2 3` -> 6; `seq 4 | total` -> 10; `total -o\* 2 3` -> 6
* `sec` : convert 'counts of units' or 'human readable' durations (eg. `sec 1 2 1 0 4 0 30`, `sec -x 1Y2M1w4h30s`) into raw second count
* `nufunc` : create a new function in ~/.config/fish/functions/$funcname.fish and edit it (or just edit it if it already exists). eg. `nufunc fillpath`
* `fillpath` : add path and or extension components to a path if they are not yet included. `fillpath -p ~/Desktop -e png foobar` -> `/home/me/Desktop/foobar.png`; `fillpath -p ~/Desktop -e png foobar.jpg` -> `/home/me/Desktop/foobar.jpg`

More to come:

* `lerp` : linear series interpolation expander. eg. `lerp 5 a(#72-360)` -> `a72 a144 a216 a288 a360`
* `expand-words` : Basic 'word expansion' of stdin - `echo 'x * y' | expand-words x 5 y 10` -> `5 * 10`
* `imgw` : create high quality 'reduced sample' versions of large images, usable as, for example,
   an index.
* `pseudohash` : generate 4-character 'hashes' based on automatically incrementing serial numbers salted with the 'series name'. This gives
  'somewhat memorable, mostly unique ids'   for up to 8 million items within a given 'series'. Hashes are portable between systems. 
  `pseudohash` -> `O2cq` (assuming you've never used pseudohash before);
  `pseudohash pages` -> `4Rnc`; `pseudohash logs` -> `7jXR`
  Position within the sequence for a given series-id is stored in the universal variable `__pseudohash_$id`
  (eg `__pseudohash_pages`). To get further hashes, just call it again with the same series id, eg `pseudohash logs` -> `uXVl`.
  Intent was to create a compact form of cross-referencing for documents that could be easily tagged onto the document (via eg. `tmsu`), or
  directly marked onto it (in the case of a drawing or diagram)


* ..etc