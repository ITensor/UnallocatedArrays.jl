using UnallocatedArrays: UnallocatedArrays
using Documenter: Documenter, DocMeta, deploydocs, makedocs

DocMeta.setdocmeta!(
  UnallocatedArrays, :DocTestSetup, :(using UnallocatedArrays); recursive=true
)

include("make_index.jl")

makedocs(;
  modules=[UnallocatedArrays],
  authors="ITensor developers <support@itensor.org> and contributors",
  sitename="UnallocatedArrays.jl",
  format=Documenter.HTML(;
    canonical="https://ITensor.github.io/UnallocatedArrays.jl",
    edit_link="main",
    assets=String[],
  ),
  pages=["Home" => "index.md"],
)

deploydocs(;
  repo="github.com/ITensor/UnallocatedArrays.jl", devbranch="main", push_preview=true
)
