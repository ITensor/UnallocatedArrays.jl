@eval module $(gensym())
using UnallocatedArrays: UnallocatedArrays
using Aqua: Aqua
using Test: @testset

@testset "Code quality (Aqua.jl)" begin
  # TODO: This is broken, it seems to struggle with packages
  # that have unregistered dependencies. Add this back.
  # Aqua.test_all(UnallocatedArrays)
end
end
