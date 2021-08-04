export dcat

"""
`dcat(A,B)` diagonally concatenate matrices `A` and `B`.
Returns a new matrix of the form `[A 0; 0 B]` where the `0`s
are blocks of zeros of the approriate shape.

More generally, may be called with any positive number of matrix, vector,
or scalar (numeric) arguments.
"""
function dcat(A::Array{S,2}, B::Array{T,2}) where {S,T}
    ST = promote_type(S, T)

    ra, ca = size(A)
    rb, cb = size(B)

    Z1 = zeros(ST, ra, cb)
    Z2 = zeros(ST, rb, ca)

    return [A Z1; Z2 B]
end


dcat(A) where {S} = _matrixify(A)

function dcat(A, B, C...)
    AB = dcat(A, B)
    return dcat(AB, C...)
end


function _matrixify(v::Array{T,1}) where {T}
    n = length(v)
    return reshape(v, n, 1)
end

_matrixify(x::T) where {T<:Number} = _matrixify([x])

_matrixify(A::Array{T,2}) where {T} = A

function dcat(v::T, A::Matrix{S}) where {S,T}
    return dcat(_matrixify(v), A)
end

function dcat(A::Matrix{S}, v::T) where {S,T}
    return dcat(A, _matrixify(v))
end

function dcat(x::T, y::S) where {S,T}
    return dcat(_matrixify(x), _matrixify(y))
end
