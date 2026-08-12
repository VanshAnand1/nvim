return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
	},
	lazy = false, -- neo-tree will lazily load itself
	opts = {
		window = {
            width = 25,
			mappings = {
				["i"] = function()
					vim.cmd("normal! k")
				end, -- Move selection UP
				["k"] = function()
					vim.cmd("normal! j")
				end, -- Move selection DOWN
				["j"] = "close_node", -- Left arrow behavior: Closes folder
				["l"] = "open", -- Right arrow behavior: Opens folder or file
				["h"] = "show_help", -- Put the help menu onto your 'h' key
			},
		},
	},
}
