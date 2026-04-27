using Documenter: Documenter, DocMeta, deploydocs, makedocs
using ITensorFormatter: ITensorFormatter
using UnallocatedArrays: UnallocatedArrays

DocMeta.setdocmeta!(
    UnallocatedArrays, :DocTestSetup, :(using UnallocatedArrays); recursive = true
)

ITensorFormatter.make_index!(pkgdir(UnallocatedArrays))

makedocs(;
    modules = [UnallocatedArrays],
    authors = "ITensor developers <support@itensor.org> and contributors",
    sitename = "UnallocatedArrays.jl",
    format = Documenter.HTML(;
        canonical = "https://itensor.github.io/UnallocatedArrays.jl",
        edit_link = "main",
        assets = ["assets/favicon.ico", "assets/extras.css"]
    ),
    pages = ["Home" => "index.md", "Reference" => "reference.md"]
)

deploydocs(;
    repo = "github.com/ITensor/UnallocatedArrays.jl", devbranch = "main",
    push_preview = true
)
