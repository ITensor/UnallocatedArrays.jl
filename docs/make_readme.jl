using Literate: Literate
using UnallocatedArrays: UnallocatedArrays

Literate.markdown(
  joinpath(pkgdir(UnallocatedArrays), "examples", "README.jl"),
  joinpath(pkgdir(UnallocatedArrays));
  flavor=Literate.CommonMarkFlavor(),
  name="README",
)
