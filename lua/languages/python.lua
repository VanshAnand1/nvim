local function getPythonPath()
    return vim.fn.exepath("python3") ~= "" and vim.fn.exepath("python3") or vim.fn.exepath("python")
end

return {
	mason_packages = { "pyright", "ruff", "black", "debugpy" },
	linters = { python = { "ruff" } },
	formatters = { python = { "black" } },

	-- Multiple LSP servers: Pyright for type checking, Ruff for linting/code actions
	lsp = {
		{
			name = "pyright",
			config = {
				settings = {
					python = {
						-- Explicitly set Python path (pyright will use this to find stdlib)
						pythonPath = getPythonPath(),
						analysis = {
							-- Use 'basic' instead of 'strict' - much less noisy
							typeCheckingMode = "basic",
							-- Auto-search for virtualenvs
							autoSearchPaths = true,
							useLibraryCodeForTypes = true,
							-- Better import resolution
							diagnosticMode = "workspace",
							-- Disable unnecessary warnings
							diagnosticSeverityOverrides = {
								-- Turn off noisy type warnings
								reportUnknownVariableType = "none",
								reportUnknownMemberType = "none",
								reportUnknownArgumentType = "none",
								reportUnknownParameterType = "none",
								reportMissingParameterType = "none",
								reportMissingTypeArgument = "none",
								reportUnknownLambdaType = "none",

								-- Keep useful warnings
								reportUnusedImport = "warning",
								reportUnusedVariable = "warning",
								reportUndefinedVariable = "error",
								reportGeneralTypeIssues = "Warning",
								reportOptionalMemberAccess = "warning",
                                reportArgumentType = "none"
							},
						},
					},
				},
			},
		},
		{
			name = "ruff",
			config = {
				on_attach = function(client, bufnr)
					-- Disable hover in favor of Pyright
					client.server_capabilities.hoverProvider = false
				end,
			},
		},
	},
}
