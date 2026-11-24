-- Minimal debugger: nvim-dap only (no UI plugins). Uses built-in dap.repl and dap.ui.widgets.
return {
	{
		"mfussenegger/nvim-dap",
		keys = {
			{ "<F5>", function() require("dap").continue() end, desc = "Debug: Start/Continue" },
			{ "<F10>", function() require("dap").step_over() end, desc = "Debug: Step Over" },
			{ "<F11>", function() require("dap").step_into() end, desc = "Debug: Step Into" },
			{ "<F12>", function() require("dap").step_out() end, desc = "Debug: Step Out" },
			{ "<leader>bb", function() require("dap").toggle_breakpoint() end, desc = "[B]reakpoint toggle" },
			{
				"<leader>bc",
				function() require("dap").set_breakpoint(vim.fn.input("Condition: ")) end,
				desc = "[B]reakpoint [C]onditional",
			},
			{ "<leader>br", function() require("dap").repl.toggle() end, desc = "Debug [R]EPL (gdb/lldb cmds)" },
			{ "<leader>bh", function() require("dap.ui.widgets").hover() end, mode = { "n", "v" }, desc = "Debug [H]over value" },
			{
				"<leader>bs",
				function()
					local w = require("dap.ui.widgets")
					w.centered_float(w.scopes)
				end,
				desc = "Debug [S]copes",
			},
			{ "<leader>bq", function() require("dap").terminate() end, desc = "Debug [Q]uit" },
		},
		config = function()
			local dap = require("dap")
			vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticError" })
			vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DiagnosticOk", linehl = "Visual" })

			dap.adapters.codelldb = {
				type = "server",
				port = "${port}",
				executable = {
					command = vim.fn.stdpath("data") .. "/mason/bin/codelldb",
					args = { "--port", "${port}" },
				},
			}

			local configs = {
				{
					name = "Launch executable",
					type = "codelldb",
					request = "launch",
					program = function()
						return vim.fn.input("Executable: ", vim.fn.getcwd() .. "/", "file")
					end,
					args = function()
						return vim.split(vim.fn.input("Args: "), " ", { trimempty = true })
					end,
					cwd = "${workspaceFolder}",
					stopOnEntry = false,
				},
				{
					name = "Attach to PID",
					type = "codelldb",
					request = "attach",
					pid = require("dap.utils").pick_process,
					cwd = "${workspaceFolder}",
				},
			}
			dap.configurations.c = configs
			dap.configurations.cpp = configs
			dap.configurations.rust = configs
		end,
	},
}
