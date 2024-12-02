
## TODO: These are broken, fix them. Also, split off into a
## seperate test file, and maybe make a package extension?
@eval module $(gensym())
using FillArrays: Fill, Zeros
using UnallocatedArrays: UnallocatedFill, UnallocatedZeros
using TypeParameterAccessors:
  Position, default_type_parameter, nparameters, set_type_parameter, type_parameter
using Test: @test, @testset

#@testset "SetParameters" begin
@testset "Testing $typ" for typ in (Fill, Zeros)
  t1 = default_type_parameter(typ, Position{1}())
  t2 = default_type_parameter(typ, Position{2}())
  t3 = default_type_parameter(typ, Position{3}())
  t4 = Any
  ft1 = typ{t1}
  ft2 = typ{t1,t2}
  ft3 = typ{t1,t2,t3}

  ## check 1 parameter specified
  ftn1 = set_type_parameter(ft1, Position{1}(), t4)
  ftn2 = set_type_parameter(ft1, Position{2}(), t4)
  ftn3 = set_type_parameter(ft1, Position{3}(), t4)
  @test ftn1 == typ{t4}
  @test ftn2 == typ{t1,t4}
  @test ftn3 == typ{t1,<:Any,t4}

  ## check 2 parameters specified
  ftn1 = set_type_parameter(ft2, Position{1}(), t4)
  ftn2 = set_type_parameter(ft2, Position{2}(), t4)
  ftn3 = set_type_parameter(ft2, Position{3}(), t4)
  @test ftn1 == typ{t4,t2}
  @test ftn2 == typ{t1,t4}
  @test ftn3 == typ{t1,t2,t4}

  ## check 3 parameters specified
  ftn1 = set_type_parameter(ft3, Position{1}(), t4)
  ftn2 = set_type_parameter(ft3, Position{2}(), t4)
  ftn3 = set_type_parameter(ft3, Position{3}(), t4)
  @test ftn1 == typ{t4,t2,t3}
  @test ftn2 == typ{t1,t4,t3}
  @test ftn3 == typ{t1,t2,t4}

  @test type_parameter(ft3, Position{1}()) == t1
  @test type_parameter(ft3, Position{2}()) == t2
  @test type_parameter(ft3, Position{3}()) == t3

  @test nparameters(ft3) == 3
end

@testset "Testing $typ" for typ in (UnallocatedFill, UnallocatedZeros)
  t1 = default_type_parameter(typ, Position{1}())
  t2 = default_type_parameter(typ, Position{2}())
  t3 = default_type_parameter(typ, Position{3}())
  t4 = default_type_parameter(typ, Position{4}())
  t5 = Any
  ft = typ{t1,t2,t3,t4}

  ## check 4 parameters specified
  ftn1 = set_type_parameter(ft, Position{1}(), t5)
  ftn2 = set_type_parameter(ft, Position{2}(), t5)
  ftn3 = set_type_parameter(ft, Position{3}(), t5)
  ftn4 = set_type_parameter(ft, Position{4}(), t5)
  @test ftn1 == typ{t5,t2,t3,t4}
  @test ftn2 == typ{t1,t5,t3,t4}
  @test ftn3 == typ{t1,t2,t5,t4}
  @test ftn4 == typ{t1,t2,t3,t5}

  @test type_parameter(ft, Position{1}()) == t1
  @test type_parameter(ft, Position{2}()) == t2
  @test type_parameter(ft, Position{3}()) == t3
  @test type_parameter(ft, Position{4}()) == t4

  @test nparameters(ft) == 4
end
end
