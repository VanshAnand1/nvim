-- ============================================================================
-- Make Build System Integration with vim-dispatch
-- ============================================================================
-- Features:
-- - Async make execution with quickfix integration
-- - Auto-detect Makefile targets and create keybindings dynamically
-- - Integrate with Trouble for better error display
-- - Edit CFLAGS/CXXFLAGS directly in Makefile via :MakeFlags command
--
-- Keybindings (auto-created when Makefile detected):
-- <leader>mm / <F5> - Build (default target)
-- <leader>ms        - Select target interactively
-- <leader>mc        - Clean (if target exists)
-- <leader>mr / <F6> - Run (if target exists)
-- <leader>mt        - Test (if target exists)
-- <leader>mi        - Install (if target exists)
-- ============================================================================

-- ============================================================================
-- Configuration
-- ============================================================================

-- Filetype to Makefile variable mapping (easy to extend)
local FLAG_VAR_MAP = {
	c = "CFLAGS",
	cpp = "CXXFLAGS",
	cxx = "CXXFLAGS",
	-- Add more as needed: rust = "RUSTFLAGS", go = "GOFLAGS", etc.
}

-- Target configurations for dynamic keybinding setup
local TARGET_CONFIGS = {
	{
		name = "clean",
		keys = { "<leader>mc" },
		func_type = "qf",
		desc = "Clean",
	},
	{
		name = "run",
		keys = { "<leader>mr", "<F6>" },
		func_type = "sync",
		desc = "Run",
	},
	{
		name = "test",
		keys = { "<leader>mt" },
		func_type = "qf",
		desc = "Test",
	},
	{
		name = "install",
		keys = { "<leader>mi" },
		func_type = "qf",
		desc = "Install",
	},
}

-- ============================================================================
-- Core Functions
-- ============================================================================

-- Check if a Makefile exists in the current directory
local function has_makefile()
	return vim.fn.filereadable("Makefile") == 1
		or vim.fn.filereadable("makefile") == 1
		or vim.fn.filereadable("GNUmakefile") == 1
end

-- Run make target with quickfix (async execution, populates quickfix list)
local function make_qf(target)
	vim.cmd("silent! wall") -- Save all files
	local cmd = target and ("Make " .. target) or "Make"

	-- Listen for when dispatch finishes populating quickfix
	local augroup = vim.api.nvim_create_augroup("make_check_result", { clear = true })

	vim.api.nvim_create_autocmd("QuickFixCmdPost", {
		group = augroup,
		pattern = "make",
		once = true,
		callback = function()
			vim.defer_fn(function()
				local qf_list = vim.fn.getqflist()

				-- Count only actual errors and warnings (not info messages)
				local has_errors = false
				for _, item in ipairs(qf_list) do
					if item.type == "E" or item.type == "W" or item.valid == 1 then
						has_errors = true
						break
					end
				end

				if has_errors then
					vim.cmd("cclose")
					vim.cmd("Trouble qflist toggle")
				else
					vim.notify("Build successful!", vim.log.levels.INFO)
				end
				pcall(vim.api.nvim_del_augroup_by_name, "make_check_result")
			end, 100)
		end,
	})

	vim.cmd(cmd)
end

-- Run make target in foreground (blocking execution)
local function make_sync(target)
	vim.cmd("silent! wall")
	local cmd = target and ("Make! " .. target) or "Make!"
	vim.cmd(cmd)
end

-- ============================================================================
-- Makefile Utilities
-- ============================================================================

-- Get available targets from Makefile
local function get_makefile_targets()
	local targets = {}
	local ok, lines = pcall(vim.fn.readfile, "Makefile")
	if ok then
		for _, line in ipairs(lines) do
			local target = line:match("^([%w_-]+):")
			if target and not target:match("^%.") then
				targets[target] = true
			end
		end
	end
	return targets
end

-- Interactive target selection
local function select_target()
	local available_targets = get_makefile_targets()
	local targets = {}

	for target, _ in pairs(available_targets) do
		table.insert(targets, target)
	end
	table.sort(targets)

	if #targets == 0 then
		targets = { "clean", "test", "install", "run" }
	end

	vim.ui.select(targets, {
		prompt = "Select Make target:",
	}, function(choice)
		if choice then
			make_qf(choice)
		end
	end)
end

