return {
	mason_packages = { "typescript-language-server", "prettier" },
	formatters = {
		javascript = { "prettier" },
		javascriptreact = { "prettier" },
		typescript = { "prettier" },
		typescriptreact = { "prettier" },
		svelte = { "prettier" },
		vue = { "prettier" },
	},

	lsp = {
		name = "ts_ls",
		config = {
			settings = {
				filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "svelte", "vue" },
			},
		},
	},
}
