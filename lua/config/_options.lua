
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- tab changes
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- line numbers
vim.opt.relativenumber = true
vim.opt.number = true

-- Misc
vim.opt.wrap = false
vim.opt.incsearch = true
vim.opt.mouse = "nv"
vim.g.dispatch_no_maps = 1

-- LangMenu
vim.api.nvim_create_user_command("LangMenu", function()
	require("languages.menu").select_languages()
end, { desc = "Open language selection menu" })
