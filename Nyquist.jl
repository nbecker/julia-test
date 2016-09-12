module Nyquist

export FNyquistPulse, RNyquistPulse

eps = 1.0e-7

type FNyquistPulse
    alpha
    scale
    deltaT
    T
    FNyquistPulse(alpha, scale=1.0, deltaT=0.0, T=1.0) = new(alpha, scale, deltaT, T)
end

function (p::FNyquistPulse)(t)
    t += p.deltaT
    if (t > -eps && t < eps)
        return p.scale * 1.0
    else
        x = t/p.T
            den = (1. - (2. * p.alpha * x)^2) * pi * x
            if (den > -eps && den < eps)
                return p.scale * p.alpha/2. * sin(pi / (2 * p.alpha))
            else
                num = cos(pi * p.alpha * x) * sin(pi * x)
                return p.scale * num / den;
            end
    end
end


type RNyquistPulse
    alpha
    scale
    deltaT
    T

    RNyquistPulse(alpha, scale=1, deltaT=0, T=1) = new(alpha, scale, deltaT, T)

end

"""
RRC pulse response at time t
:param `t`: time (symbols)
"""
function (p::RNyquistPulse)(t)
    t += p.deltaT
    sqrtT = sqrt(p.T)
    if (abs(t) < eps)
        return p.scale * ((4*p.alpha/pi) + 1 - p.alpha)/sqrtT
    else
        x = t/p.T
        if (p.alpha == 0.0)
            return p.scale * sqrtT * sin( pi * x)/(pi * t)
        else
            oneplus = (1.0+p.alpha)*pi/p.T
            oneminus = (1.0-p.alpha)*pi/p.T;
            ## Check to see whether we will get divide by zero
            den = (t*4*p.alpha)^2 - (p.T)^2
            if (den > -eps && den < eps)
                return p.scale * (p.T * sqrtT/(8 * p.alpha * pi * t)) * (oneplus * sin( oneplus * t) - (oneminus*p.T/(4*p.alpha*t)) * cos(oneminus * t) + (p.T/(4*p.alpha*t*t)) * sin(oneminus * t))
            else
                return p.scale * (4*p.alpha/(pi*sqrtT)) * (cos(oneplus*t) + sin(oneminus*t)/(x*4*p.alpha)) / (1.0 - 16*p.alpha*p.alpha*x*x)
            end
        end
    end

end

end