-- Edit compile flags in Makefile (used by :MakeFlags command)
local function set_compile_flags()
	local ft = vim.bo.filetype
	local flag_var = FLAG_VAR_MAP[ft]

	if not flag_var then
		vim.notify("No flag variable configured for filetype: " .. ft, vim.log.levels.WARN)
		return
	end

	local ok, lines = pcall(vim.fn.readfile, "Makefile")
	if not ok then
		vim.notify("No Makefile found", vim.log.levels.ERROR)
		return
	end

	-- Find current flags
	local current_flags = ""
	for _, line in ipairs(lines) do
		local flags = line:match("^" .. flag_var .. "%s*[:=]%s*(.*)$")
		if flags then
			current_flags = flags
			break
		end
	end

	-- Prompt for new flags
	vim.ui.input({
		prompt = flag_var .. ": ",
		default = current_flags,
	}, function(input)
		if input == nil then
			return
		end

		-- Update or add the flags line
		local found = false
		for i, line in ipairs(lines) do
			if line:match("^" .. flag_var .. "%s*[:=]") then
				lines[i] = flag_var .. " = " .. input
				found = true
				break
			end
		end

		-- If not found, add it at the top (after comments)
		if not found then
			local insert_pos = 1
			for i, line in ipairs(lines) do
				if not line:match("^%s*#") and not line:match("^%s*$") then
					insert_pos = i
					break
				end
			end
			table.insert(lines, insert_pos, flag_var .. " = " .. input)
		end

		-- Write back to Makefile
		vim.fn.writefile(lines, "Makefile")
		vim.notify(flag_var .. " updated in Makefile", vim.log.levels.INFO)

		-- Reload Makefile buffer if open
		for _, buf in ipairs(vim.api.nvim_list_bufs()) do
			if vim.api.nvim_buf_is_loaded(buf) then
				local bufname = vim.api.nvim_buf_get_name(buf)
				if bufname:match("Makefile$") or bufname:match("makefile$") then
					vim.api.nvim_buf_call(buf, function()
						vim.cmd("edit!")
					end)
				end
			end
		end
	end)
end

-- ============================================================================
-- Keybinding Setup
-- ============================================================================

-- Setup keybindings based on available Makefile targets
local function setup_keymaps()
	local map = vim.keymap.set
	local del = vim.keymap.del
	local opts = { silent = true }
	local targets = get_makefile_targets()

	-- Always available: build and select
	map("n", "<leader>mm", function()
		make_qf()
	end, vim.tbl_extend("force", opts, { desc = "Build" }))
	map("n", "<leader>ms", select_target, vim.tbl_extend("force", opts, { desc = "Select Target" }))
	map("n", "<F5>", function()
		make_qf()
	end, vim.tbl_extend("force", opts, { desc = "Build" }))

	-- Conditional keybindings based on available targets
	for _, config in ipairs(TARGET_CONFIGS) do
		if targets[config.name] then
			-- Target exists, create keymaps
			local func = config.func_type == "sync" and function()
				make_sync(config.name)
			end or function()
				make_qf(config.name)
			end

			for _, key in ipairs(config.keys) do
				map("n", key, func, vim.tbl_extend("force", opts, { desc = config.desc }))
			end
		else
			-- Target doesn't exist, remove keymaps
			for _, key in ipairs(config.keys) do
				pcall(del, "n", key)
			end
		end
	end
end

-- ============================================================================
-- Plugin Configuration
-- ============================================================================

return {
	{
		"tpope/vim-dispatch",
		event = "VeryLazy",
		config = function()
			-- Configure dispatch settings
			vim.g.dispatch_no_tmux_make = 1
			vim.opt.makeprg = "make"

			-- Set up errorformat for C/C++ compiler errors
			vim.opt.errorformat = {
				"%f:%l:%c: %trror: %m",
				"%f:%l:%c: %tarning: %m",
				"%f:%l: %trror: %m",
				"%f:%l: %tarning: %m",
				'%*[^"]"%f"%*\\D%l: %m',
				'"%f"%*\\D%l: %m',
				"%-G%.%#",
			}

			-- Create command for setting compile flags
			vim.api.nvim_create_user_command("MakeFlags", set_compile_flags, {
				desc = "Edit CFLAGS/CXXFLAGS in Makefile",
			})

			-- Auto-setup keybindings when Makefile is detected
			vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
				pattern = { "Makefile", "makefile", "GNUmakefile", "*.mk" },
				callback = setup_keymaps,
			})

			-- Re-setup keybindings when Makefile is saved
			vim.api.nvim_create_autocmd("BufWritePost", {
				pattern = { "Makefile", "makefile", "GNUmakefile", "*.mk" },
				callback = function()
					setup_keymaps()
					vim.notify("Make keybindings updated", vim.log.levels.INFO)
				end,
			})

			-- Setup immediately if already in a directory with Makefile
			vim.schedule(function()
				if has_makefile() then
					setup_keymaps()
				end
			end)
		end,
	},
}
