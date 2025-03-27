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
    canonical="https://itensor.github.io/UnallocatedArrays.jl",
    edit_link="main",
    assets=["assets/favicon.ico", "assets/extras.css"],
  ),
  pages=["Home" => "index.md", "Reference" => "reference.md"],
)

deploydocs(;
  repo="github.com/ITensor/UnallocatedArrays.jl", devbranch="main", push_preview=true
)
