return {
	"mfussenegger/nvim-dap",
	dependencies = {
		-- The Python adapter adapter
		"mfussenegger/nvim-dap-python",
		-- A beautiful UI for the debugger
		"rcarriga/nvim-dap-ui",
		-- Required dependency for dap-ui
		"nvim-neotest/nvim-nio",
	},
	config = function()
		local dap = require("dap")
		local dapui = require("dapui")
		local dap_python = require("dap-python")

		-- 1. Setup the DAP UI
		dapui.setup()

		-- 2. Automatically open/close the UI when debugging starts/stops
		dap.listeners.after.event_initialized["dapui_config"] = function()
			dapui.open()
		end
		dap.listeners.before.event_terminated["dapui_config"] = function()
			dapui.close()
		end
		dap.listeners.before.event_exited["dapui_config"] = function()
			dapui.close()
		end

		-- 3. Point dap-python to the debugpy installed by Mason
		-- Mason installs packages in standard Neovim data paths
		local mason_path = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python"
		dap_python.setup(mason_path)

		-- 4. Keymaps (Using standard F-keys to avoid conflicts with custom navigation)
		vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Debug: Toggle Breakpoint" })
		vim.keymap.set("n", "<leader>dB", function()
			dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
		end, { desc = "Debug: Conditional Breakpoint" })
		
		vim.keymap.set("n", "<F5>", dap.continue, { desc = "Debug: Start/Continue" })
		vim.keymap.set("n", "<F10>", dap.step_over, { desc = "Debug: Step Over" })
		vim.keymap.set("n", "<F11>", dap.step_into, { desc = "Debug: Step Into" })
		vim.keymap.set("n", "<F12>", dap.step_out, { desc = "Debug: Step Out" })
		vim.keymap.set("n", "<leader>dq", dap.terminate, { desc = "Debug: Terminate" })
	end,
}
