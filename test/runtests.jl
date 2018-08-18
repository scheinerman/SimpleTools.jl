using Test
using SimpleTools

sq = Dict{Int,Int}()
for k=1:10
    sq[k] = k*k
end

rt = Dict{Int,Int}()
for k=1:10
    rt[k*k] = k
end

f = rt*sq
for k=1:10
    @test f[k] == k
end 
