module CoefFromFunc

function coef_from_func(func, delta, size)
    center = float(size-1)/2
    return [func((i - center)*delta) for i in 0:size-1]
end

export coef_from_func

end
