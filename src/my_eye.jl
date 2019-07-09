export eye

"""
`eye(T,n)` returns an `n`-by-`n` identity matrix whose entries
are numbers of type `T` (`Float64` by default).
"""
function eye(T,n)
    A = zeros(T,n,n)
    for j=1:n
        A[j,j] = 1
    end
    return A
end

eye(n) = eye(Float64,n)
