-- The parts of LazyVim's snacks setup worth keeping. See `:help snacks`.
return {
	"folke/snacks.nvim",
	lazy = false,
	priority = 1000,
	opts = {
		bigfile = { enabled = true },
		quickfile = { enabled = true },
		indent = { enabled = true },
		scope = { enabled = true },
		scroll = { enabled = true },
		input = { enabled = true },
		notifier = { enabled = true },
		-- Highlights LSP references of the symbol under the cursor; ]] / [[ jump between them
		-- (mapped in init.lua's LspAttach).
		words = { enabled = true },
		lazygit = {},
	},
	keys = {
		{
			"<leader>lg",
			function()
				-- The current file's repository, falling back to the cwd.
				Snacks.lazygit({ cwd = Snacks.git.get_root() })
			end,
			desc = "Open [L]azy[G]it",
		},
		{
			"<leader>n",
			function()
				Snacks.notifier.show_history()
			end,
			desc = "[N]otification history",
		},
	},
}
