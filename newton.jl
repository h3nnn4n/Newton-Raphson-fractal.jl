screenx =  800
screeny =  600

iters   =  200

xcenter =  0.5
ycenter =  0.5

xzoom   =  0.5
yzoom   =  0.5

xcenter =  0.0
ycenter =  0.0

xzoom   =  1.0
yzoom   =  1.0

minx    =  (xcenter + xzoom)
maxx    =  (xcenter - xzoom)
miny    =  (ycenter + yzoom)
maxy    =  (ycenter - yzoom)

function f(x)
    return x^3 + x^2 - 1
    #=return x^8 + 15x^4 - 16=#
end

function df(x, h)
    return (f(x + h) - f(x - h)) / (2h)
end

function r(x, h)
    return (4df(x, h/4.0) - df(x, h/2.0)) / 3.0
end

function newton(x)
    h = 0.001

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

function ppm_write(img)
    out = open("out.ppm", "w")

    write(out, "P6\n")
    x, y = size(img)
    write(out, "$x $y 255\n")

    for j = 1:y, i = 1:x
        p = img[i,j]

        if p == (0,0,0)
            write(out, uint8(0))
            write(out, uint8(0))
            write(out, uint8(0))
        else
            #=write(out, uint8(255))=#
            #=write(out, uint8(255))=#
            #=write(out, uint8(255))=#
            write(out, uint8(p[1]))
            write(out, uint8(p[2]))
            write(out, uint8(p[3]))
        end
    end
end

function main()
    bitmap_color = Array((Int, Int, Int) , (screenx, screeny))
    roots        = Complex[]
    nroot        = 0
    rootIndex    = 1

    colors = Array((Int, Int, Int), 9)

    colors[1] = ( 30, 200,  90)
    colors[2] = ( 60, 220, 210)
    colors[3] = (140,  60, 225)
    colors[4] = (106, 220,  60)
    colors[5] = (220, 100,  60)
    colors[6] = (170,  30, 150)
    colors[7] = ( 30,  30, 170)
    colors[8] = (210, 230,  30)
    colors[9] = ( 95, 125,  85)

    for x in 1:screenx, y in 1:screeny
        real = minx + x*(maxx-minx)/screenx
        imag = miny + y*(maxy-miny)/screeny

        c = Complex(real, imag)

        root, time = newton(c)

        new = true

        if nroot > 0
            for i in 1:nroot 
                rootIndex = i
                if abs((roots[i]) - (root)) <= 10.0^-4
                    new = false
                    break
                end
            end
        end

        if new
            nroot += 1
            push!(roots, root)
            println("#$nroot New root: ", root)
        end

        color = [0, 0, 0]
        for j in 1:3
            coef = (iters / time) * 25.0
            if coef > 25.0
            :Wa
            :Wa
                coef = 25.0
            end
            color[j] = int(colors[rootIndex][j] - coef)
            if color[j] <= 0
                color[j] = 0
            end
        end

        bitmap_color[x, y] = (color[1], color[2], color[3])
    end

    ppm_write(bitmap_color)

end

main()

