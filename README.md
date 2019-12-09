# SimpleTools

Miscellaneous code that is possibly useful for my `SimpleWorld` modules.


## Composition of Dictionaries

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

## Continuity restored

If one records the angle of a tangent vector as it traverses around a smooth closed
curve, the values should be continuous. However, because there is a 2π ambiguity,
one could see jumps. Here is an example.

![](discon.png)

If the angles are held in an array named `y` then the following will
correct the problem.
```
julia> make_continuous!(y,2pi)
```
The resulting graph looks like this:

![](con.png)


## Flush printing

The `flush_print` function right (or left) justifies its argument in a
`String` of a given number of characters.


+ `flush_print(x,width)` returns a `String` version of `x` right justified
in a string of length `width`.
+ Use `flush_print(x,width,false)` for left-justified.


```
julia> flush_print("hello", 10)
"     hello"

julia> flush_print("hello", 10, false)
"hello     "

julia> flush_print(sqrt(10),30)
"            3.1622776601683795"

julia> flush_print(sqrt(10),5)
┌ Warning: Trunctated to fit width
└ @ SimpleTools ~/.julia/dev/SimpleTools/src/flush_print.jl:9
"3.162"
```

## Print matrices for inclusion in *Sage*

The `sage` function takes a one or two-dimensional matrix and outputs it
in a way that can be copied and pasted into a *Sage* session.

```julia
julia> v = collect(1:5)
5-element Array{Int64,1}:
 1
 2
 3
 4
 5

julia> sage(v)
Matrix([[1],[2],[3],[4],[5]])
```

```sage
sage: Matrix([[1],[2],[3],[4],[5]])
....:
[1]
[2]
[3]
[4]
[5]
sage:
```

## My `eye`

Y-O-Y did the Julia developers remove `eye`? Restored here with `eye(T,n)`
giving an `n`-by-`n` identity matrix with entries of type `T`. A plain
`eye(n)` gives a `Float64` identity matrix (to match `ones` and `zeros`).

## Alternative determinants

#### Exact determinant of integer (or Gaussian integer) matrices

`int_det(A)` returns the exact determinant of the matrix `A` where `A` is populated
either with integers or Gaussian integers. The result is either a `BigInt`
or a `Complex{BigInt}`, respectively.

```
julia> A = rand(Int,10,10) .% 100
10×10 Array{Int64,2}:
 -94   61   88   54  -57  -40  -31    9  -82   36
 -60   56    8  -60  -54  -49  -67  -12    9   36
  -8  -14   87  -27   58  -92  -51   88   64   23
  15   59   85  -98   42   -7  -56   83  -14  -39
 -28   61  -58   28   32  -14   55   51  -60  -22
 -72   99  -39  -84   41   -1   85  -48   75  -85
  98   63  -50   96  -35  -56   39   30   77  -14
 -90   49   54  -18   71  -24  -13   10   31   92
 -76   54   41   85   48  -14  -53   10  -24   52
  13   84   26  -71   84   63   81  -12   86   24

julia> int_det(A)
123623256506197219738

julia> det(A)
1.2362325650619746e20
```

#### Rational matrices

For matrices with integer or rational (or complex integer/rational) entries,
one may use `rational_det`.

#### Cofactor expansion


`cofactor_det(A)`  returns the determinant of the matrix `A`. The return type
matches the entry type in `A`. This is *much* slower than Julia's `det` function
or the `int_det` and `rational_det` functions in this module.

However, it has the advantage that it can handle matrices with, for example, polynomial
entries.
```
julia> using Polynomials

julia> x = Poly([0,1])
Poly(x)

julia> A = Matrix{Poly{Int}}(undef,2,2);

julia> A[1,1] = x-2; A[1,2] = x*x; A[2,1] = x+4; A[2,2] = 3x-1;

julia> A
2×2 Array{Poly{Int64},2}:
 Poly(-2 + x)  Poly(x^2)     
 Poly(4 + x)   Poly(-1 + 3*x)

julia> cofactor_det(A)
Poly(2 - 7*x - x^2 - x^3)

julia> (x-2)*(3x-1) - (x^2)*(x+4)
Poly(2 - 7*x - x^2 - x^3)
```





## Characteristic polynomial

`char_poly(A)` returns the characteristic polynomial of the matrix `A`:
```
julia> A = [1 2; 3 4]
2×2 Array{Int64,2}:
 1  2
 3  4

julia> char_poly(A)
Poly(-2 - 5*x + x^2)

julia> roots(ans)
2-element Array{Float64,1}:
  5.372281323269014
 -0.3722813232690143

julia> using LinearAlgebra

julia> eigvals(A)
2-element Array{Float64,1}:
 -0.3722813232690143
  5.372281323269014
```
Note: This is a horrible way to get the eigenvalues of a matrix.

## Block diagonal concatenation of matrices

For matrices `A` and `B` the function `dcat(A,B)` returns a new matrix of the
form `[A 0; 0 B]` where the two `0`s are zero blocks of the appropriate size.
The function `dcat` can be called with any positive number of arguments.
```julia
julia> A = ones(Int,2,3)
2×3 Array{Int64,2}:
 1  1  1
 1  1  1

julia> dcat(A,2A)
4×6 Array{Int64,2}:
 1  1  1  0  0  0
 1  1  1  0  0  0
 0  0  0  2  2  2
 0  0  0  2  2  2

julia> dcat(A,2A')
5×5 Array{Int64,2}:
 1  1  1  0  0
 1  1  1  0  0
 0  0  0  2  2
 0  0  0  2  2
 0  0  0  2  2

julia> dcat(A,2A,3A)
6×9 Array{Int64,2}:
 1  1  1  0  0  0  0  0  0
 1  1  1  0  0  0  0  0  0
 0  0  0  2  2  2  0  0  0
 0  0  0  2  2  2  0  0  0
 0  0  0  0  0  0  3  3  3
 0  0  0  0  0  0  3  3  3
```
