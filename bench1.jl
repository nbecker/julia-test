using Nyquist: RNyquistPulse
using CoefFromFunc: coef_from_func

p = RNyquistPulse(0.5)
sps = 4
si = 16
c = coef_from_func(p, 1./sps, sps*si)

using DSP: FIRFilter, setphase!

function (f::FIRFilter)(x)
    return filt(f, x)
end

xfilt = FIRFilter(c, sps//1)
rfilt = FIRFilter(c/sps, 1//sps)
setphase!(rfilt, 3)

using Constellation
using PnSeq

p = pnseq(2)
Const = QPSKconstellation()

power(u) = norm(u)^2/length(u)

function test1()
    xsyms = p(1000000)
    xconst = Const(xsyms)
    xmit_out = xfilt(xconst)
    delay = si-1
    rcv_out = rfilt(xmit_out)[delay+1:end]

# using PyPlot
# plot(real(xconst), "x-")
# plot(real(rcv_out), "x-")

    err = xconst[1:length(rcv_out)] - rcv_out
    return power(err)
end

function test2(N)
    for _ in 1:N
        mse = test1()
    end
end
