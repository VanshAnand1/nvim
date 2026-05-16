-- D: Command
-- M: Option
-- C: Control
-- leader: Space Bar
-- S: Shift
-- CR: Enter
-- KEYBINDS:
-- save and close
vim.keymap.set({"n", "v", "i"}, "<D-s>", vim.cmd.w)
vim.keymap.set({"n", "i", "v"}, "<D-d>", vim.cmd.q)

-- ijkl remapping
vim.keymap.set({"n", "v"}, "h", "i", { remap = false, desc = "Insert Mode" })
vim.keymap.set({"n", "v"}, "H", "I", { remap = false, desc = "Insert at Line Start" })

vim.keymap.set({"n", "v", "o"}, "j", "<Left>", { remap = false, desc = "Move Left" })
vim.keymap.set({"n", "v", "o"}, "l", "<Right>", { remap = false, desc = "Move Right" })
vim.keymap.set({"n", "v", "o"}, "k", "v:count1 . 'gj'", { expr = true, remap = false, desc = "Move Down" })
vim.keymap.set({"n", "v", "o"}, "i", "v:count1 . 'gk'", { expr = true, remap = false, desc = "Move Up" })

-- Window Movement
vim.keymap.set("n", "<M-j>", "<C-w><C-h>", { desc = "Window Left" })
vim.keymap.set("n", "<M-k>", "<C-w><C-j>", { desc = "Window Down" })
vim.keymap.set("n", "<M-i>", "<C-w><C-k>", { desc = "Window Up" })
vim.keymap.set("n", "<M-l>", "<C-w><C-l>", { desc = "Window Right" })

-- Neotree
vim.keymap.set("n", "<leader>f", vim.cmd.Neotree, {desc = "Open Neotree"})
vim.keymap.set("n", "yp", ":let @+ = expand('%:p')<CR>") -- copy the path of the file

-- Line Movement
vim.keymap.set("v", "K", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "I", ":m '<-2<CR>gv=gv")

-- Buffer Sizing and Location
vim.keymap.set({ "n", "t", "v", "i" }, "<D-.>", "<C-w>>")
vim.keymap.set({ "n", "t", "v", "i" }, "<D-,>", "<C-w><")
vim.keymap.set("n", "<D-Left>", "<C-w>H")
vim.keymap.set("n", "<D-Right>", "<C-w>L")
vim.keymap.set("n", "<D-Up>", "<C-w>K")
vim.keymap.set("n", "<D-Down>", "<C-w>J")
vim.keymap.set("n", "<leader>v", "<C-w>v", { desc = "Vertical Split" })
vim.keymap.set("n", "<leader>h", "<C-w>s", { desc = "Horizontal Split" })
vim.keymap.set('n', '<Tab>', vim.cmd.bnext)
vim.keymap.set('n', '<S-Tab>', vim.cmd.bprevious)

-- Terminal
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>")

-- Misc
vim.keymap.set("n", "x", '"_x') -- does not copy when deleting single character
vim.keymap.set("n", "s", '"_s') -- does not copy when replacing single character
vim.keymap.set({"n", "v"}, ">", ">gv") -- stays highlighted when indenting
vim.keymap.set({"n", "v"}, "<", "<gv") -- stays highlighted when un-indenting
vim.keymap.set("n", "n", "nzz") -- centres search query forwards
vim.keymap.set("n", "N", "Nzz") -- centres search query backwards
vim.keymap.set("n", "<Esc>", vim.cmd.nohlsearch) -- unhighlights after search

-- Clipboard
vim.keymap.set("v", "<M-y>", '"+<LeftRight>y', { remap = false, desc = "Copy selection to system clipboard" })
vim.keymap.set("n", "<M-y>", '"+<LeftRight>y<LeftRight>y', { remap = false, desc = "Copy current line to system clipboard" })
vim.keymap.set({"n", "v"}, "<M-p>", '"+<LeftRight>p', { remap = false, desc = "Paste from system clipboard" })

