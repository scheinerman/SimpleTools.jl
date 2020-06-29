using Polynomials
export char_poly
"""
`char_poly(A::Matrix)` returns the characteristic polynomial
of the matrix `A`.
"""
function char_poly(A::Matrix{T}) where T
    r,c = size(A)
    @assert r==c "Matrix must be square"

    L = zeros(Polynomial{T},r,r)
    x = Polynomial{T}([0,1])
    for i=1:r
        L[i,i] = x
    end

    cofactor_det(L-A)
end
