using Literate: Literate
using UnallocatedArrays: UnallocatedArrays

Literate.markdown(
  joinpath(pkgdir(UnallocatedArrays), "examples", "README.jl"),
  joinpath(pkgdir(UnallocatedArrays), "docs", "src");
  flavor=Literate.DocumenterFlavor(),
  name="index",
)
