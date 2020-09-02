import Base.mod

function mod(z::Complex{T}, m::Integer) where T<:Integer 
    a,b = reim(z)
    return mod(a,m) + mod(b,m)*im 
end 