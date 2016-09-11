export Counter, incr!, reset!

import Base.show, Base.length, Base.getindex, Base.sum, Base.keys
import Base.+, Base.showall

"""
A `Counter` is a device for keeping a count of how often we observe
various objects. It is created by giving a type such as
`c=Counter(ASCIIString)`. Counts are incremented with the
`incr!` function like this: `incr!(c,"hello")`. Counts are retrieved
with square brackets like a dictionary: `c["hello"]`. It is safe
to retrieve the count of an object never encountered, e.g.,
`c["goodbye"]`; in this case `0` is returned.
"""
type Counter{T}
  data::Dict{T,Int}
end

Counter(dt::DataType) = Counter(Dict{dt,Int}())
Counter() = Counter(Any)


"""
`length(c::Counter)` gives the number of entries monitored
by the counter. Conceivably, some may have value `0`.
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
held in the counter and their counts.
"""
function showall{T}(io::IO, c::Counter{T})
  println(io,"Counter{$T} with these values:")
  for k in keys(c)
    println(io,"$k ==> $(c.data[k])")
  end
end


function getindex{T}(c::Counter{T}, x::T)
  if haskey(c.data,x)
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
`incr!(c,x)` increments the value associated with `x` in the
Counter `x`. Note we do *not* need to initialize `c[x]` in any
way. If `x` has not been previously counted, this sets the count
to `1`. This can be called with an optional third argument,
`incr!(c,x,amt)` in which case `c[x]` in increased by `amt`.
"""
function incr!{T}(c::Counter{T}, x::T, amt::Int=1)
  if haskey(c.data,x)
    c.data[x] += amt
  else
    c.data[x] = amt
  end
  nothing
end

"""
`reset!(c)` sets all counts in `c` to `0`
"""
function reset!{T}(c::Counter{T}, x::T)
  if haskey(c.data,x)
    c[x] = 0
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
    incr!(result,k,d[k])
  end
  return result
end
