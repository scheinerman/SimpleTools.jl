using SimpleRandom
using SimpleTools

function binomial_counts(n::Int, p::Real, reps::Int)
  c = Counter(Int)
  for k=1:reps
    x = binom_rv(n,p)
    c[x] += 1
  end
  return c
end

function parallel_binomial_counts(n::Int, p::Real, reps::Int, rounds::Int)
  counts = @parallel (+) for k=1:rounds
    binomial_counts(n,p,reps)
  end
  return counts
end
