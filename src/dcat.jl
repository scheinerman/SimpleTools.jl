export dcat

"""
`dcat(A,B)` diagonally concatenate matrices `A` and `B`.
Returns a new matrix of the form `[A 0; 0 B]` where the `0`s
are blocks of zeros of the approriate shape.

More generally, may be called with any positive number of matrix
arguments.
"""
function dcat(A::Array{S,2}, B::Array{T,2}) where {S,T}
    ST = promote_type(S,T)

    ra,ca = size(A)
    rb,cb = size(B)

    Z1 = zeros(ST,ra,cb)
    Z2 = zeros(ST,rb,ca)

    return [A Z1; Z2 B]
end


dcat(A::Array{S,2}) where S = A

function dcat(A::Array{S,2}, B::Array{T,2}, C...) where {S,T}
    AB = dcat(A,B)
    return dcat(AB,C...)
end
