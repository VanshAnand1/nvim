return {
	{
		"Mofiqul/dracula.nvim",
		lazy = false,
		priority = 1000, -- Load first to prevent visual flashes
		config = function()
			-- Initial setup (Solid Background)
			require("dracula").setup({
				transparent_bg = false,
			})
			
			-- Set default theme on startup
			vim.cmd("colorscheme dracula-soft")

			-- Custom Theme Cycler (Solid <-> Transparent)
			_G.ThemeState = 1
			vim.keymap.set("n", "<leader>tt", function()
				if _G.ThemeState == 1 then
					-- Switch to State 2: Transparent
					_G.ThemeState = 2
					require("dracula").setup({ transparent_bg = true })
					vim.cmd("colorscheme dracula-soft")
					
					-- Hard-override core backgrounds to ensure Kitty's terminal color bleeds through
					vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
					vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
					vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
					vim.api.nvim_set_hl(0, "LineNr", { bg = "none" })
					vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "none" })
					
					print("Theme: Dracula Soft (Transparent)")
				else
					-- Switch to State 1: Solid
					_G.ThemeState = 1
					require("dracula").setup({ transparent_bg = false })
					vim.cmd("colorscheme dracula-soft")
					print("Theme: Dracula Soft (Solid)")
				end
			end, { desc = "Toggle Theme (Solid <-> Transparent)" })
		end,
	},
}
