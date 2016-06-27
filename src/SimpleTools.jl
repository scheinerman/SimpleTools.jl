"""
`SimpleTools` is a collection of useful functions that don't have an
obvious home, but are useful for my `SimpleWorld` modules.
"""
module SimpleTools

export random_choice

"""
`random_choice(weights)` randomly chooses a value from `1` to `n`,
where `n` is the number of elements in `weights`. The probability
that `k` is chosen is proportional to `weights[k]`. The `weights`
must be nonnegative and not all zero.

`random_choice(dict)` choose a random key `k` from `dict` with weight
proportional to `dict[k]`. Thus, `dict` must be of type
`Dict{S, T<:Real}`.
"""
function random_choice{T<:Real}(weights::Vector{T})
  vals = cumsum(weights)
  vals /= vals[end]
  idx = rand()
  for k=1:length(vals)
    @inbounds if idx <= vals[k]
      return k
    end
  end
  error("Impropper input")
end

function random_choice{S,T<:Real}(d::Dict{S,T})
  ks = collect(keys(d))
  n = length(ks)
  wts = [ d[ks[j]] for j=1:n ]
  idx = random_choice(wts)
  return ks[idx]
end

end # end of module
