"""
`sage(A)` takes a one- or two-dimensional array and prints it in a form
that can be pasted into SageMath.
"""
function sage(A::Array{T,2}) where T
    r,c = size(A)
    println("Matrix([")
    for i=1:r
        print("[")
        for j=1:c
            print(A[i,j])
            if j<c
                print(",")
            else
                print("]")
            end
        end
        if i<r
            println(",")
        else
            println("])")
        end
    end
end


function sage(A::Array{T,1}) where T
    n = length(A)
    print("Matrix([")
    for i=1:n
        print("[$(A[i])]")
        if i<n
            print(",")
        else
            println("])")
        end
    end
end
