using Aqua: Aqua
using Test: @testset
using UnallocatedArrays: UnallocatedArrays

@testset "Code quality (Aqua.jl)" begin
    Aqua.test_all(UnallocatedArrays)
end
