@eval module $(gensym())
using UnallocatedArrays: UnallocatedArrays
using Test: @test, @testset

@testset "examples" begin
  include(joinpath(pkgdir(UnallocatedArrays), "examples", "README.jl"))
end
end
