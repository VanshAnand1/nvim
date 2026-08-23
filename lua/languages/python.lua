local function getPythonPath()
	-- Check for an active virtual environment first
	local venv = vim.env.VIRTUAL_ENV
	if venv then
		return venv .. "/bin/python"
	end
	-- Fall back to system path
	return vim.fn.exepath("python3") ~= "" and vim.fn.exepath("python3") or vim.fn.exepath("python")
end

return {
	-- Dropped black, Ruff handles formatting now
	mason_packages = { "pyright", "ruff", "debugpy" },

	-- Removed linters table (Ruff LSP provides diagnostics)
	-- Use Ruff for formatting
	formatters = { python = { "ruff" } },

	lsp = {
		{
			name = "pyright",
			config = {
				settings = {
					python = {
						pythonPath = getPythonPath(),
						analysis = {
							typeCheckingMode = "basic",
							autoSearchPaths = true,
							useLibraryCodeForTypes = true,
							diagnosticMode = "workspace",
							diagnosticSeverityOverrides = {
								-- Turn off noisy type warnings
								reportUnknownVariableType = "none",
								reportUnknownMemberType = "none",
								reportUnknownArgumentType = "none",
								reportUnknownParameterType = "none",
								reportMissingParameterType = "none",
								reportMissingTypeArgument = "none",
								reportUnknownLambdaType = "none",
								reportArgumentType = "none",

								-- DISABLED: Let Ruff handle these to prevent duplicate diagnostics
								reportUnusedImport = "none",
								reportUnusedVariable = "none",
								reportUndefinedVariable = "none",

								-- Keep useful Pyright-specific warnings
								reportGeneralTypeIssues = "warning",
								reportOptionalMemberAccess = "warning",
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
