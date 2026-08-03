--
-- -- Quick Toggles
-- local style = "wave" -- Choices: wave (classic dark), dragon (very dark), lotus (light)
-- local transparent = false
--
-- return {
--   "rebelot/kanagawa.nvim",
--   lazy = false,
--   priority = 1000,
--   opts = {
--     compile = false,
--     undercurl = true,
--     transparent = transparent,
--     theme = style,
--     background = {
--       dark = style,
--       light = "lotus"
--     },
--   },
--   config = function(_, opts)
--     vim.opt.termguicolors = true
--     require("kanagawa").setup(opts)
--     vim.cmd("colorscheme kanagawa")
--   end,
-- }

-- Quick Toggles
-- local style = "nordfox" -- Choices: nightfox, carbonfox, duskfox, nordfox, terafox
-- local transparent = false
--
-- return {
--   "EdenEast/nightfox.nvim",
--   lazy = false,
--   priority = 1000,
--   opts = {
--     options = {
--       transparent = transparent,
--       styles = {
--         comments = "italic",
--         keywords = "bold",
--         types = "italic,bold",
--       },
--     },
--   },
--   config = function(_, opts)
--     vim.opt.termguicolors = true
--     require("nightfox").setup(opts)
--     vim.cmd("colorscheme " .. style)
--   end,
-- }
--

-- return {
--   "rose-pine/neovim",
--   name = "rose-pine",
--   lazy = false,
--   priority = 1000,
--   opts = {
--     variant = "main", -- Deep berry/purple base
--     styles = {
--       bold = true,
--       italic = true,
--       transparency = false,
--     },
--     -- Force highlights to match the exact Ayaka Kitty terminal look
--     highlight_groups = {
--       Normal = { bg = "#1c1421", fg = "#e0def4" },       -- Deep plum background
--       NormalFloat = { bg = "#160f1b" },                  -- Slightly darker for menus
--       Comment = { fg = "#6e6a86", italic = true },       -- Subtle purple-gray comments
--       Keyword = { fg = "#ea9a97", bold = true },         -- Soft pink keywords
--       Function = { fg = "#31748f" },                     -- Muted blue/cyan functions
--       String = { fg = "#9ccfd8" },                       -- Ice-cyan strings
--       Statement = { fg = "#c4a7e7" },                    -- Lavender statements
--       Visual = { bg = "#2a1f35" },                       -- Custom selection highlight
--     },
--   },
--   config = function(_, opts)
--     vim.opt.termguicolors = true
--     require("rose-pine").setup(opts)
--     vim.cmd("colorscheme rose-pine")
--   end,
-- }


-- transparent background 
return {
  "catppuccin/nvim",
  name = "catppuccin",
  lazy = false,
  priority = 1000,
  opts = {
    flavour = "mocha",
    transparent_background = true, -- Inherits your Ayaka Kitty background!
    term_colors = true,
    integrations = {
      treesitter = true,
      native_lsp = { enabled = true },
    },
  },
  config = function(_, opts)
    vim.opt.termguicolors = true
    require("catppuccin").setup(opts)
    vim.cmd("colorscheme catppuccin")
  end,
}

