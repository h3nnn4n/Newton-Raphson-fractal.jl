function df(x, h)
    return (f(x + h) - f(x - h)) / (2h)
end

function r(x, h)
    return (4df(x, h/4.0) - df(x, h/2.0)) / 3.0
end

function newton(f, x = 0.1, iters = 100, h = 10.0^-4)
    xn = x

    for i in 1:iters
        xn = x - f(x)/r(x, h)

        if x == xn
            return (x, i)
        else
            x = xn
        end
    end

    return (xn, iters)
end
