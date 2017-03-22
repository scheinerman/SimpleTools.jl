# SimpleTools

Miscellaneous code that is possibly useful
for my `SimpleWorld` modules.


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

## Counters

We often want to count things and a way to do that is to create a dictionary
that maps objects to their counts. A `Counter` object simplifies that
process. Say we want to count values of type `ASCIIString`. We would
create a counter for that type like this:
```julia
julia> c = Counter{String}()
Counter{String} with 0 entries
```

The two primary operations for a `Counter` are value increment and
value retrieval. To increment the value of a counter we do this:
```julia
julia> c["hello"] += 1
1
```
To access the count, we use square brackets:
```julia
julia> c["hello"]
1

julia> c["bye"]
0
```
Notice that we need not worry about whether or not a key is
already known to the `Counter`. If presented with an unknown key,
the `Counter` assumes its value is `0`.

A `Counter` may be assigned to like this `c["alpha"]=4` but
the more likely use case is `c["bravo"]+=1` invoked each
time a value, such as `"bravo"` is encountered.


#### Addition of counters

If `c` and `d` are counters (of the same type of object) their sum
`c+d` creates a new counter by adding the values in `c` and `d`. That
is, if `a=c+d` and `k` is any key, then `a[k]` equals `c[k]+d[k]`.


#### Incrementing

To increment the count of an item `x` in a counter `c` we may either
use `c[x]+=1` or the increment function like this: `incr!(c,x)`.

The increment function `incr!` is more useful for incrementing a
collection of items. Use `incr!(c,items)` to add 1 to the count
for each element held in `items`. If an element is present in `items`
multiple times, its count is incremented for each occurrence.

```julia
julia> c = Counter{Int}()
SimpleTools.Counter{Int64} with 0 entries

julia> items = [1,2,3,4,1,2,1]
7-element Array{Int64,1}:
 1
 2
 3
 4
 1
 2
 1

julia> incr!(c,items)

julia> showall(c)
Counter{Int64} with these nonzero values:
Counter{Int64} with these nonzero values:
1 ==> 3
2 ==> 2
3 ==> 1
4 ==> 1
```

In addition, `incr!` may be used to increment one counter
by the amount held in another. Note that it's the first argument `c`
that gets changed; there is no effect on the second argument `d`.

**Note**: `incr!(c,d)` and `c += d` have the same effect, but the first
is more efficient.
```julia
julia> d = Counter{Int}();

julia> d[1] = 1;;

julia> d[5] = 1;

julia> incr!(c,d)

julia> showall(c)
Counter{Int64} with these nonzero values:
1 ==> 4
2 ==> 2
3 ==> 1
4 ==> 1
5 ==> 1
```


#### More functions

* `sum(c)` returns the sum of the values in `c`; that is, the total
of all the counts.
* `length(c)` returns the number of values held in `c`. Note that
this might include objects with value `0`.
* `nnz(c)` returns the number of nonzero values held
in `c`.
* `keys(c)` returns an iterator for the keys held by `c`.
* `values(c)` returns an iterator for the values held by `c`.
* `showall(c)` gives a print out of all the keys and their nonzero
values in `c`.
* `clean!(c)` removes all keys from `c` whose value is `0`. This
won't change its behavior, but will free up some memory.

In addition, we can convert a `Counter` into a one-dimensional
array in which each element appears with its appropriate multiplicity
using `collect`:

```julia
julia> C = Counter{Int}()
SimpleTools.Counter{Int64} with 0 entries

julia> C[3] = 4
4

julia> C[5] = 0
0

julia> C[-2] = 2
2

julia> collect(C)
6-element Array{Int64,1}:
  3
  3
  3
  3
 -2
 -2

julia> collect(keys(C))
3-element Array{Int64,1}:
  3
 -2
  5
```

#### Average value

If the objects counted in `C` are numbers, then we compute the weighted
average of those numbers with `mean(C)`.
```julia
julia> C = Counter{Int}()
SimpleTools.Counter{Int64} with 0 entries

julia> C[2] = 3
3

julia> C[3] = 7
7

julia> mean(C)
2.7
```

#### It's `Associative`

A `Counter` is a subtype of `Associative` and therefore we can
use methods such as `keys` and/or `values` to get iterators to
those items.

#### CSV Printing
The function `csv_print` writes a `Counter` to the screen in
comma-separated format. This can be readily used for importing
into a spreadsheet.
```julia
julia> C = Counter{Float64}()
SimpleTools.Counter{Float64} with 0 entries

julia> C[3.4]=10
10

julia> C[2.2]=3
3

julia> csv_print(C)
2.2, 3
3.4, 10
```



#### Counting in parallel

See the `parallel-example` directory for an illustration of how to
use `Counters` in multiple parallel processes.
