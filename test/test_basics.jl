using FillArrays: FillArrays, AbstractFill, Fill, Zeros
using JLArrays: @allowscalar, JLArray
using LinearAlgebra: norm
using Test: @test, @test_broken, @testset
using UnallocatedArrays:
  UnallocatedFill, UnallocatedZeros, allocate, alloctype, set_alloctype

const arrayts = (Array, JLArray)
const elts = (Float64, Float32, Complex{Float64}, Complex{Float32})
@testset "Testing UnallocatedArrays on $arrayt with eltype $elt" for arrayt in arrayts,
  elt in elts

  (Float64, Float32, ComplexF64, ComplexF32)

  @testset "Basic funcitonality" begin
    z = Zeros{elt}((2, 3))
    Z = UnallocatedZeros(z, arrayt{elt,2})

    @test Z isa AbstractFill
    @test size(Z) == (2, 3)
    @test length(Z) == 6
    @test iszero(sum(Z))
    @test iszero(norm(Z))
    @test iszero(Z[2, 3])
    x = randn(elt, 2, 3)
    x′ = allocate(x)
    @test x === x′
    a = allocate(z)
    @test iszero(a)
    @test a isa Matrix{elt}
    a = allocate(Z)
    @test iszero(a)
    @test a isa arrayt{elt,2}
    Zp = UnallocatedZeros{elt}(Zeros(2, 3), arrayt{elt,2})
    @test Zp == Z
    Zp = set_alloctype(z, arrayt{elt,2})
    @test Zp == Z
    Zc = copy(Z)
    @test Zc == Z
    Zc = complex(Z)
    @test eltype(Zc) == complex(eltype(z))
    @test iszero(Zc[1, 2])
    @test Zc isa UnallocatedZeros
    @test alloctype(Zc) == alloctype(Z)

    Zs = similar(Z)
    @test Zs isa alloctype(Z)

    Z = UnallocatedZeros(z, arrayt)
    Za = allocate(Z)
    @test Za isa arrayt{elt,2}
    @test @allowscalar(Za[1, 3]) == zero(elt)

    #########################################
    # UnallocatedFill
    f = Fill{elt}(3, (2, 3, 4))
    F = UnallocatedFill(f, Array{elt,ndims(f)})

    @test F isa AbstractFill
    @test size(F) == (2, 3, 4)
    @test length(F) == 24
    @test sum(F) ≈ elt(3) * 24
    @test norm(F) ≈ sqrt(elt(3)^2 * 24)
    @test F[2, 3, 1] == elt(3)
    @test allocate(F) isa Array{elt,3}
    Fp = UnallocatedFill{elt}(Fill(3, (2, 3, 4)), Array{elt,ndims(f)})
    @test Fp == F
    Fp = allocate(F)
    @test norm(Fp) ≈ norm(F)
    Fs = similar(F)
    @test Fs isa alloctype(F)
    @test length(Fs) == 2 * 3 * 4
    Fs[1, 1, 1] = elt(10)
    @test Fs[1, 1, 1] == elt(10)

    Fp = set_alloctype(f, arrayt{elt,ndims(f)})
    @test allocate(Fp) isa arrayt{elt,ndims(f)}
    @test Fp == F
    Fc = copy(F)
    @test Fc == F
    Fc = allocate(complex(F))
    @test eltype(Fc) == complex(eltype(F))
    ## Here we no longer require the eltype of the alloctype to
    ## Be the same as the eltype of the `UnallocatedArray`. It will be
    ## replaced when the array is allocated
    # @test_broken typeof(Fc) == alloctype(complex(F))
    Fc[2, 3, 4] = elt(0)
    @test iszero(Fc[2, 3, 4])

    F = UnallocatedFill(f, arrayt)
    Fa = allocate(F)
    @test Fa isa arrayt{elt,3}
    @test @allowscalar(Fa[2, 1, 4]) == elt(3)

    F = UnallocatedFill(f, arrayt{<:Any,1})
    Fa = allocate(F)
    @test ndims(Fa) == 3
    @test Fa isa arrayt
  end

  @testset "Multiplication" begin
    z = Zeros{elt}((2, 3))
    Z = UnallocatedZeros(z, arrayt{elt,2})

    R = Z * Z'
    @test R isa UnallocatedZeros
    @test alloctype(R) == alloctype(Z)
    @test size(R) == (2, 2)
    M = rand(elt, (3, 4))
    R = Z * M
    @test R isa UnallocatedZeros
    @test alloctype(R) == alloctype(Z)
    @test size(R) == (2, 4)
    R = M' * Z'
    @test R isa UnallocatedZeros
    @test alloctype(R) == alloctype(Z)
    @test size(R) == (4, 2)
    R = transpose(M) * transpose(Z)
    @test R isa UnallocatedZeros
    @test alloctype(R) == alloctype(Z)
    @test size(R) == (4, 2)

    ###################################
    ## UnallocatedFill
    f = Fill{elt}(3, (2, 12))
    F = UnallocatedFill(f, arrayt{elt,2})
    p = Fill{elt}(4, (12, 5))
    P = UnallocatedFill(p, arrayt{elt,ndims(p)})
    R = F * P
    @test F isa UnallocatedFill
    @test R[1, 1] == elt(144)
    @test alloctype(R) == alloctype(F)
    @test size(R) == (2, 5)

    R = F * F'
    @test R isa UnallocatedFill
    @test R[1, 2] == elt(108)
    @test alloctype(R) == alloctype(F)
    @test size(R) == (2, 2)

    R = transpose(F) * F
    @test R isa UnallocatedFill
    @test R[12, 3] == elt(18)
    @test alloctype(R) == alloctype(F)
    @test size(R) == (12, 12)

    R = transpose(Z) * F
    @test R isa UnallocatedZeros
    @test alloctype(R) == alloctype(Z)
    @test size(R) == (3, 12)
  end

  @testset "Broadcast" begin
    z = Zeros{elt}((2, 3))
    Z = UnallocatedZeros(z, arrayt{elt,2})
    R = elt(2) .* Z
    @test R isa UnallocatedZeros
    @test alloctype(R) == alloctype(Z)
    R = Z .* elt(2)
    @test R isa UnallocatedZeros
    @test alloctype(R) == alloctype(Z)

    R = Z .* Z
    @test R isa UnallocatedZeros
    @test alloctype(R) == alloctype(Z)

    Z = UnallocatedZeros(Zeros{elt}((2, 3)), arrayt{elt,2})
    R = Z + Z
    @test R isa UnallocatedZeros
    @test alloctype(R) == alloctype(Z)

    R = Z .+ elt(2)
    @test R isa UnallocatedFill
    @test alloctype(R) == alloctype(Z)

    R = (x -> x .+ 1).(Z)
    @test R isa UnallocatedFill
    @test alloctype(R) == alloctype(Z)
    @test R[1, 1] == elt(1)

    Z .*= 1.0
    @test Z isa UnallocatedZeros
    @test alloctype(R) == arrayt{elt,2}
    @test Z[2, 1] == zero(elt)
    ########################
    # UnallocatedFill
    f = Fill(elt(3), (2, 3, 4))
    F = UnallocatedFill(f, Array{elt,ndims(f)})
    F2 = F .* 2
    @test F2 isa UnallocatedFill
    @test F2[1, 1, 1] == elt(6)
    @test alloctype(F2) == alloctype(F)

    F2 = F2 .+ elt(2)
    @test F2 isa UnallocatedFill
    @test F2[1, 1, 1] == elt(8)
    @test alloctype(F2) == alloctype(F)

    F = UnallocatedFill(Fill(elt(2), (2, 3)), arrayt{elt,2})
    R = Z + F
    @test R isa UnallocatedFill
    @test alloctype(R) == alloctype(Z)

    R = F + Z
    @test R isa UnallocatedFill
    @test alloctype(R) == alloctype(Z)

    F = UnallocatedFill(Fill(elt(3), (2, 12)), arrayt{elt,2})
    R = F .* F
    @test R isa UnallocatedFill
    @test R[2, 9] == elt(9)
    @test alloctype(R) == alloctype(F)
    @test size(R) == (2, 12)

    P = UnallocatedFill(Fill(elt(4), (2, 3)), arrayt{elt,2})
    R = Z .* P
    @test R isa UnallocatedZeros
    @test alloctype(R) == alloctype(P)
    @test size(R) == (2, 3)

    F = UnallocatedFill(Fill(elt(2), (2, 3)), arrayt{elt,2})
    R = F + F
    @test R isa UnallocatedFill
    @test R[1, 3] == elt(4)

    R = (x -> x .+ 1).(F)
    @test R isa UnallocatedFill
    @test R[2, 1] == elt(3)
    @test alloctype(R) == alloctype(F)
  end

  ## TODO make other kron tests
  @testset "Kron" begin
    A = UnallocatedZeros(Zeros{elt}(2), arrayt{elt,1})
    B = UnallocatedZeros(Zeros{elt}(2), arrayt{elt,1})
    C = kron(A, B)
    @test C isa UnallocatedZeros
    @test alloctype(C) == alloctype(B)

    B = UnallocatedFill(Fill(elt(2), (2)), arrayt{elt,1})
    C = kron(A, B)
    @test C isa UnallocatedZeros
    @test alloctype(C) == alloctype(B)

    C = kron(B, A)
    @test C isa UnallocatedZeros
    @test alloctype(C) == alloctype(B)

    A = UnallocatedFill(Fill(elt(3), (2)), arrayt{elt,1})
    C = kron(A, B)
    @test C isa UnallocatedFill
    @test alloctype(C) == alloctype(B)
    @test C[1] == elt(6)
  end
end
