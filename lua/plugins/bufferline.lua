return {
	"akinsho/bufferline.nvim",
	dependencies = {
		"moll/vim-bbye",
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		require("bufferline").setup({
			options = {
				mode = "buffers", -- set to "tabs" to only show tabpages instead
				themable = true, -- allows highlight groups to be overriden i.e. sets highlights as default
				numbers = "none", -- | "ordinal" | "buffer_id" | "both" | function({ ordinal, id, lower, raise }): string,
				close_command = "Bdelete! %d", -- can be a string | function, see "Mouse actions"
				buffer_close_icon = "✗",
				close_icon = "✗",
				path_components = 1, -- Show only the file name without the directory
				modified_icon = "●",
				left_trunc_marker = "",
				right_trunc_marker = "",
				max_name_length = 30,
				max_prefix_length = 30, -- prefix used when a buffer is de-duplicated
				tab_size = 21,
				diagnostics = false,
				diagnostics_update_in_insert = false,
				color_icons = true,
				show_buffer_icons = true,
				show_buffer_close_icons = true,
				show_close_icon = true,
				persist_buffer_sort = true, -- whether or not custom sorted buffers should persist
				separator_style = { "│", "│" }, -- | "thick" | "thin" | { 'any', 'any' },
				enforce_regular_tabs = true,
				always_show_bufferline = true,
				show_tab_indicators = false,
				indicator = {
					-- icon = '▎', -- this should be omitted if indicator style is not 'icon'
					style = "none", -- Options: 'icon', 'underline', 'none'
				},
				icon_pinned = "󰐃",
				minimum_padding = 1,
				maximum_padding = 5,
				maximum_length = 15,
				sort_by = "insert_at_end",

				-- Hide .h files UNLESS they're modified
				custom_filter = function(buf_number, buf_numbers)
					local buf_name = vim.fn.bufname(buf_number)

					-- If it's a header file, only show if modified
					if buf_name:match("%.h$") then
						return vim.bo[buf_number].modified
					end

					return true
				end,
			},

			highlights = {
				separator = {
					fg = "#434C5E",
				},
				buffer_selected = {
					bold = true,
					italic = false,
				},
				-- separator_selected = {},
				-- tab_selected = {},
				-- background = {},
				-- indicator_selected = {},
				-- fill = {},
			},
		})
		-- Helper function to check if buffer should be skipped
		local function should_skip_buffer(buf)
			local buf_name = vim.fn.bufname(buf)
			-- Skip header files unless modified
			if buf_name:match("%.h$") then
				return not vim.bo[buf].modified
			end
			return false
		end

		-- Custom cycle next that skips header files
		local function cycle_next()
			local current = vim.fn.bufnr("%")
			local buffers = vim.fn.getbufinfo({ buflisted = 1 })

			-- Find current buffer index
			local current_idx = 1
			for i, buf in ipairs(buffers) do
				if buf.bufnr == current then
					current_idx = i
					break
				end
			end

			-- Cycle to next valid buffer
			local next_idx = current_idx % #buffers + 1
			local attempts = 0
			while should_skip_buffer(buffers[next_idx].bufnr) and attempts < #buffers do
				next_idx = next_idx % #buffers + 1
				attempts = attempts + 1
			end

			vim.cmd("buffer " .. buffers[next_idx].bufnr)
		end

		-- Custom cycle previous that skips header files
		local function cycle_prev()
			local current = vim.fn.bufnr("%")
			local buffers = vim.fn.getbufinfo({ buflisted = 1 })

			-- Find current buffer index
			local current_idx = 1
			for i, buf in ipairs(buffers) do
				if buf.bufnr == current then
					current_idx = i
					break
				end
			end

			-- Cycle to previous valid buffer
			local prev_idx = current_idx - 1
			if prev_idx < 1 then
				prev_idx = #buffers
			end
			local attempts = 0
			while should_skip_buffer(buffers[prev_idx].bufnr) and attempts < #buffers do
				prev_idx = prev_idx - 1
				if prev_idx < 1 then
					prev_idx = #buffers
				end
				attempts = attempts + 1
			end

			vim.cmd("buffer " .. buffers[prev_idx].bufnr)
		end

		-- Keymaps for cycling (skips header files)
		vim.keymap.set("n", "<Tab>", cycle_next, { desc = "Next buffer (skip headers)" })
		vim.keymap.set("n", "<S-Tab>", cycle_prev, { desc = "Previous buffer (skip headers)" })

		-- Quick toggle between .c and .h files
		vim.keymap.set("n", "<leader>a", function()
			local current_file = vim.fn.expand("%")
			local alternate_file

			if current_file:match("%.c$") then
				alternate_file = current_file:gsub("%.c$", ".h")
			elseif current_file:match("%.h$") then
				alternate_file = current_file:gsub("%.h$", ".c")
			else
				print("Not a .c or .h file")
				return
			end

			if vim.fn.filereadable(alternate_file) == 1 then
				vim.cmd("edit " .. alternate_file)
			else
				print("Corresponding file not found: " .. alternate_file)
			end
		end, { desc = "Toggle between .c and .h" })

		-- Auto-refresh bufferline when buffer is modified/saved
		vim.api.nvim_create_autocmd({ "BufModifiedSet", "BufWritePost" }, {
			pattern = "*.h",
			callback = function()
				-- Force bufferline to refresh its filter
				vim.cmd("redrawtabline")
			end,
		})
	end,
}
