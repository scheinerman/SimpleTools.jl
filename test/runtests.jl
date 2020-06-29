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


y1 = [x^2 for x=0:.01:3]
y2 = [mod(y,1) for y in y1 ]
make_continuous!(y2,1)
@test y1==y2

@test flush_print(23,5) == "   23"
@test flush_print(23,5,false) == "23   "

A = dcat(1,1,1)
M = [1 0 0 ; 0 1 0 ; 0 0 1]
@test A==M

@test sage(A)==nothing

@test sum(eye(5)) == 5
@test cofactor_det(2eye(Int,3))==8

using Polynomials
x = Polynomial([0,1])
A = [1 1; 3 2]
@test char_poly(A) == (x-1)*(x-2)-3

A = rand(Int,4,4) .% 100
@test cofactor_det(A) == int_det(A)
