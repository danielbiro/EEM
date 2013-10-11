flatten{T}(a::Array{T,1}) = any(map(x->isa(x,Array),a))? flatten(vcat(map(flatten,a)...)): a
flatten{T}(a::Array{T}) = reshape(a,prod(size(a)))
flatten(a)=a

function gentimestamp()
    dt = now()
    dty = year(dt)
    dtm = month(dt)
    dtd = day(dt)
    dth = hour(dt)
    dtmin = minute(dt)
    dts = second(dt)
    return "$dty$dtm$dtd\_$dth$dtmin$dts"
end

sigmoid(x, a) = 1/(1+exp(-a*x))
sigmoid(x) = 1/(1+exp(-5*x))
