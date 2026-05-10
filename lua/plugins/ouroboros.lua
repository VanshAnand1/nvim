return {
	"jakemason/ouroboros",
	dependencies = {
		{ "nvim-lua/plenary.nvim" },
	},
    config = function()
        vim.keymap.set("n", "<leader>hf", ":Ouroboros<CR>")
    end
}
