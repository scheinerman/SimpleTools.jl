export Counter, clean!, incr!

import Base.show, Base.length, Base.getindex, Base.sum, Base.keys
import Base.+, Base.showall, Base.setindex!, Base.==
import Base.nnz
import Base.start, Base.done, Base.next

"""
A `Counter` is a device for keeping a count of how often we observe
various objects. It is created by giving a type such as
`c=Counter{String}()`.

Counts are retrieved with square brackets like a dictionary: `c["hello"]`.
It is safe to retrieve the count of an object never encountered, e.g.,
`c["goodbye"]`; in this case `0` is returned.

Counts may be assigned with `c[key]=amount`, but the more likely use
case is using `c[key]+=1` to count each time `key` is encountered.
"""
type Counter{T<:Any} <: Associative{T,Int}
  data::Dict{T,Int}
  function Counter()
    d = Dict{T,Int}()
    C = new(d)
  end
end

Counter() = Counter{Any}()

# These items enable this to satisfy the Associative properties

start(c::Counter) = start(c.data)
done(c::Counter,s) = done(c.data,s)
next(c::Counter,s) = next(c.data,s)

"""
`length(c::Counter)` gives the number of entries monitored
by the Counter. Conceivably, some may have value `0`.
"""
length(c::Counter) = length(c.data)

function show{T}(io::IO, c::Counter{T})
  n = length(c.data)
  word = ifelse(n==1, "entry", "entries")
  msg = "with $n $word"
  print(io,"Counter{$T} $msg")
end

"""
`showall(c::Counter)` displays all the objects
held in the Counter and their counts.
"""
function showall{T}(io::IO, c::Counter{T})
  println(io,"Counter{$T} with these nonzero values:")
  for k in keys(c)
    if c[k] != 0
      println(io,"$k ==> $(c.data[k])")
    end
  end
end

function getindex{T}(c::Counter{T}, x::T)
  try
    return c.data[x]
  end
  return 0
end

"""
`keys(c::Counter)` returns an interator for the things counted by `c`.
"""
keys(c::Counter) = keys(c.data)


"""
`sum(c::Counter)` gives the total of the counts for all things
in `c`.
"""
sum(c::Counter) = sum(values(c.data))

"""
`nnz(c::Counter)` gives the number of keys in
the `Counter` with nonzero value.
"""
function nnz(c::Counter)
  amt::Int = 0
  for k in keys(c)
    if c.data[k] != 0
      amt += 1
    end
  end
  return amt
end

setindex!{T}(c::Counter{T}, val::Int, k::T) = c.data[k] = val

function =={T}(c::Counter{T}, d::Counter{T})
  for k in keys(c)
    if c[k] != d[k]
      return false
    end
  end

  for k in keys(d)
    if c[k] != d[k]
      return false
    end
  end

  return true
end

isequal{T}(c::Counter{T},d::Counter{T}) = c==d

"""
`clean!(c)` removes all keys from `c` whose value is `0`.
Generally, it's not necessary to invoke this unless one
suspects that `c` contains *a lot* of keys associated with
a zero value.
"""
function clean!{T}(c::Counter{T})
  for k in keys(c)
    if c[k] == 0
      delete!(c.data,k)
    end
  end
  nothing
end

"""
If `c` and `d` are `Counter`s, then `c+d` creates a new `Counter`
in which the count associated with an object `x` is `c[x]+d[x]`.
"""
function (+){T}(c::Counter{T}, d::Counter{T})
  result = deepcopy(c)
  for k in keys(d)
    val = d[k]
    if val != 0
      result[k] += val
    end
  end
  return result
end


incr!{T}(c::Counter{T}, x::T) = c[x] += 1

function incr!(c::Counter, items)
  for x in items
    c[x] += 1
  end
end
