module Constellation

type constellation{flt}
    C::Array{Complex{flt},1}
end

function (c::constellation)(xsyms)
    return [c.C[x+1] for x in xsyms]
end

PSKconstellation(N, T=Float64) = constellation{T}([exp(im*2*pi/N*x) for x in 0:N-1])

QPSKconstellation(T=Float64) = PSKconstellation(4, T)

export constellation, QPSKconstellation, PSKconstellation



end
