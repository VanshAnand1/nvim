-- D: Command
-- M: Option
-- C: Control
-- leader: Space Bar
-- S: Shift
-- CR: Enter
-- Tab: Tab
-- KEYBINDS:
-- save and close
vim.keymap.set({ "n", "v", "i" }, "<D-s>", vim.cmd.w)
vim.keymap.set({ "n", "i", "v" }, "<D-d>", vim.cmd.q)

-- ijkl remapping
vim.keymap.set({ "n", "v" }, "h", "i", { remap = false, desc = "Insert Mode" })
vim.keymap.set({ "n", "v" }, "H", "I", { remap = false, desc = "Insert at Line Start" })

vim.keymap.set({ "n", "v", "o" }, "j", "<Left>", { remap = false, desc = "Move Left" })
vim.keymap.set({ "n", "v", "o" }, "l", "<Right>", { remap = false, desc = "Move Right" })
vim.keymap.set({ "n", "v", "o" }, "k", "v:count1 . 'gj'", { expr = true, remap = false, desc = "Move Down" })
vim.keymap.set({ "n", "v", "o" }, "i", "v:count1 . 'gk'", { expr = true, remap = false, desc = "Move Up" })

vim.keymap.set({ "n", "v", "o" }, "<S-j>", "<S-Left>")
vim.keymap.set({ "n", "v", "o" }, "<S-l>", "<S-Right>")

vim.keymap.set("v", "I", ":m '<-2<CR>gv=gv", { desc = "Move block up" })
vim.keymap.set("v", "K", ":m '>+1<CR>gv=gv", { desc = "Move block down" })

-- Window Movement
vim.keymap.set("n", "<M-j>", "<C-w><C-h>", { desc = "Window Left" })
vim.keymap.set("n", "<M-k>", "<C-w><C-j>", { desc = "Window Down" })
vim.keymap.set("n", "<M-i>", "<C-w><C-k>", { desc = "Window Up" })
vim.keymap.set("n", "<M-l>", "<C-w><C-l>", { desc = "Window Right" })

-- Neotree
vim.keymap.set("n", "<leader>f", vim.cmd.Neotree, { desc = "Open Neotree" })
vim.keymap.set("n", "yp", ":let @+ = expand('%:p')<CR>") -- copy the path of the file

-- Line Movement
vim.keymap.set("n", "I", "{", { desc = "Move up one code block" })
vim.keymap.set("n", "K", "}", { desc = "Move down one code block" })

vim.keymap.set("n", "J", "b", { desc = "Move left by one word" })
vim.keymap.set("n", "L", "w", { desc = "Move right by one word" })

-- Custom movement/insert map
vim.keymap.set("n", "H", "^i", { desc = "Insert at start of line" })

-- Buffer Sizing and Location
vim.keymap.set({ "n", "t", "v", "i" }, "<D-.>", "<C-w>>")
vim.keymap.set({ "n", "t", "v", "i" }, "<D-,>", "<C-w><")
vim.keymap.set("n", "<D-Left>", "<C-w>H")
vim.keymap.set("n", "<D-Right>", "<C-w>L")
vim.keymap.set("n", "<D-Up>", "<C-w>K")
vim.keymap.set("n", "<D-Down>", "<C-w>J")
vim.keymap.set("n", "<leader>v", "<C-w>v", { desc = "Vertical Split" })
vim.keymap.set("n", "<leader>h", "<C-w>s", { desc = "Horizontal Split" })
vim.keymap.set("n", "<S-Tab>", vim.cmd.bnext)

-- Terminal
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>")

-- Misc
vim.keymap.set("n", "x", '"_x') -- does not copy when deleting single character
vim.keymap.set("n", "s", '"_s') -- does not copy when replacing single character
vim.keymap.set({ "n", "v" }, ">", ">gv") -- stays highlighted when indenting
vim.keymap.set({ "n", "v" }, "<", "<gv") -- stays highlighted when un-indenting
vim.keymap.set("n", "n", "nzz") -- centres search query forwards
vim.keymap.set("n", "N", "Nzz") -- centres search query backwards
vim.keymap.set("n", "<Tab>", function()
	-- Start insert mode natively at the cursor position
	vim.cmd("startinsert")

	-- Feed a literal tab character to be typed immediately after entering insert mode
	local tab = vim.api.nvim_replace_termcodes("<Tab>", true, false, true)
	vim.api.nvim_feedkeys(tab, "n", false)
end)
vim.keymap.set("n", "<Esc>", vim.cmd.nohlsearch, { desc = "Clear search highlight" })


-- Clipboard
-- Map 'd', 'D', and 'x' to the black hole register (never copy to clipboard)
vim.keymap.set({ 'n', 'v' }, 'd', '"_d', { silent = true })
vim.keymap.set({ 'n', 'v' }, 'D', '"_D', { silent = true })
vim.keymap.set('n', 'x', '"_x', { silent = true })
-- Stop 'c' (like cw, ce) and 'C' from copying replaced text
vim.keymap.set({ 'n', 'v' }, 'c', '"_c', { silent = true })
vim.keymap.set({ 'n', 'v' }, 'C', '"_C', { silent = true })

-- When pasting over text in visual mode, do not copy the replaced text
vim.keymap.set("v", "p", '"_dP', { silent = true })

-- Select All
vim.keymap.set({ "n", "v", "i" }, "<D-a>", "<Esc>ggVG", { desc = "Select All" })
