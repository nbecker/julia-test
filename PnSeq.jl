module PnSeq

type pnseq
    cache::Int64
    count::Int64
    width::Int64
    mask::Int64
    pnseq(width) = new(0, 0, width,~(-1<<width))
end

function(p::pnseq)(n,T=Int64)
    out = Array{T}(n)
    for i in eachindex(out)
        if p.count < p.width
            p.cache = rand(Int64)
            p.count = 64
        end
        out[i] = p.cache & p.mask
        p.cache >>= p.width
        p.count -= p.width
    end
    return out
end

export pnseq

end
