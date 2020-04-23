Various utility functions for fish

* `total` : sum a list of numbers (or do other basic arithmetic reductions). `total 1 2 3` -> 6; `seq 4 | total` -> 10; `total -o\* 2 3` -> 6
* `sec` : convert 'counts of units' or 'human readable' durations (eg. `sec 1 2 1 0 4 0 30`, `sec -x 1Y2M1w4h30s`) into raw second count