function heat_1d_euler_exp( α, xf, tf, u0x, bx0, bxf, Nx, Nt )
    
    dx = xf/(Nx-1)
    x = collect(range(0.0, stop=xf, length=Nx))
    
    dt = tf/(Nt-1)
    t = collect(range(0.0, stop=tf, length=Nt))

    u = zeros( Float64, Nx, Nt)
    
    # Aplikasi syarat awal
    for i in 1:Nx
        u[i,1] = u0x( x[i] )
    end
    
    # Syarat batas
    for k in 1:Nt
        u[1,k] = bx0( t[k] )
        u[Nx,k] = bxf( t[k] )
    end
    
    r = α*dt/dx^2
    
    if r > 0.5
        @printf("heat_1d_euler_exp:\n")
        @printf("WARNING: r lebih besar dari 0.5: %f\n", r)
        @printf("WARNING: solusi tidak stabil !!\n")
    else
        @printf("heat_1d_euler_exp:\n")
        @printf("r = %f >= 0.5\n", r)
        @printf("Solusi seharusnya stabil\n")
    end

    for k in 1:Nt-1
        for i in 2:Nx-1
            u[i,k+1] = r*( u[i+1,k] + u[i-1,k] ) + (1 - 2*r)*u[i,k]
        end
    end
    
    return u, x, t

end