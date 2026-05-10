local langs = require("languages")
langs.setup()
local lsp = {
	-- Core LSP & tools
	{
		"williamboman/mason.nvim",
		dependencies = {
			"neovim/nvim-lspconfig",
			"mfussenegger/nvim-lint",
			"stevearc/conform.nvim",
			-- "mfussenegger/nvim-dap",
			-- "igorlfs/nvim-dap-view",
			{
				"folke/trouble.nvim",
				opts = {}, -- for default options, refer to the configuration section for custom setup.
				cmd = "Trouble",
				keys = {
					{
						"<leader>ce",
						"<cmd>Trouble diagnostics toggle<cr>",
						desc = "show Code Errors",
					},
					{
						"<leader>cs",
						"<cmd>Trouble symbols toggle focus=false<cr>",
						desc = "Code Symbols",
					},
					{
						"<leader>cl",
						"<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
						desc = "LSP Definitions / references / ...",
					},
					{
						"<leader>qf",
						"<cmd>Trouble qflist toggle<cr>",
						desc = "show Quick Fix",
					},
				},
			},
		},
		lazy = false,
		keys = {
			{
				"<leader>fm",
				function()
					require("conform").format({
						async = true,
						lsp_fallback = true,
					})
				end,
				desc = "ForMat code",
			},
		},

		config = function()
			-- install mason packages
			require("mason").setup()
			local mason_registry = require("mason-registry")
			for _, tool in ipairs(langs.mason_packages) do
				if not mason_registry.is_installed(tool) then
					mason_registry.get_package(tool):install()
				end
			end

			-- Setup linters
			local lint = require("lint")
			lint.linters_by_ft = langs.linters

			--linting on save
			vim.api.nvim_create_autocmd({ "BufWritePost" }, {
				callback = function()
					require("lint").try_lint()
				end,
			})

			require("conform").setup({
				formatters_by_ft = langs.formatters,
				formatters = {
					["clang-format"] = {
						prepend_args = { "-style=file:" .. vim.fn.expand("~/.clang-format") },
					},
				},
			})

			vim.lsp.enable(langs.lsp)

			vim.diagnostic.config({
				severity_sort = true,
				float = { border = "rounded", source = "if_many" },
				virtual_text = { current_line = false },
				virtual_lines = {
					current_line = true,
				},
				signs = vim.g.have_nerd_font and {
					text = {
						[vim.diagnostic.severity.ERROR] = "󰅚 ",
						[vim.diagnostic.severity.WARN] = "󰀪 ",
						[vim.diagnostic.severity.INFO] = "󰋽 ",
						[vim.diagnostic.severity.HINT] = "󰌶 ",
					},
				} or {},
				underline = { severity = vim.diagnostic.severity.ERROR },
				update_in_insert = false,
			})

			-- setup debugger
			-- local dap = require("dap")
			-- vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint, { desc = "toggle Breakpoint" })
			-- vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "Debug Continue" })
			--
			-- vim.fn.sign_define("DapBreakpoint", {
			-- 	text = " ",
			-- 	texthl = "ErrorMsg",
			-- })
		end,
	},
}

if langs.plugins then
	vim.list_extend(lsp, langs.plugins or {})
end

return lsp
