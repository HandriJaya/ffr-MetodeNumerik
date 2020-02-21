function diffusion_1d_implicit( α, xf, tf, u0x, bx0, bxf, Nx, Nt )

    Δx = xf/(Nx-1)
    x = collect(range(0.0, stop=xf, length=Nx))

    Δt = tf/(Nt-1)
    t = collect(range(0.0, stop=tf, length=Nt))

    u = zeros(Float64, Nx, Nt)

    # Initial condition
    for i in 1:Nx
        u[i,1] = u0x(x[i])
    end

    # Boundary condition
    for k in 1:Nt
        u[1,k] = bx0(t[k])
        u[Nx,k] = bxf(t[k])
    end

    F = α*Δt/Δx^2

    # Build matrix A and vector b
    A = zeros(Float64, Nx, Nx)
    b = zeros(Float64, Nx)
    for i in 2:Nx-1
        A[i,i] = 1 + 2*F
        A[i,i-1] = -F
        A[i,i+1] = -F
    end
    A[1,1] = 1.0
    A[Nx,Nx] = 1.0

    for n in 2:Nt
        for i in 2:Nx-1
            b[i] = u[i,n-1]
        end
        b[1] = 0.0
        b[Nx] = 0.0
        # Solve the linear equations
        u[:,n] = A\b
    end
    return u, x, t

end