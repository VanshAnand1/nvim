return {
    mason_packages = {
        "clangd",
        "clang-format",
    },
    formatters = {
        cpp = { "clang-format" },
        c = { "clang-format" },
    },
    linters = {},
    plugins = {
        -- plugins and config here
    },
    lsp = {
        name = "clangd",
        config = {
            -- lsp config here
        }
    },
}
