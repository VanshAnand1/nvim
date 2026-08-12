return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	---@type snacks.Config
	opts = {
		bigfile = { enabled = true },

		--Dashboard
		dashboard = {
			pane_gap = 5,
			width = 70,
			preset = {
				header = [[
      ████ ██████           █████      ██                btw
     ███████████             █████ 
     █████████ ███████████████████ ███   ███████████
    █████████  ███    █████████████ █████ ██████████████
   █████████ ██████████ █████████ █████ █████ ████ █████
 ███████████ ███    ███ █████████ █████ █████ ████ █████
██████  █████████████████████ ████ █████ █████ ████ ██████
]],
			},

			sections = {
				function()
					math.randomseed(os.time()) -- Seed the random generator

					-- List of preset colors
					local colors = {
						"#f07341", -- Red-Orange
						"#44c772", -- Green
						"#3357FF", -- Blue
						-- "#FF33A8", -- Pink
						-- "#F3FF33", -- Yellow
						"#33FFF3", -- Cyan
						"#A833FF", -- Purple
					}
					local color = colors[math.random(1, #colors)]

					vim.cmd(string.format("highlight SnacksDashboardHeader guifg=%s", color))

					return { section = "header", align = "left", padding = 0 }
				end,
				{
					align = "center",
					padding = 1,
					text = {
						{ "  Update ", hl = "@keyword" },
						{ " 󰒲 Lazy ", hl = "@property" },
						{ "  Last Session ", hl = "Number" },
						{ "  Files ", hl = "DiagnosticInfo" },
						{ "  Grep ", hl = "@string" },
					},
				},
				{ pane = 1, icon = "󰏓 ", title = "Projects", section = "projects", indent = 2, padding = 1 },
				{ pane = 1, icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
				{ section = "startup" },

				{ text = "", action = ":Lazy update", key = "u", hidden = true },
				{ text = "", action = ":Lazy", key = "L", hidden = true },
				{ text = "", section = "session", key = "S", hidden = true },
				{ text = "", action = ":lua Snacks.dashboard.pick('files')", key = "f", hidden = true },
				{ text = "", action = ":lua Snacks.dashboard.pick('live_grep')", key = "g", hidden = true },
				{ text = "", action = "z8<Right>", hidden = true, key = "c" },
			},
		},

		-- rest of the snacks stuff
		indent = { enabled = true },
		input = { enabled = true },
		notifier = {
			enabled = true,
			timeout = 3000,
		},
		picker = { enabled = true },
		quickfile = { enabled = true },
		scroll = { enabled = true },
		statuscolumn = { enabled = true },
		words = { enabled = true },
		styles = {
			notification = {
				-- wo = { wrap = true } -- Wrap notifications
			},
		},
		image = { backend = "kitty" },
	},
	keys = {
		{
			"<leader>hm",
			function()
				Snacks.dashboard()
			end,
			desc = "launch HoMe screen",
		},
		{
			"<leader>fs",
			function()
				Snacks.picker.smart()
			end,
			desc = "Find Smart",
		},
		{
			"<leader>ff",
			function()
				Snacks.picker.files()
			end,
			desc = "Find Files",
		},
		{
			"<leader>fg",
			function()
				Snacks.picker.grep()
			end,
			desc = "Find with Grep",
		},
		{
			"<leader>ut",
			function()
				Snacks.picker.undo()
			end,
			desc = "Undotree",
		},
		{
			"<leader>z",
			function()
				Snacks.zen()
			end,
			desc = "Toggle Zen Mode",
		},
		{
			"<leader>Z",
			function()
				Snacks.zen.zoom()
			end,
			desc = "Toggle Zoom",
		},
		{
			"<leader>.",
			function()
				Snacks.scratch()
			end,
			desc = "Toggle Scratch Buffer",
		},
		{
			"<leader>S",
			function()
				Snacks.scratch.select()
			end,
			desc = "Select Scratch Buffer",
		},
		{
			"<leader>n",
			function()
				Snacks.notifier.show_history()
			end,
			desc = "Notification History",
		},
		{
			"<leader>x",
			function()
				Snacks.bufdelete()
			end,
			desc = "Delete Buffer",
		},
		{
			"<leader>rf",
			function()
				Snacks.rename.rename_file()
			end,
			desc = "Rename File",
		},
		{
			"<leader>go",
			function()
				Snacks.gitbrowse()
			end,
			desc = "Git Browse",
			mode = { "n", "v" },
		},
		{
			"<leader>gb",
			function()
				Snacks.git.blame_line()
			end,
			desc = "Git Blame Line",
		},
		{
			"<leader>gf",
			function()
				Snacks.lazygit.log_file()
			end,
			desc = "Lazygit Current File History",
		},
		{
			"<leader>gg",
			function()
				Snacks.lazygit()
			end,
			desc = "Lazygit",
		},
		{
			"<leader>gl",
			function()
				Snacks.lazygit.log()
			end,
			desc = "Lazygit Log (cwd)",
		},
		{
			"<leader>un",
			function()
				Snacks.notifier.hide()
			end,
			desc = "Dismiss All Notifications",
		},
        {
			"<D-/>",
			function()
				-- Uses .focus to prevent closing when unfocused, while keeping the height limit
				Snacks.terminal.focus(nil, { win = { position = "bottom", height = 8 } })
			end,
			desc = "Focus Terminal",
		},
		{
			"<leader>/",
			function()
				-- Uses .focus for the vertical terminal (vim.o.shell keeps it an independent instance)
				Snacks.terminal.focus(vim.o.shell, { win = { position = "right", width = 60 } })
			end,
			desc = "Focus Vertical Terminal",
		},	
        {
        "]]",
			function()
				Snacks.words.jump(vim.v.count1)
			end,
			desc = "Next Reference",
			mode = { "n", "t" },
		},
		{
			"[[",
			function()
				Snacks.words.jump(-vim.v.count1)
			end,
			desc = "Prev Reference",
			mode = { "n", "t" },
		},
		{
			"<leader>N",
			desc = "Neovim News",
			function()
				Snacks.win({
					file = vim.api.nvim_get_runtime_file("doc/news.txt", false)[1],
					width = 0.6,
					height = 0.6,
					wo = {
						spell = false,
						wrap = false,
						signcolumn = "yes",
						statuscolumn = " ",
						conceallevel = 3,
					},
				})
			end,
		},
	},

	init = function()
		vim.api.nvim_create_autocmd("User", {
			pattern = "VeryLazy",
			callback = function()
				-- Setup some globals for debugging (lazy-loaded)
				_G.dd = function(...)
					Snacks.debug.inspect(...)
				end
				_G.bt = function()
					Snacks.debug.backtrace()
				end
				vim.print = _G.dd -- Override print to use snacks for `:=` command

				-- Create some toggle mappings
				Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
				Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
				Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
				Snacks.toggle.diagnostics():map("<leader>ud")
				Snacks.toggle.line_number():map("<leader>ul")
				Snacks.toggle
					.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 })
					:map("<leader>uc")
				Snacks.toggle.treesitter():map("<leader>uT")
				Snacks.toggle
					.option("background", { off = "light", on = "dark", name = "Dark Background" })
					:map("<leader>ub")
				Snacks.toggle.inlay_hints():map("<leader>uh")
				Snacks.toggle.indent():map("<leader>ug")
				Snacks.toggle.dim():map("<leader>uD")
			end,
		})
	end,
}
