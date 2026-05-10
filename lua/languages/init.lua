local enabled = require("languages.enabled")
local M = {
    plugins = {},
    mason_packages = {},
    lsp = {},
    linters = {},
    formatters = {},
    _setup_done = false, -- Guard to prevent duplicate setup
}

M.setup = function()
    -- Only run setup once
    if M._setup_done then
        return
    end
    M._setup_done = true

    for _, lang in ipairs(enabled) do
        local ok, mod = pcall(require, "languages." .. lang)
        if not ok then goto continue end

        -- Collect plugins
        if mod.plugins then
            vim.list_extend(M.plugins, mod.plugins)
        end

        -- Collect Mason packages
        vim.list_extend(M.mason_packages, mod.mason_packages or {})


        -- Merge linter config
        if mod.linters then
            for ft, list in pairs(mod.linters) do
                M.linters[ft] = vim.tbl_extend("force", M.linters[ft] or {}, list)
            end
        end

        -- Merge formatter config
        if mod.formatters then
            for ft, formatters in pairs(mod.formatters) do
                -- Handle both string and table formats
                local fmt_list = type(formatters) == "string" and { formatters } or formatters
                M.formatters[ft] = vim.list_extend(M.formatters[ft] or {}, fmt_list)
            end
        end

        -- Configure LSP (support single or multiple LSP servers)
        if mod.lsp then
            -- Convert single LSP to array for uniform handling
            local lsp_configs = {}
            if mod.lsp.name then
                -- Single LSP: { name = "pyright", config = {...} }
                lsp_configs = { mod.lsp }
            elseif type(mod.lsp) == "table" and #mod.lsp > 0 then
                -- Multiple LSPs: { {name = "pyright", config = {...}}, {name = "ruff", config = {...}} }
                lsp_configs = mod.lsp
            end

            -- Setup each LSP server
            for _, lsp_config in ipairs(lsp_configs) do
                if lsp_config.name then
                    local server = lsp_config.name
                    local overrides = lsp_config.config or {}

                    -- Use lspconfig for defaults (filetype associations, root_dir, etc.)
                    local lsp_ok, lspconfig = pcall(require, "lspconfig")
                    if lsp_ok and lspconfig[server] then
                        lspconfig[server].setup(overrides)
                    end

                    table.insert(M.lsp, server)
                end
            end
        end

        -- Extra setup
        if mod.extra then mod.extra() end

        ::continue::
    end
end

return M
