export xdet, rational_det

"""
`rational_det(A)` computes the determinant of the matrix `A`.
We assume that the entries in `A` are either in `Q` or `Q[i]`
(`a` or `a+b*im` where `a` and `b` are rational).

The result is a `Rational{BigInt}` or a `Rational{Complex{BigInt}}`.
"""
function rational_det(A::Matrix{T}) where T
    r,c = size(A)
    @assert r==c "Matrix must be square"

    A = big.(A)//1 # so we're working on a "big" copy

    if r==0
        return one(T)//1
    end

    if r==1
        return A[1,1]//1
    end

    # if first column is all zeros ...
    if all(A[:,1] .== 0)
        return zero(T)//1
    end

    # find first nonzero entry in column 1
    idx = 1
    while A[idx,1] == 0
        idx += 1
    end

    # divide out that row by A[idx,1]
    factor = A[idx,1]
    A[idx,:] //= factor

    # now use A[idx,1] to pivot
    for i=1:r
        if i!=idx && A[i,1] != 0
            A[i,:] += -A[idx,:]*A[i,1]
        end
    end


    B = A[cat(1:idx-1,idx+1:r,dims=1),2:end]

    return factor * rational_det(B)
end

"""
`xdet(A)` gives the exact determinant of a matrix populated with
integers or Gaussian integers. The return type is either
`BigInt` or `Complex{BigInt}`, respectively.
"""
function xdet(A::Matrix{T})::BigInt where T<:Integer
    dA = rational_det(A)
    return BigInt(dA)
end


function xdet(A::Matrix{Complex{T}})::Complex{BigInt} where T<:Integer
    dA = rational_det(A)
    return Complex{BigInt}(dA)
end
