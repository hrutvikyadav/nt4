return {
    --- todo: these configuration from lspconfig maybe broken
    single_file_support = true,
    root_dir = function()
        return vim.fn.getcwd()
    end,
    --- See [Tinymist Server Configuration](https://github.com/Myriad-Dreamin/tinymist/blob/main/Configuration.md) for references.
    settings = {
        exportPdf = "onSave",
        outputPath = "$root/target/$dir/$name",
        formatterMode = "typstyle",
    }
}
