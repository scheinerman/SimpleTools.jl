# SimpleTools

Miscellaneous code that is possibly useful
for my `SimpleWorld` modules.

## Choosing a value at random

The function `random_choice(wts)` randomly chooses a value
from `1` to `n`, where `n` is the number of elements in
`weights`. The probability that `k` is chosen is proportional
to `weights[k]`. The `weights` must be nonnegative
and not all zero.

This function may also be invoked with a dictionary
argument: `random_choice(d)`.
The dictionary `d` maps keys to nonnegative
real values. The probability a key `k` is returned
is proportional to `d[k]`.

#### Notes

+ No error checking is done on the input. An error
might be raised for bad input, but that's not
guaranteed.
+ The implementation might be improved. If the size
of the argument is small, this is efficient enough.
But if `wts` (or `d`) has many elements, I probably
should do some sort of binary search through the vector
of cummulative sums.
