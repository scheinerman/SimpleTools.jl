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

## Composition of dictionaries

Dictionaries are like functions and so it makes sense
to define a composition operation for them.

Suppose that `f` and `g` are dictionaries such
that all the values in `f` appear as keys in `g`.
Then, if `k` is any key of `f` the expression `g[f[k]]`
is defined. In this case, we may compute `g*f` to
yield a new dictionary `h` with the same keys as `f`
and for which `h[k] == g[f[k]]` for all keys `k`.

Warnings are issued under the following circumstances:
+ If some value of `f` is not a key of `g`.
+ If the type of the values in `f` doesn't match
the key type for `g`.

#### Examples

Here is an example without any warnings.

```julia
julia> f = Dict([("alpha", 1), ("bravo", 2)])
Dict{ASCIIString,Int64} with 2 entries:
  "alpha" => 1
  "bravo" => 2

julia> g = Dict([(1,3.14), (2,2.718), (3,1.618)])
Dict{Int64,Float64} with 3 entries:
  2 => 2.718
  3 => 1.618
  1 => 3.14

julia> g*f
Dict{ASCIIString,Float64} with 2 entries:
  "alpha" => 3.14
  "bravo" => 2.718
```

And this is an example in which problems arise
that are not so serious that the composition fails:

```julia
julia> f = Dict([("alpha", 1), ("bravo", 2)])
Dict{ASCIIString,Int64} with 2 entries:
  "alpha" => 1
  "bravo" => 2

julia> g = Dict([(1.0, 3.33)])
Dict{Float64,Float64} with 1 entry:
  1.0 => 3.33

julia> g*f
WARNING: Dictionary type mismatch
WARNING: 1 keys were not mapped
Dict{ASCIIString,Float64} with 1 entry:
  "alpha" => 3.33
```
