-- D: Command
-- A: Option
-- C: Control
-- leader: Space Bar
-- S: Shift
-- CR: Enter
-- KEYBINDS:
-- save and close
vim.keymap.set({"n", "v", "i"}, "<D-s>", vim.cmd.w)
vim.keymap.set({"n", "i", "v"}, "<D-d>", vim.cmd.q)

-- Neotree
vim.keymap.set("n", "<leader>f", vim.cmd.Neotree, {desc = "Open Neotree"})
vim.keymap.set("n", "yp", ":let @+ = expand('%:p')<CR>") -- copy the path of the file

-- Line Movement
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Buffer Movement
vim.keymap.set("n", "<D-j>", "<C-w><C-j>")
vim.keymap.set("n", "<D-k>", "<C-w><C-k>")
vim.keymap.set("n", "<D-h>", "<C-w><C-h>")
vim.keymap.set("n", "<D-l>", "<C-w><C-l>")

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
vim.keymap.set({"n"}, ">", ">gv") -- stays highlighted when indenting
vim.keymap.set({"n"}, "<", "<gv") -- stays highlighted when un-indenting
vim.keymap.set("n", "n", "nzz") -- centres search query forwards
vim.keymap.set("n", "N", "Nzz") -- centres search query backwards
vim.keymap.set("n", "<Esc>", vim.cmd.nohlsearch) -- unhighlights after search

